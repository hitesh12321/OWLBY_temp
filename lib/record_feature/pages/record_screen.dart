import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:owlby_serene_m_i_n_d_s/appUser/app_user_provider.dart';
import 'package:owlby_serene_m_i_n_d_s/backend/api_requests/api_calls.dart';
import 'package:owlby_serene_m_i_n_d_s/flutter_flow/flutter_flow_util.dart';
import 'package:owlby_serene_m_i_n_d_s/flutter_flow/uploaded_file.dart';
import 'package:owlby_serene_m_i_n_d_s/local_database/db/project_database.dart';

import 'package:owlby_serene_m_i_n_d_s/session_details_screen/session_details_screen_widget.dart';
import 'package:provider/provider.dart';
import 'package:owlby_serene_m_i_n_d_s/record_feature/providers/recording_provider.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/services.dart';

class RecordScreenWidget extends StatelessWidget {
  const RecordScreenWidget({super.key});

  // mentioning this here to remember what we are using is goroute

  static String routeName = 'RecordScreen';
  static String routePath = '/RecordScreen';

  @override
  Widget build(BuildContext context) {
    return _RecordScreenBody();
  }
}

class _RecordScreenBody extends StatefulWidget {
  const _RecordScreenBody();

  @override
  State<_RecordScreenBody> createState() => _RecordScreenBodyState();
}

