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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
        title: const Text('Edit Session Details'),
      ),
      body: const Center(
        child: Text('Edit Session Details Screen'),
      ),
    );
  }
}
