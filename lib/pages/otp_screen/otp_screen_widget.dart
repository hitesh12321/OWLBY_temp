import 'package:firebase_auth/firebase_auth.dart';
import 'package:owlby_serene_m_i_n_d_s/auth/firebase_auth/auth_util.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'otp_screen_model.dart';
export 'otp_screen_model.dart';

class OtpScreenWidget extends StatefulWidget {
  const OtpScreenWidget({
    super.key,
    required this.phoneNumber,
  });

  // final String verificationId;
  final String phoneNumber;

  static String routeName = 'otpScreen';
  static String routePath = '/otpScreen';

  @override
  State<OtpScreenWidget> createState() => _OtpScreenWidgetState();
}

class _OtpScreenWidgetState extends State<OtpScreenWidget> {
  late OtpScreenModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => OtpScreenModel());

    _model.pinCodeController ??= TextEditingController();
    _model.pinCodeFocusNode ??= FocusNode();
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  Future<void> verifyOtp(String smsCode) async {
    try {
      final credential = await authManager.verifySmsCode(
        context: context,
        smsCode: smsCode,
      );
      if (credential != null) {
        context.goNamed('/home');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Invalid OTP")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Container(
              constraints: const BoxConstraints(maxWidth: 570),
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: FlutterFlowTheme.of(context).secondary,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  const SizedBox(height: 60),
                  Text(
                    'Verification Code',
                    style: FlutterFlowTheme.of(context).displaySmall.override(
                          font: GoogleFonts.poppins(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Enter the code sent to ${widget.phoneNumber}',
                    style: FlutterFlowTheme.of(context).labelLarge,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 30),
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: PinCodeTextField(
                      appContext: context,
                      controller: _model.pinCodeController,
                      length: 6,
                      autoFocus: true,
                      focusNode: _model.pinCodeFocusNode,
                      keyboardType: TextInputType.number,
                      enablePinAutofill: true,
                      onChanged: (_) {},
                      onCompleted: (code) {
                        verifyOtp(code);
                      },
                      pinTheme: PinTheme(
                        shape: PinCodeFieldShape.box,
                        borderRadius: BorderRadius.circular(12),
                        fieldHeight: 60,
                        fieldWidth: 60,
                        activeColor: FlutterFlowTheme.of(context).primaryText,
                        selectedColor: FlutterFlowTheme.of(context).secondary,
                        inactiveColor:
                            FlutterFlowTheme.of(context).secondaryBackground,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  FFButtonWidget(
                    onPressed: () {
                      final smsCode = _model.pinCodeController?.text ?? "";
                      if (smsCode.length == 6) {
                        verifyOtp(smsCode);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Enter a valid 6-digit code"),
                          ),
                        );
                      }
                    },
                    text: 'Continue >',
                    options: FFButtonOptions(
                      width: double.infinity,
                      height: 56,
                      color: const Color(0xFF2596BE),
                      textStyle:
                          FlutterFlowTheme.of(context).titleMedium.override(
                                font: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w600,
                                ),
                                color: Colors.white,
                              ),
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