class _RecordScreenBodyState extends State<_RecordScreenBody> {
  final TextEditingController _titleController = TextEditingController();
  final createMeetingcall = CreatemeetingCall();
  final db = OwlbyDatabase.instance;

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // Provider.of<RecordingProvider>(context, listen: false).loadRecordings();
  }

  Future<void> _showSaveDialog(
      BuildContext context, RecordingProvider prov) async {
    _titleController.text = '';
    final user = context.read<AppUserProvider>().user;

    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (c) => AlertDialog(
        title: const Text('Save Recording'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(hintText: 'Enter title'),
            ),
            const SizedBox(height: 8),
            Text(
              'The recording will be saved locally.',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(c, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(c, true),
            child: const Text('Save'),
          ),
        ],
      ),
    );

    if (result == true) {
      print("Dialog OK pressed");

      final titleText = _titleController.text.trim();
      final title = titleText.isEmpty ? 'Recording' : titleText;

      try {
        print("🤙🤙🤙🤙🤙🤙Calling stopAndSave💾💾💾💾💾...");
        // local session saved here
        final SessionSaved = await prov.stopAndSave(title);

        //// 🙌🙌🙌🙌🙌🙌🙌🙌🙌🙌🙌🙌🙌🙌🙌🙌🙌🙌🙌🙌🙌🙌🙌🙌//

        final CreateMeetingId = await CreatemeetingCall.call(
            userId: user!.id,
            meetingDate:
                DateFormat('yyyy-MM-dd').format(SessionSaved.createdAt),
            meetingTime: DateFormat('HH:mm').format(SessionSaved.createdAt),
            duration: 30,
            professionalName: user.fullName);

        final CreateMeetingCallApi_body = CreateMeetingId.jsonBody;
        final bool s_tatus = CreateMeetingCallApi_body["status"];
        final String meetingStatus;

        if (s_tatus) {
          meetingStatus = "meeting created ";
        } else {
          meetingStatus = "meeting creation failed ";
        }
        await prov.changeRecordingStatus(
          SessionSaved.recordingId,
          meetingStatus,
        );

        final updatedRecording = prov.recordings.firstWhere(
          (r) => r.recordingId == SessionSaved.recordingId,
        );

        print("meeting id status : ${updatedRecording.status}");

        // await Navigator.push(
        //   context,
        //   MaterialPageRoute(
        //     builder: (context) => NavBarPage(),
        //   ),
        // );
        final meeting_id = CreateMeetingCallApi_body["data"]["id"];

        final fileBytes = await File(SessionSaved.filePath).readAsBytes();
        final ffFile = FFUploadedFile(
          name: "recording.wav", // or mp3, whatever your format
          bytes: fileBytes, // IMPORTANT
          originalFilename: "recording.wav",
        );
        // uploading meeting to backend

        final Session_id_by_upload_meeting = await UploadrecordingCall.call(
            meetingId: meeting_id,
            userId: user.id,
            professionalName: user.fullName,
            file: ffFile);
        print(Session_id_by_upload_meeting.jsonBody);

        await prov.changeRecordingStatus(
          SessionSaved.recordingId,
          "processing",
        );

        // we are getting data from backend
        final session_text = await ProcessmeetingCall.call(
            meetingId: meeting_id,
            meetingTitle: title,
            name: user.fullName,
            email: user.email,
            participants: "Client A",
            startTime: "2025-10-26T12:00:00Z",
            provider: "supabase");

        final body = session_text.jsonBody as Map<String, dynamic>;
        print("💕💕💕💕${body}");

        final analysis = body['analysis'] as Map<String, dynamic>;

        final String summary = analysis['summary'];
        final String notes = analysis['soap']; // or tips
        final String audio = body['audioUrl'];

        await prov.updateProcessedRecordingInMemory(
          SessionSaved.recordingId,
          summary: summary,
          notes: notes,
          status: "completed",
          audioUrl: audio,
        );

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(
                  "StopAndSave completed👍👍👍👍👍: ${SessionSaved.title}")),
        );
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => SessionDetailsScreenWidget(
              recording: prov.recordings.firstWhere(
                (r) => r.recordingId == SessionSaved.recordingId,
              ),
            ),
          ),
        );

        // ScaffoldMessenger.of(context).showSnackBar(
        //   SnackBar(
        //       content: Text(
        //           "StopAndSave completed👍👍👍👍👍: ${CreateMeetingCallApi_body}")),
        // );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Save failed😩😩😩😩😩😩😩: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final prov = Provider.of<RecordingProvider>(context);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent, // makes it blend
        statusBarIconBrightness: Brightness.light, // time/battery icons = WHITE
        statusBarBrightness: Brightness.dark,
      ),
      child: Scaffold(
        // ✅ FIX: This prevents the background from resizing/jumping when keyboard opens
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: const Text(
            'Recording',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 30,
              color: Colors.black,
            ),
          ),
          centerTitle: true,
          backgroundColor: FlutterFlowTheme.of(context).primary,
        ),
        body: LayoutBuilder(
          builder: (context, constraints) {
            final isWide = constraints.maxWidth > 600;
            final padding = EdgeInsets.symmetric(
                horizontal: isWide ? 80 : 20, vertical: 24);
            return Padding(
              padding: padding,
              child: Column(
                children: [
                  // Large status and meter
                  Card(
                    elevation: 6,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: [
                          Text(
                            prov.isRecording
                                ? (prov.isPaused ? 'Paused' : 'Recording...')
                                : (prov.isPlaying ? 'Playing' : 'Ready'),
                            style: TextStyle(
                                fontSize: 22, fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(height: 12),
                          // Simple amplitude meter
                          LinearProgressIndicator(
                            minHeight: 12,
                            value: (prov.currentRms.clamp(0.0, 1.0)),
                            backgroundColor: Colors.grey.shade300,
                          ),
                          const SizedBox(height: 12),
                          // Pitch display
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.music_note),
                              const SizedBox(width: 8),
                              Text(
                                prov.currentPitch > 0.0
                                    ? '${prov.currentPitch.toString()} Hz'
                                    : '— Hz',
                                style: const TextStyle(fontSize: 18),
                              ),
                              const SizedBox(width: 12),
                              Text(
                                prov.currentPitch > 0.0
                                    ? _pitchToNote(prov.currentPitch)
                                    : '',
                                style: const TextStyle(
                                    fontSize: 16, color: Colors.grey),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 140),
                  Center(
                    child: Column(
                      children: [
                        Text(
                          formatDuration(prov.recordingDuration),
                          style: TextStyle(
                            fontSize: 60,
                            fontWeight: FontWeight.bold,
                            color: prov.isRecording ? Colors.red : Colors.black,
                          ),
                        ),
                        Text("Recording Duration",
                            style: TextStyle(
                                fontSize: 18, color: Colors.grey.shade600)),
                      ],
                    ),
                  ),
                  Expanded(child: const SizedBox(height: 1)),

                  // Buttons row
                  Wrap(
                    alignment: WrapAlignment.center,
                    spacing: 16,
                    runSpacing: 12,
                    children: [
                      // Start / Stop & Save
                      FFButtonWidget(
                        onPressed: prov.isRecording
                            ? () => _showSaveDialog(context, prov)
                            : () async {
                                try {
                                  await prov.start();
                                } catch (e) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content: Text('Start failed: $e')));
                                }
                              },
                        text: prov.isRecording ? 'Stop & Save' : 'Start',
                        options: FFButtonOptions(
                          width: 140,
                          height: 48,
                          color:
                              prov.isRecording ? Colors.red : Color(0xFF2596BE),
                          textStyle:
                              FlutterFlowTheme.of(context).titleMedium.override(
                                    color: Colors.white,
                                  ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),

                      // Pause / Resume
                      FFButtonWidget(
                        onPressed: prov.isRecording
                            ? () async {
                                try {
                                  if (prov.isPaused) {
                                    await prov.resume();
                                  } else {
                                    await prov.pause();
                                  }
                                } catch (e) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content:
                                              Text('Pause/Resume err: $e')));
                                }
                              }
                            : null,
                        text: prov.isPaused ? 'Resume' : 'Pause',
                        options: FFButtonOptions(
                          width: 120,
                          height: 48,
                          color: prov.isRecording ? Colors.orange : Colors.grey,
                          textStyle:
                              FlutterFlowTheme.of(context).titleMedium.override(
                                    color: Colors.white,
                                  ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),

                      // Play / Stop playback
                      FFButtonWidget(
                        onPressed: prov.filePath != null
                            ? () async {
                                try {
                                  if (prov.isPlaying) {
                                    await prov.stopPlay();
                                  } else {
                                    await prov.play(prov.filePath!);
                                  }
                                } catch (e) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content: Text('Play error: $e')));
                                }
                              }
                            : null,
                        text: prov.isPlaying ? 'Stop' : 'Play',
                        options: FFButtonOptions(
                          width: 120,
                          height: 48,
                          color: prov.filePath != null
                              ? Colors.green
                              : Colors.grey,
                          textStyle:
                              FlutterFlowTheme.of(context).titleMedium.override(
                                    color: Colors.white,
                                  ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  String formatDuration(Duration d) {
    String two(int n) => n.toString().padLeft(2, '0');
    final h = two(d.inHours);
    final m = two(d.inMinutes.remainder(60));
    final s = two(d.inSeconds.remainder(60));
    return '$h:$m:$s';
  }
}

/// Helper to convert pitch to approximate note (very rough)
String _pitchToNote(double freq) {
  if (freq <= 0) return '';
  const a4 = 440.0;
  final midi = (69 + 12 * (log(freq / a4) / log(2))).round();
  final notes = [
    'C',
    'C#',
    'D',
    'D#',
    'E',
    'F',
    'F#',
    'G',
    'G#',
    'A',
    'A#',
    'B'
  ];
  final note = notes[(midi - 12) % 12];
  final octave = (midi ~/ 12) - 1;
  return '$note$octave';
}
