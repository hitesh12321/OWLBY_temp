import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:owlby_serene_m_i_n_d_s/sample_auth/auth_sample.dart';

// Imports required for UI Styling
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';

class OtpSample extends StatefulWidget {
  const OtpSample({super.key});

  // Copied Route identifiers
  static String routeName = 'otpScreen';
  static String routePath = '/otpScreen';

  @override
  State<OtpSample> createState() => _OtpSampleState();
}

class _OtpSampleState extends State<OtpSample> {
  late TextEditingController otpController;
  final FocusNode _otpFocusNode = FocusNode();
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    otpController = TextEditingController();
  }

  @override
  void dispose() {
    otpController.dispose();
    _otpFocusNode.dispose();
    super.dispose();
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
                    'Enter the code sent to your phone',
                    style: FlutterFlowTheme.of(context).labelLarge,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 30),
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: TextField(
                      controller: otpController,
                      focusNode: _otpFocusNode,
                      keyboardType: TextInputType.number,
                      maxLength: 6,
                      decoration: InputDecoration(
                        labelText: 'Enter OTP',
                        hintText: '6-digit code',
                        counterText: '',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: FlutterFlowTheme.of(context)
                                .secondaryBackground,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: FlutterFlowTheme.of(context).primary,
                            width: 2,
                          ),
                        ),
                      ),
                      // Optional: Auto-submit when 6 digits are entered
                      onChanged: (value) {
                        if (value.length == 6) {
                          FocusScope.of(context).unfocus();
                          AuthSample.submitOtp(context, value);
                        }
                      },
                    ),
                  ),
                  const SizedBox(height: 20),
                  FFButtonWidget(
                    onPressed: () {
                      final smsCode = otpController.text.trim();
                      if (smsCode.isNotEmpty) {
                        // Original Logic: Submit OTP
                        AuthSample.submitOtp(context, smsCode);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Please enter the OTP"),
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
