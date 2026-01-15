import 'package:flutter/material.dart';
import 'package:owlby_serene_m_i_n_d_s/flutter_flow/flutter_flow_theme.dart';
import 'package:owlby_serene_m_i_n_d_s/record_feature/models/recording_model.dart';

class EditSessiondetailsscreen extends StatefulWidget {
  final RecordingModel recording;

  const EditSessiondetailsscreen({super.key, required this.recording});

  @override
  State<EditSessiondetailsscreen> createState() =>
      _EditSessiondetailsscreenState();
}

class _EditSessiondetailsscreenState extends State<EditSessiondetailsscreen> {
  TextEditingController titleController = TextEditingController();
  TextEditingController summaryController = TextEditingController();
  TextEditingController soapNotesController = TextEditingController();
  TextEditingController tipsController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    titleController.text = widget.recording.title ?? '';
    summaryController.text = widget.recording.summary ?? '';
    soapNotesController.text = widget.recording.notes ?? '';
    tipsController.text = widget.recording.tips ?? '';
  }

  @override
  void dispose() {
    titleController.dispose();
    summaryController.dispose();
    soapNotesController.dispose();
    tipsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
        title: const Text('Edit Session Details'),
        actions: [
          Container(
            color: const Color.fromARGB(255, 217, 234, 218),
            child: IconButton(
              icon: const Icon(
                Icons.check,
                size: 30,
                color: Colors.green,
                fill: 1,
              ),
              onPressed: () {
                final updatedRecording = widget.recording.copyWith(
                  title: titleController.text,
                  summary: summaryController.text,
                  notes: soapNotesController.text,
                  tips: tipsController.text,
                );

                Navigator.pop(context, updatedRecording);
              },
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Text("Edit Session Title",
                      style: FlutterFlowTheme.of(context).titleMedium),
                  TextField(
                    controller: titleController,
                    minLines: 1,
                    maxLines: null,
                    keyboardType: TextInputType.multiline,
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Text("Edit Session Summary",
                      style: FlutterFlowTheme.of(context).titleMedium),
                  TextField(
                    controller: summaryController,
                    minLines: 1, // start with 1 line
                    maxLines: null, // grow automatically
                    keyboardType: TextInputType.multiline,
                    decoration: InputDecoration(
                      labelText: 'Session Summary',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Text("Edit SOAP Notes",
                      style: FlutterFlowTheme.of(context).titleMedium),
                  TextField(
                    controller: soapNotesController,
                    minLines: 1, // start with 1 line
                    maxLines: null, // grow automatically
                    keyboardType: TextInputType.multiline,
                    decoration: InputDecoration(
                      labelText: 'SOAP Notes',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Text("Edit Tips & Recommendations",
                      style: FlutterFlowTheme.of(context).titleMedium),
                  TextField(
                    controller: tipsController,
                    minLines: 1, // start with 1 line
                    maxLines: null, // grow automatically
                    keyboardType: TextInputType.multiline,
                    decoration: InputDecoration(
                      labelText: 'Tips & Recommendations',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
