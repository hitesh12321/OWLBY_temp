// import '/flutter_flow/flutter_flow_animations.dart';
// import '/flutter_flow/flutter_flow_theme.dart';
// import '/flutter_flow/flutter_flow_util.dart';
// import '/flutter_flow/flutter_flow_widgets.dart';
// import 'dart:math';
// import 'dart:ui';
// import '/index.dart';
// import 'create_account_screen_widget.dart' show CreateAccountScreenWidget;
// import 'package:flutter/gestures.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/scheduler.dart';
// import 'package:flutter_animate/flutter_animate.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:provider/provider.dart';

// class CreateAccountScreenModel
//     extends FlutterFlowModel<CreateAccountScreenWidget> {
//   ///  State fields for stateful widgets in this page.

//   // State field(s) for emailAddress widget.
//   FocusNode? emailAddressFocusNode1;
//   TextEditingController? emailAddressTextController1;
//   String? Function(BuildContext, String?)? emailAddressTextController1Validator;
//   // State field(s) for emailAddress widget.
//   FocusNode? emailAddressFocusNode2;
//   TextEditingController? emailAddressTextController2;
//   String? Function(BuildContext, String?)? emailAddressTextController2Validator;
//   // State field(s) for emailAddress widget.
//   FocusNode? emailAddressFocusNode3;
//   TextEditingController? emailAddressTextController3;
//   String? Function(BuildContext, String?)? emailAddressTextController3Validator;
//   // State field(s) for emailAddress widget.
//   FocusNode? emailAddressFocusNode4;
//   TextEditingController? emailAddressTextController4;
//   String? Function(BuildContext, String?)? emailAddressTextController4Validator;
//   // State field(s) for emailAddress widget.
//   FocusNode? emailAddressFocusNode5;
//   TextEditingController? emailAddressTextController5;
//   String? Function(BuildContext, String?)? emailAddressTextController5Validator;

//   @override
//   void initState(BuildContext context) {}

//   @override
//   void dispose() {
//     emailAddressFocusNode1?.dispose();
//     emailAddressTextController1?.dispose();

//     emailAddressFocusNode2?.dispose();
//     emailAddressTextController2?.dispose();

//     emailAddressFocusNode3?.dispose();
//     emailAddressTextController3?.dispose();

//     emailAddressFocusNode4?.dispose();
//     emailAddressTextController4?.dispose();

//     emailAddressFocusNode5?.dispose();
//     emailAddressTextController5?.dispose();
//   }
// }
import '/flutter_flow/flutter_flow_animations.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:math';
import 'dart:ui';
import '/index.dart';
import 'create_account_screen_widget.dart' show CreateAccountScreenWidget;
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class CreateAccountScreenModel
    extends FlutterFlowModel<CreateAccountScreenWidget> {
  ///  State fields for stateful widgets in this page.

  // Name
  FocusNode? nameFocusNode;
  TextEditingController? nameController;
  String? Function( String?)? nameValidator;

  // Email
  FocusNode? emailFocusNode;
  TextEditingController? emailController;
  String? Function( String?)? emailValidator;

  // Phone
  FocusNode? phoneFocusNode;
  TextEditingController? phoneController;
  String? Function( String?)? phoneValidator;

  // Organization
  FocusNode? orgFocusNode;
  TextEditingController? orgController;
  String? Function( String?)? orgValidator;

  // Referral
  FocusNode? referralFocusNode;
  TextEditingController? referralController;
  String? Function( String?)? referralValidator;

  @override
  void initState(BuildContext context) {
    // Provide simple validators
    nameValidator = ( value) {
      if (value == null || value.trim().isEmpty) {
        return 'Please enter your full name';
      }
      return null;
    };

    emailValidator = ( value) {
      if (value == null || value.trim().isEmpty) {
        return 'Please enter your email';
      }
      final emailRegex = RegExp(
          r"^[a-zA-Z0-9.a-zA-Z0-9!#\$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9]+\.[a-zA-Z]+");
      if (!emailRegex.hasMatch(value.trim())) {
        return 'Enter a valid email';
      }
      return null;
    };

    phoneValidator = ( value) {
      if (value == null || value.trim().isEmpty) {
        return 'Please enter your phone number';
      }
      final digits = value.replaceAll(RegExp(r'\D'), '');
      if (digits.length < 7) {
        return 'Enter a valid phone number';
      }
      return null;
    };

    // organization optional
    orgValidator = ( value) => null;

    // referral optional - basic length check if present
    referralValidator = ( value) {
      if (value == null || value.trim().isEmpty) return null;
      if (value.trim().length < 3) return 'Invalid referral code';
      return null;
    };
  }

  @override
  void dispose() {
    nameFocusNode?.dispose();
    nameController?.dispose();

    emailFocusNode?.dispose();
    emailController?.dispose();

    phoneFocusNode?.dispose();
    phoneController?.dispose();

    orgFocusNode?.dispose();
    orgController?.dispose();

    referralFocusNode?.dispose();
    referralController?.dispose();
  }
}
