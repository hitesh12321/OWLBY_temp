import '/backend/api_requests/api_calls.dart';

import '/flutter_flow/flutter_flow_util.dart';

import '/index.dart';
import 'otp_screen_widget.dart' show OtpScreenWidget;
import 'package:flutter/material.dart';

class OtpScreenModel extends FlutterFlowModel<OtpScreenWidget> {
  ///  State fields for stateful widgets in this page.

  // State field(s) for PinCode widget.
  TextEditingController? pinCodeController;
  FocusNode? pinCodeFocusNode;
  String? Function(BuildContext, String?)? pinCodeControllerValidator;
  // Stores action output result for [Backend Call - API (verifyOtp)] action in PinCode widget.
  ApiCallResponse? apiResultaxb;

  @override
  void initState(BuildContext context) {
    pinCodeController = TextEditingController();
  }

  @override
  void dispose() {
    pinCodeFocusNode?.dispose();
    pinCodeController?.dispose();
  }
}
