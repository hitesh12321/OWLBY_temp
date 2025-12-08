import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:just_audio/just_audio.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';

import 'package:owlby_serene_m_i_n_d_s/backend/api_requests/api_calls.dart';
import 'package:owlby_serene_m_i_n_d_s/flutter_flow/uploaded_file.dart';
import 'package:owlby_serene_m_i_n_d_s/local_database/db/task_database.dart';

import '../models/recording_model.dart';

class RecordingProvider extends ChangeNotifier {
  // ------------------------------------------------------------
  // Core dependencies
  // ------------------------------------------------------------
  final FlutterSoundRecorder _recorder = FlutterSoundRecorder();
  final AudioPlayer _player = AudioPlayer();
  final db = OwlbyDatabase.instance;

  bool _recorderInited = false;

  // ------------------------------------------------------------
  // State
  // ------------------------------------------------------------
  bool _isRecording = false;
  bool _isPaused = false;
  bool _isPlaying = false;

  String? _filePath;

  // For UI meter / pitch label compatibility
  double _currentDb = 0.0;      // real dB from flutter_sound
  double _currentRms = 0.0;     // 0..1 mapped from dB for your progress bar
  double _currentPitch = 0.0;   // we’re not computing pitch here, keep 0

  List<RecordingModel> recordings = [];

  // onProgress subscription
  StreamSubscription<RecordingDisposition>? _recSub;

  // ------------------------------------------------------------
  // Getters used by UI
  // ------------------------------------------------------------
  bool get isRecording => _isRecording;
  bool get isPaused => _isPaused;
  bool get isPlaying => _isPlaying;
  String? get filePath => _filePath;

  double get currentDb => _currentDb;
  double get currentRms => _currentRms;
  double get currentPitch => _currentPitch; // always 0 for now

  RecordingProvider() {
    _initRecorder();
    loadRecordings();
  }

  // ------------------------------------------------------------
  // Init recorder once
  // ------------------------------------------------------------
  Future<void> _initRecorder() async {
    if (_recorderInited) return;

    final status = await Permission.microphone.request();
    if (!status.isGranted) {
      throw Exception('Microphone permission denied');
    }

    await _recorder.openRecorder();
    _recorderInited = true;
  }

  // ------------------------------------------------------------
  // Load saved recordings from local DB
  // ------------------------------------------------------------
  Future<void> loadRecordings() async {
    recordings = await db.fetch();
    notifyListeners();
  }

  // ------------------------------------------------------------
  // Start recording
  // ------------------------------------------------------------
  Future<void> start() async {
    await _initRecorder();
    if (!_recorderInited) {
      throw Exception('Recorder not initialized');
    }

    final dir = await getApplicationDocumentsDirectory();
    final fileName = 'recording_${DateTime.now().millisecondsSinceEpoch}.m4a';
    final path = '${dir.path}/$fileName';

    _filePath = path;

    await _recorder.startRecorder(
      toFile: path,
      codec: Codec.aacMP4,
      bitRate: 128000,
      sampleRate: 44100,
    );

    _isRecording = true;
    _isPaused = false;

    // Stream decibels and map to [0, 1] for your LinearProgressIndicator
    _recSub?.cancel();
    _recSub = _recorder.onProgress?.listen((event) {
      _currentDb = event.decibels ?? 0.0;

      // flutter_sound dB is typically around -60..0
      final mapped = ((_currentDb + 60.0) / 60.0).clamp(0.0, 1.0);
      _currentRms = mapped;

      notifyListeners();
    });

    notifyListeners();
  }

  // ------------------------------------------------------------
  // Pause recording
  // ------------------------------------------------------------
  Future<void> pause() async {
    if (!_isRecording) return;

    await _recorder.pauseRecorder();
    _isPaused = true;
    notifyListeners();
  }

  // ------------------------------------------------------------
  // Resume recording
  // ------------------------------------------------------------
  Future<void> resume() async {
    if (!_isRecording) return;

    await _recorder.resumeRecorder();
    _isPaused = false;
    notifyListeners();
  }

  // ------------------------------------------------------------
  // Stop recording (does not save to DB)
  // ------------------------------------------------------------
  Future<void> stop() async {
    if (!_isRecording) return;

    try {
      await _recorder.stopRecorder();
    } catch (_) {
      // ignore
    }

    _isRecording = false;
    _isPaused = false;

    _recSub?.cancel();
    _currentDb = 0.0;
    _currentRms = 0.0;

    notifyListeners();
  }

  // ------------------------------------------------------------
  // Stop recording and save to local DB
  // ------------------------------------------------------------
  Future<RecordingModel> stopAndSave(String title) async {
    await stop();

    if (_filePath == null) {
      throw Exception('File path is null');
    }

    final file = File(_filePath!);
    if (!await file.exists()) {
      throw Exception('Recorded file missing on disk');
    }

    final now = DateTime.now();
    final modelWithoutId = RecordingModel(
      filePath: _filePath!,
      title: title,
      createdAt: now,
    );

    // Insert into DB and get auto-generated id
    final id = await db.insert(modelWithoutId);

    final saved = RecordingModel(
      id: id,
      filePath: modelWithoutId.filePath,
      title: modelWithoutId.title,
      createdAt: modelWithoutId.createdAt,
    );

    recordings.insert(0, saved);
    notifyListeners();

    return saved;
  }

  // ------------------------------------------------------------
  // Playback using just_audio
  // ------------------------------------------------------------
  Future<void> play(String filePath) async {
    await _player.stop();

    _isPlaying = true;
    notifyListeners();

    _player.playbackEventStream.listen(
      (_) {},
      onDone: () {
        _isPlaying = false;
        notifyListeners();
      },
    );

    await _player.setFilePath(filePath);
    await _player.play();
  }

  Future<void> stopPlay() async {
    await _player.stop();
    _isPlaying = false;
    notifyListeners();
  }

  // ------------------------------------------------------------
  // Upload recording with your existing API
  // ------------------------------------------------------------
  Future<dynamic> uploadRecording({
    required String meetingId,
    required String userId,
    required String professionalName,
    required String authToken,
    required String filePath,
  }) async {
    final file = File(filePath);
    final bytes = await file.readAsBytes();

    final res = await UploadrecordingCall.call(
      meetingId: meetingId,
      userId: userId,
      professionalName: professionalName,
      authToken: authToken,
      file: FFUploadedFile(
        name: file.uri.pathSegments.last,
        bytes: bytes,
      ),
    );

    return res;
  }

  // ------------------------------------------------------------
  // Delete recording (DB + file)
  // ------------------------------------------------------------
  Future<void> deleteRecording(int id, String filePath) async {
    await db.deleteRecording(id);

    final f = File(filePath);
    if (await f.exists()) {
      await f.delete();
    }

    recordings.removeWhere((e) => e.id == id);
    notifyListeners();
  }

  @override
  void dispose() {
    _recSub?.cancel();
    _recorder.closeRecorder();
    _player.dispose();
    super.dispose();
  }
}
