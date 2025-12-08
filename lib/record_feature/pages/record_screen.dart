import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
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
    return ChangeNotifierProvider(
      create: (_) => RecordingProvider(),
      child: const _RecordScreenBody(),
    );
  }
}

class _RecordScreenBody extends StatefulWidget {
  const _RecordScreenBody();

  @override
  State<_RecordScreenBody> createState() => _RecordScreenBodyState();
}

class _RecordScreenBodyState extends State<_RecordScreenBody> {
  final TextEditingController _titleController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  @override
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Provider.of<RecordingProvider>(context, listen: false).loadRecordings();
  }

  Future<void> _showSaveDialog(
      BuildContext context, RecordingProvider prov) async {
    _titleController.text = '';

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
      final titleText = _titleController.text.trim();
      final title = titleText.isEmpty ? 'Recording' : titleText;

      try {
        // Stop and save to DB
        final saved = await prov.stopAndSave(title);

        // If later you want to upload, use prov.uploadRecording(...) here
        // with your meetingId / userId / professionalName / authToken.

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Saved: ${saved.title}')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Save failed: $e')),
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
                          "36:21:45",
                          style: TextStyle(
                              fontSize: 60, fontWeight: FontWeight.bold),
                        ),
                        Text("Recdoring Duration",
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

                  // Local file info & actions
                  // if (prov.recordings.isNotEmpty)
                  //   SizedBox(
                  //     height: 400, // or constraints.maxHeight * 0.5
                  //     child: ListView.builder(
                  //       itemCount: prov.recordings.length,
                  //       itemBuilder: (context, index) => Card(
                  //         child: ListTile(
                  //           title: Text(prov.recordings[index].title),
                  //           subtitle: Text(
                  //               prov.recordings[index].createdAt.toString()),
                  //         ),
                  //       ),
                  //     ),
                  //   ),
                ],
              ),
            );
          },
        ),
      ),
    );
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
