import 'package:firebase_auth/firebase_auth.dart';
import 'package:owlby_serene_m_i_n_d_s/auth/firebase_auth/auth_util.dart';

import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'dart:ui';
import '/index.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'login_screen_model.dart';
export 'login_screen_model.dart';

class LoginScreenWidget extends StatefulWidget {
  const LoginScreenWidget({super.key});

  static String routeName = 'loginScreen';
  static String routePath = '/loginScreen';

  @override
  State<LoginScreenWidget> createState() => _LoginScreenWidgetState();
}

class _LoginScreenWidgetState extends State<LoginScreenWidget>
    with TickerProviderStateMixin {
  late LoginScreenModel _model;
  bool isLoading = false;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  /// FIX: Use your own controller (NOT model’s)
  late TextEditingController phoneController;

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => LoginScreenModel());

    phoneController = TextEditingController(); // FIXED

    authManager.handlePhoneAuthStateChanges(context);
  }

  @override
  void dispose() {
    phoneController.dispose(); // FIXED
    _model.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        resizeToAvoidBottomInset: true,
        body: SafeArea(
          child: Row(
            children: [
              /// LEFT PANEL (Desktop only)
              if (responsiveVisibility(
                context: context,
                phone: false,
                tablet: false,
              ))
                Expanded(
                  flex: 5,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          FlutterFlowTheme.of(context).primaryBackground,
                          FlutterFlowTheme.of(context).accent1,
                        ],
                        begin: Alignment.centerRight,
                        end: Alignment.centerLeft,
                      ),
                    ),
                  ),
                ),

              /// RIGHT PANEL (Form)
              Expanded(
                flex: 5,
                child: Center(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(16),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        maxWidth: 570,
                      ),
                      child: Container(
                        padding: EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: FlutterFlowTheme.of(context).secondary,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(height: 40),

                            Text(
                              'Continue with Phone',
                              style: FlutterFlowTheme.of(context)
                                  .displaySmall
                                  .override(
                                    font: GoogleFonts.poppins(
                                      fontWeight: FontWeight.bold,
                                    ),
                                    fontSize: 30,
                                  ),
                            ),

                            SizedBox(height: 8),

                            Text(
                              'Enter your phone number to continue',
                              style: FlutterFlowTheme.of(context).labelLarge,
                            ),

                            SizedBox(height: 30),

                            /// PHONE INPUT ROW
                            Row(
                              children: [
                                Container(
                                  width: 60,
                                  height: 56,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(12),
                                    border:
                                        Border.all(color: Color(0xFFE0E0E0)),
                                  ),
                                  alignment: Alignment.center,
                                  child: Text(
                                    '+91',
                                    style: FlutterFlowTheme.of(context)
                                        .bodyMedium
                                        .override(
                                          font: GoogleFonts.poppins(
                                            fontWeight: FontWeight.w500,
                                          ),
                                          fontSize: 16,
                                        ),
                                  ),
                                ),
                                SizedBox(width: 8),
                                Expanded(
                                  child: Container(
                                    height: 56,
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 12),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(16),
                                      border:
                                          Border.all(color: Color(0xFFE0E0E0)),
                                    ),
                                    alignment: Alignment.centerLeft,
                                    child: TextFormField(
                                      controller: phoneController,
                                      keyboardType: TextInputType.phone,
                                      decoration: InputDecoration(
                                        hintText: 'Enter phone number',
                                        border: InputBorder.none,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            SizedBox(height: 40),

                            /// CONTINUE BUTTON
                            FFButtonWidget(
                              // 1. Change text to "Processing..." when loading
                              text: isLoading ? 'Processing...' : 'Continue >',

                              // 2. Your Original Styling (Restored from your file)
                              options: FFButtonOptions(
                                width: double.infinity,
                                height: 56,
                                color: isLoading
                                    ? Colors.grey
                                    : const Color(
                                        0xFF2596BE), // Grey out when loading
                                textStyle: FlutterFlowTheme.of(context)
                                    .titleMedium
                                    .override(
                                      fontFamily: 'Poppins',
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                elevation: 2,
                                borderRadius: BorderRadius.circular(25),
                              ),

                              // 3. The Logic (with Debugging & Error Handling)
                              onPressed: isLoading
                                  ? null // Disables button click when loading
                                  : () async {
                                      // A. Close Keyboard so you can see SnackBars
                                      FocusScope.of(context).unfocus();

                                      final raw = phoneController.text.trim();
                                      if (raw.isEmpty) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                              content: Text(
                                                  "Phone number cannot be empty")),
                                        );
                                        return;
                                      }

                                      // B. Start Loading
                                      setState(() => isLoading = true);

                                      // C. Smart Formatting: Handle if user types "91..." or just "93..."
                                      // If raw is "91933...", we make it "+91933..." (which is wrong) -> Correction:
                                      String phone;
                                      if (raw.startsWith('+91')) {
                                        phone = raw;
                                      } else if (raw.startsWith('91') &&
                                          raw.length > 10) {
                                        // User typed 91 manually (e.g. 9193386615), just add '+'
                                        phone = '+$raw';
                                      } else {
                                        // User typed 93386615, add '+91'
                                        phone = '+91$raw';
                                      }

                                      print(
                                          "DEBUG: Attempting to verify: $phone");

                                      try {
                                        await authManager.beginPhoneAuth(
                                          context: context,
                                          phoneNumber: phone,
                                          onCodeSent: (context) {
                                            setState(() => isLoading = false);
                                            print(
                                                "❤️❤️❤️❤️ OTP SENT CALLBACK HIT"); //

                                            context.pushNamed(
                                              OtpScreenWidget.routeName,
                                              queryParameters: {
                                                'phoneNumber': phone,
                                              },
                                            );
                                          },
                                        );
                                      } catch (e) {
                                        print("DEBUG: Exception: $e");
                                        setState(() => isLoading = false);
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(content: Text("Error: $e")),
                                        );
                                      }
                                    },
                            ),

                            ///

                            SizedBox(height: 20),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
