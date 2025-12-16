import 'package:flutter/material.dart';
import 'package:owlby_serene_m_i_n_d_s/record_feature/providers/recording_provider.dart';
import 'package:provider/provider.dart';

class SamplePage extends StatefulWidget {
  final String sessionText;

  const SamplePage({
    super.key,
    required this.sessionText,
  });

  @override
  State<SamplePage> createState() => _SamplePageState();
}

class _SamplePageState extends State<SamplePage> {
  @override
  Widget build(BuildContext context) {
    final SProv = Provider.of<RecordingProvider>(context);
    return Scaffold(
      // body: ListView.builder(
      //     itemCount: SProv.recordings.length,
      //     itemBuilder: (context, index) {
      //       return ListTile(
      //         title: Text(SProv.recordings[index].recordingId.toString()),
      //       );
      //     }),
      body: Text(widget.sessionText),
    );
  }
}
