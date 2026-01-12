import 'dart:convert';
import 'package:owlby_serene_m_i_n_d_s/backend/api_requests/api_calls.dart';
import 'package:owlby_serene_m_i_n_d_s/sample_auth/login_sample.dart';

import '/flutter_flow/flutter_flow_animations.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'create_account_screen_model.dart';
export 'create_account_screen_model.dart';

class CreateAccountScreenWidget extends StatefulWidget {
  const CreateAccountScreenWidget({super.key});

  static String routeName = 'createAccountScreen';
  static String routePath = '/createAccountScreen';

  @override
  State<CreateAccountScreenWidget> createState() =>
      _CreateAccountScreenWidgetState();
}

class _CreateAccountScreenWidgetState extends State<CreateAccountScreenWidget>
    with TickerProviderStateMixin {
  late CreateAccountScreenModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final animationsMap = <String, AnimationInfo>{};

  static const String referralCheckUrl =
      'https://api.example.com/checkReferral';

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => CreateAccountScreenModel());

    _model.nameController ??= TextEditingController();
    _model.nameFocusNode ??= FocusNode();
    _model.emailController ??= TextEditingController();
    _model.emailFocusNode ??= FocusNode();
    _model.phoneController ??= TextEditingController();
    _model.phoneFocusNode ??= FocusNode();
    _model.orgController ??= TextEditingController();
    _model.orgFocusNode ??= FocusNode();
    _model.referralController ??= TextEditingController();
    _model.referralFocusNode ??= FocusNode();

    animationsMap.addAll({
      'containerOnPageLoadAnimation': AnimationInfo(
        trigger: AnimationTrigger.onPageLoad,
        effectsBuilder: () => [
          VisibilityEffect(duration: 1.ms),
          FadeEffect(
            curve: Curves.easeInOut,
            duration: 400.0.ms,
            begin: 0.0,
            end: 1.0,
          ),
          ScaleEffect(
            curve: Curves.easeInOut,
            duration: 400.0.ms,
            begin: const Offset(0.9, 0.9),
            end: const Offset(1.0, 1.0),
          ),
        ],
      ),
    });
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  // --- LOGIC METHODS ---

  Future<Map<String, dynamic>> _checkReferral(String code) async {
    try {
      final resp = await http.post(
        Uri.parse(referralCheckUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'referral': code}),
      );
      if (resp.statusCode == 200) {
        return jsonDecode(resp.body) as Map<String, dynamic>;
      }
      return {'valid': false};
    } catch (e) {
      return {'valid': false};
    }
  }

  Future<void> _saveProfileLocally(Map<String, dynamic> profile) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_profile', jsonEncode(profile));
  }

  Future<void> _onCreateAccountPressed() async {
    final nameErr = _model.nameValidator?.call(_model.nameController?.text);
    final emailErr = _model.emailValidator?.call(_model.emailController?.text);
    final phoneErr = _model.phoneValidator?.call(_model.phoneController?.text);

    if (nameErr != null || emailErr != null || phoneErr != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(nameErr ?? emailErr ?? phoneErr ?? 'Error')),
      );
      return;
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );

    try {
      final response = await UsersignupCall.call(
        fullName: _model.nameController?.text.trim(),
        email: _model.emailController?.text.trim(),
        organizationName: _model.orgController?.text.trim(),
        phoneNumber: _model.phoneController?.text.trim(),
      );
      print('🤛🤛🤛🤛FULL RESPONSE: $response');

      final status = UsersignupCall.success(response);

      Navigator.pop(context); // ALWAYS close loader
      if (!mounted) return;
      if (status == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Account created successfully!')),
        );
        context.pushNamed(LoginSample.routeName);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              UsersignupCall.message(response) ?? 'Signup failed',
            ),
          ),
        );
      }
    } catch (e) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Something went wrong')),
      );
    }

    // bool referralValid = false;
    // int extraSessions = 0;
    // final referralCode = _model.referralController?.text.trim() ?? '';

    // if (referralCode.isNotEmpty) {
    //   final result = await _checkReferral(referralCode);
    //   referralValid = result['valid'] == true;
    //   if (referralValid) {
    //     extraSessions = result['extraSessions'] ?? 0;
    //   }
    // }

    // final profile = {
    //   'name': _model.nameController?.text.trim(),
    //   'email': _model.emailController?.text.trim(),
    //   'phone': _model.phoneController?.text.trim(),
    //   'organization': _model.orgController?.text.trim(),
    //   // 'referralCode': referralCode,
    //   // 'referralValid': referralValid,
    //   // 'extraSessions': extraSessions,
    //   'createdAt': DateTime.now().toIso8601String(),
    // };

    // await _saveProfileLocally(profile);
    // if (Navigator.canPop(context)) Navigator.pop(context);

    // ScaffoldMessenger.of(context).showSnackBar(
    //   SnackBar(
    //       content: Text(
    //           referralValid ? 'Referral applied!' : 'Account saved locally.')),
    // );

    // context.pushNamed(LoginScreenWidget.routeName);
  }

  // --- UI BUILDER ---

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        key: scaffoldKey,
        resizeToAvoidBottomInset: true,
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        body: SafeArea(
          child: Row(
            children: [
              // Sidebar for Desktop/Tablet
              if (responsiveVisibility(
                  context: context, phone: false, tablet: false))
                Expanded(
                  flex: 5,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          FlutterFlowTheme.of(context).primaryBackground,
                          FlutterFlowTheme.of(context).accent1
                        ],
                      ),
                    ),
                  ),
                ),

              // Form Content
              Expanded(
                flex: 5,
                child: Center(
                  child: SingleChildScrollView(
                    // PREVENTS BOTTOM OVERFLOW
                    padding: const EdgeInsets.all(24.0),
                    child: Container(
                      constraints: const BoxConstraints(maxWidth: 500),
                      decoration: BoxDecoration(
                        color: FlutterFlowTheme.of(context).secondary,
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(32.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Create an account',
                              style: FlutterFlowTheme.of(context)
                                  .displaySmall
                                  .override(
                                    font: GoogleFonts.poppins(
                                        fontWeight: FontWeight.bold),
                                    fontSize: 28,
                                  ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              "Fill in your details to get started",
                              textAlign: TextAlign.center,
                              style: FlutterFlowTheme.of(context).labelLarge,
                            ),
                            const SizedBox(height: 32),

                            // Form Fields
                            _buildField(
                                _model.nameController,
                                _model.nameFocusNode,
                                'Full Name',
                                AutofillHints.name),
                            const SizedBox(height: 16),
                            _buildField(
                                _model.emailController,
                                _model.emailFocusNode,
                                'Email',
                                AutofillHints.email,
                                type: TextInputType.emailAddress),
                            const SizedBox(height: 16),
                            _buildField(
                                _model.phoneController,
                                _model.phoneFocusNode,
                                'Phone Number',
                                AutofillHints.telephoneNumber,
                                type: TextInputType.phone),
                            const SizedBox(height: 16),
                            _buildField(_model.orgController,
                                _model.orgFocusNode, 'Organization', null),
                            const SizedBox(height: 16),
                            _buildField(
                                _model.referralController,
                                _model.referralFocusNode,
                                'Referral Code (Optional)',
                                null),

                            const SizedBox(height: 24),

                            // Terms
                            RichText(
                              textAlign: TextAlign.center,
                              text: TextSpan(
                                style: FlutterFlowTheme.of(context).labelMedium,
                                children: [
                                  const TextSpan(
                                      text: 'By signing up, you agree to our'),
                                  TextSpan(
                                    text: 'Terms',
                                    style: TextStyle(
                                        color: FlutterFlowTheme.of(context)
                                            .primary,
                                        decoration: TextDecoration.underline),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () => launchURL(
                                          'https://owlnotes.ai/terms-and-conditions'),
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 24),

                            // The Button
                            FFButtonWidget(
                              onPressed: _onCreateAccountPressed,
                              text: 'Create Account',
                              options: FFButtonOptions(
                                width: double.infinity,
                                height: 50,
                                color: const Color(0xFF2596BE),
                                textStyle: GoogleFonts.poppins(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                                borderRadius: BorderRadius.circular(25),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ).animateOnPageLoad(
                        animationsMap['containerOnPageLoadAnimation']!),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildField(
      TextEditingController? ctr, FocusNode? node, String label, String? hint,
      {TextInputType type = TextInputType.text}) {
    return TextFormField(
      controller: ctr,
      focusNode: node,
      autofillHints: hint != null ? [hint] : null,
      keyboardType: type,
      decoration: InputDecoration(
        labelText: label,
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
              color: FlutterFlowTheme.of(context).secondaryText, width: 1),
          borderRadius: BorderRadius.circular(12),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide:
              BorderSide(color: FlutterFlowTheme.of(context).primary, width: 2),
          borderRadius: BorderRadius.circular(12),
        ),
        filled: true,
        fillColor: FlutterFlowTheme.of(context).secondaryBackground,
      ),
    );
  }
}
