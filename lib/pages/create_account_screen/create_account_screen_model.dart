import '/flutter_flow/flutter_flow_util.dart';

import '/index.dart';
import 'create_account_screen_widget.dart' show CreateAccountScreenWidget;

import 'package:flutter/material.dart';

class CreateAccountScreenModel
    extends FlutterFlowModel<CreateAccountScreenWidget> {
  ///  State fields for stateful widgets in this page.

  // Name
  FocusNode? nameFocusNode;
  TextEditingController? nameController;
  String? Function(String?)? nameValidator;

  // Email
  FocusNode? emailFocusNode;
  TextEditingController? emailController;
  String? Function(String?)? emailValidator;

  // Phone
  FocusNode? phoneFocusNode;
  TextEditingController? phoneController;
  String? Function(String?)? phoneValidator;

  // Organization
  FocusNode? orgFocusNode;
  TextEditingController? orgController;
  String? Function(String?)? orgValidator;

  // Referral
  FocusNode? referralFocusNode;
  TextEditingController? referralController;
  String? Function(String?)? referralValidator;

  @override
  void initState(BuildContext context) {
    // Provide simple validators
    nameValidator = (value) {
      if (value == null || value.trim().isEmpty) {
        return 'Please enter your full name';
      }
      return null;
    };

    emailValidator = (value) {
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

    phoneValidator = (value) {
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
    orgValidator = (value) => null;

    // referral optional - basic length check if present
    referralValidator = (value) {
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
