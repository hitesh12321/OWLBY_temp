import 'dart:io';

import 'package:flutter/material.dart';
import 'package:owlby_serene_m_i_n_d_s/Global/global_snackbar.dart';
import 'package:owlby_serene_m_i_n_d_s/appUser/app_user_provider.dart';
import 'package:owlby_serene_m_i_n_d_s/backend/api_requests/api_calls.dart';
import 'package:owlby_serene_m_i_n_d_s/flutter_flow/flutter_flow_util.dart';
import 'package:owlby_serene_m_i_n_d_s/flutter_flow/uploaded_file.dart';
import 'package:owlby_serene_m_i_n_d_s/home_screen/home_screen_widget.dart';
import 'package:owlby_serene_m_i_n_d_s/local_database/db/project_database.dart';

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
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<RecordingProvider>(context, listen: false).resetTimer();
    });
    // Provider.of<RecordingProvider>(context, listen: false).loadRecordings();
  }

  Future<void> _showSaveDialog(
      BuildContext context, RecordingProvider prov) async {
    _titleController.text = '';

    // Attempt to load user if provider is empty
    final appUserProvider = context.read<AppUserProvider>();
    if (appUserProvider.user == null) {
      await appUserProvider.loadUser();
    }

    final user = appUserProvider.user;

    // Safety check to prevent null operator error
    if (user == null) {
      AppSnackbar.showError(
          context, "User details not found. Please log in again.");
      // ScaffoldMessenger.of(context).showSnackBar(
      //   const SnackBar(
      //       content: Text("User details not found. Please log in again.")),
      // );
      return;
    }

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
            onPressed: () {
              Navigator.pop(c, true);
              Navigator.pop(context); // Close the recording screen
            },
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
        // RESTORED LOG
        print("🤙🤙🤙🤙🤙🤙Calling stopAndSave💾💾💾💾💾...");
        final SessionSaved = await prov.stopAndSave(title);

        // RESTORED LOG
        print("🙌🙌🙌🙌🙌🙌🙌🙌🙌🙌🙌🙌🙌🙌🙌🙌🙌🙌🙌🙌🙌🙌🙌🙌");

        final CreateMeetingId = await CreatemeetingCall.call(
            userId: user.id, // Safe access
            meetingDate:
                DateFormat('yyyy-MM-dd').format(SessionSaved.createdAt),
            meetingTime: DateFormat('HH:mm').format(SessionSaved.createdAt),
            duration: 30,
            professionalName: user.fullName);

        final CreateMeetingCallApi_body = CreateMeetingId.jsonBody;
        final bool s_tatus = CreateMeetingCallApi_body?["status"] ?? false;
        final String meetingStatus =
            s_tatus ? "meeting created " : "meeting creation failed ";

        await prov.changeRecordingStatus(
          SessionSaved.recordingId,
          meetingStatus,
        );

        final updatedRecording = prov.recordings.firstWhere(
          (r) => r.recordingId == SessionSaved.recordingId,
        );

        print("meeting id status : ${updatedRecording.status}");

        final meeting_id = CreateMeetingCallApi_body?["data"]?["id"];

        final fileBytes = await File(SessionSaved.filePath).readAsBytes();
        final ffFile = FFUploadedFile(
          name: "recording.wav",
          bytes: fileBytes,
          originalFilename: "recording.wav",
        );

        // RESTORED LOG
        print("meeting id :::${meeting_id} ,,,, file path::: ${ffFile}  ");

        final Session_id_by_upload_meeting = await UploadrecordingCall.call(
            meetingId: meeting_id,
            userId: user.id,
            professionalName: user.fullName,
            file: ffFile);

        // RESTORED LOG
        print(
            "✌️✌️✌️✌️✌️session id ✌️✌️✌️${Session_id_by_upload_meeting.jsonBody}");

        await prov.changeRecordingStatus(
          SessionSaved.recordingId,
          "processing",
        );

        final session_text = await ProcessmeetingCall.call(
            meetingId: meeting_id,
            meetingTitle: title,
            name: user.fullName,
            email: user.email,
            participants: "Client A",
            startTime: "2025-10-26T12:00:00Z",
            provider: "supabase");

        final body = session_text.jsonBody as Map<String, dynamic>?;

        // RESTORED LOG
        print("💕💕💕💕 Full Body: $body");

        final analysis = body?['analysis'] as Map<String, dynamic>?;

        if (analysis != null) {
          final String tips =
              analysis['tips']?.toString() ?? "No tips generated.";
          final String summary =
              analysis['summary']?.toString() ?? "No summary.";
          final String notes = analysis['soap']?.toString() ?? "No notes.";
          final String audio = body?['audioUrl']?.toString() ?? "";

          // RESTORED LOG
          print("❤️❤️ Tips Found: $tips ❤️❤️");
          print("❤️❤️$tips ,,,,, $notes❤️❤️");

          await prov.updateProcessedRecordingInMemory(
            SessionSaved.recordingId,
            summary: summary,
            notes: notes,
            status: "completed",
            audioUrl: audio,
            tips: tips,
          );
        } else {
          print("❌ Analysis field was null in the response");
        }
        AppSnackbar.showSuccess(
            context, "StopAndSave completed: ${SessionSaved.title}");
        // ScaffoldMessenger.of(context).showSnackBar(
        //   SnackBar(
        //       content: Text(
        //           "StopAndSave completed👍👍👍👍👍: ${SessionSaved.title}")),
        // );
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => const HomeScreenWidget()),
          (route) => false,
        );
      } catch (e) {
        // RESTORED LOG EMOJI
        AppSnackbar.showError(context, 'Save failed: $e');
        // ScaffoldMessenger.of(context).showSnackBar(
        //   SnackBar(content: Text('Save failed😩😩😩😩😩😩😩: $e')),
        // );
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
              fontSize: 35,
              color: Color.fromARGB(255, 0, 0, 0),
            ),
          ),
          centerTitle: true,
          backgroundColor: FlutterFlowTheme.of(context).primary,
        ),
        body: LayoutBuilder(
          builder: (context, constraints) {
            final isWide = constraints.maxWidth > 600;
            final padding = EdgeInsets.symmetric(
                horizontal: isWide ? 80 : 20, vertical: 40);
            return Padding(
              padding: padding,
              child: Column(
                children: [
                  // Large status and meter

                  SizedBox(height: 140),
                  Center(
                    child: Column(
                      children: [
                        Text(
                          formatDuration(prov.recordingDuration),
                          style: TextStyle(
                            fontSize: 80,
                            fontWeight: FontWeight.bold,
                            color: prov.isRecording ? Colors.red : Colors.black,
                          ),
                        ),
                        Text("Recording Duration",
                            style: TextStyle(
                                fontSize: 25,
                                color: Colors.grey.shade600,
                                fontWeight: FontWeight.w600)),
                      ],
                    ),
                  ),
                  Expanded(child: const SizedBox(height: 1)),

                  // Buttons row
                  Wrap(
                    alignment: WrapAlignment.center,
                    spacing: 40,
                    runSpacing: 12,
                    children: [
                      // Start / Stop & Save
                      FFButtonWidget(
                        onPressed: prov.isRecording
                            ? () async {
                                await prov.pause();
                                _showSaveDialog(context, prov);
                              }
                            : () async {
                                try {
                                  await prov.start();
                                } catch (e) {
                                  AppSnackbar.showError(
                                      context, 'Start failed: $e');
                                  // ScaffoldMessenger.of(context).showSnackBar(
                                  //     SnackBar(
                                  //         content: Text('Start failed: $e')));
                                }
                              },
                        text: prov.isRecording ? 'Stop & Save' : 'Start',
                        options: FFButtonOptions(
                          width: 140,
                          height: 60,
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
                                  AppSnackbar.showError(
                                      context, 'Pause/Resume err: $e');
                                  // ScaffoldMessenger.of(context).showSnackBar(
                                  //     SnackBar(
                                  //         content:
                                  //             Text('Pause/Resume err: $e')));
                                }
                              }
                            : null,
                        text: prov.isPaused ? 'Resume' : 'Pause',
                        options: FFButtonOptions(
                          width: 140,
                          height: 60,
                          color: prov.isRecording ? Colors.orange : Colors.grey,
                          textStyle:
                              FlutterFlowTheme.of(context).titleMedium.override(
                                    color: Colors.white,
                                  ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),

                      // Play / Stop playback
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
// String _pitchToNote(double freq) {
//   if (freq <= 0) return '';
//   const a4 = 440.0;
//   final midi = (69 + 12 * (log(freq / a4) / log(2))).round();
//   final notes = [
//     'C',
//     'C#',
//     'D',
//     'D#',
//     'E',
//     'F',
//     'F#',
//     'G',
//     'G#',
//     'A',
//     'A#',
//     'B'
//   ];
//   final note = notes[(midi - 12) % 12];
//   final octave = (midi ~/ 12) - 1;
//   return '$note$octave';
// }
