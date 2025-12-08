
import '/flutter_flow/flutter_flow_util.dart';

import 'to_do_list_screen1_widget.dart' show ToDoListScreen1Widget;
import 'package:flutter/material.dart';


class ToDoListScreen1Model extends FlutterFlowModel<ToDoListScreen1Widget> {
  ///  State fields for stateful widgets in this page.

  // State field(s) for TextField widget.
  FocusNode? textFieldFocusNode;
  TextEditingController? textController;
  String? Function(BuildContext, String?)? textControllerValidator;

  @override
  void initState(BuildContext context) {}

  @override
  void dispose() {
    textFieldFocusNode?.dispose();
    textController?.dispose();
  }
}
