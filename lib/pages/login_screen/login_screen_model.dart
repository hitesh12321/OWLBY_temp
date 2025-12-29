import '/flutter_flow/flutter_flow_util.dart';
import 'login_screen_widget.dart' show LoginScreenWidget;
import 'package:flutter/material.dart';

class LoginScreenModel extends FlutterFlowModel<LoginScreenWidget> {
  // Model should own the controller
  TextEditingController? phoneController;

  @override
  void initState(BuildContext context) {
    phoneController = TextEditingController();
  }

  @override
  void dispose() {
    phoneController?.dispose();
  }
}
