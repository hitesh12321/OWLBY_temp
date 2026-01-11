import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:owlby_serene_m_i_n_d_s/backend/api_requests/api_calls.dart';
import 'package:owlby_serene_m_i_n_d_s/flutter_flow/nav/nav.dart';
import 'package:owlby_serene_m_i_n_d_s/pages/create_account_screen/create_account_screen_widget.dart';
import 'package:owlby_serene_m_i_n_d_s/sample_auth/auth_sample.dart';

// Imports required for the UI Styling
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';

class LoginSample extends StatefulWidget {
  const LoginSample({super.key});

  // Copied Route identifiers
  static String routeName = 'loginScreen';
  static String routePath = '/loginScreen';

  @override
  State<LoginSample> createState() => _LoginSampleState();
}

class _LoginSampleState extends State<LoginSample> {
  late TextEditingController phoneController;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  bool isLoading = false;
  String country_code = "+91";

  @override
  void initState() {
    super.initState();
    phoneController = TextEditingController();
  }

  @override
  void dispose() {
    phoneController.dispose();
    super.dispose();
  }

  Future<String?> getCountryCode(BuildContext context) {
    List<String> countryCodes = [
      '+1', // USA, Canada
      '+91', // India
      '+52', // Mexico
      '+234', // Nigeria
      '+20', // Egypt
    ];

    return showDialog<String>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Select Country Code'),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: countryCodes.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(countryCodes[index]),
                  onTap: () {
                    Navigator.pop(
                      context,
                      countryCodes[index], // ✅ RETURN VALUE
                    );
                  },
                );
              },
            ),
          ),
        );
      },
    );
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
              /// LEFT PANEL (Desktop/Tablet visibility check)
              /// Using generic responsive logic since the helper function might vary
              if (MediaQuery.of(context).size.width > 991)
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
                      constraints: const BoxConstraints(
                        maxWidth: 570,
                      ),
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: FlutterFlowTheme.of(context).secondary,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const SizedBox(height: 40),

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

                            const SizedBox(height: 8),

                            Text(
                              'Enter your phone number to continue',
                              style: FlutterFlowTheme.of(context).labelLarge,
                            ),

                            const SizedBox(height: 30),

                            /// PHONE INPUT ROW
                            Row(
                              children: [
                                GestureDetector(
                                  onTap: () async {
                                    final selectedCode =
                                        await getCountryCode(context);
                                    if (selectedCode != null) {
                                      setState(() {
                                        country_code = selectedCode;
                                      });
                                      print(
                                          "Selected Country 🎶🎶🤷‍♂️ Code: $selectedCode");
                                    }
                                  },
                                  child: Container(
                                    width: 60,
                                    height: 56,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                          color: const Color(0xFFE0E0E0)),
                                    ),
                                    alignment: Alignment.center,
                                    child: Text(
                                      country_code,
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
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Container(
                                    height: 56,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(16),
                                      border: Border.all(
                                          color: const Color(0xFFE0E0E0)),
                                    ),
                                    alignment: Alignment.centerLeft,
                                    child: TextFormField(
                                      controller: phoneController,
                                      keyboardType: TextInputType.phone,
                                      decoration: const InputDecoration(
                                        hintText: 'Enter phone number',
                                        border: InputBorder.none,
                                        counterText: "", // Hides counter
                                      ),
                                      maxLength: 10,
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 40),

                            /// CONTINUE BUTTON (With Logic from login_sample)
                            FFButtonWidget(
                              text: isLoading ? 'Processing...' : 'Continue >',
                              options: FFButtonOptions(
                                width: double.infinity,
                                height: 56,
                                color: isLoading
                                    ? Colors.grey
                                    : const Color(0xFF2596BE),
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
                              onPressed: isLoading
                                  ? null
                                  : () async {
                                      final phone = phoneController.text.trim();

                                      // 1. Validate Format
                                      if (!RegExp(r'^[0-9]{10}$')
                                          .hasMatch(phone)) {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                            content: Text(
                                                "Please enter a valid 10-digit number"),
                                          ),
                                        );
                                        return;
                                      }

                                      // 2. Start Loading State
                                      setState(() {
                                        isLoading = true;
                                      });

                                      try {
                                        // 3. API Check Logic (from login_sample)
                                        final checkuserResponse =
                                            await CheckUserApi.call(
                                                phoneNumber: phone);

                                        final userExists =
                                            CheckUserApi.userExists(
                                                checkuserResponse);

                                        print(
                                            "❤️ check user exists: $userExists");

                                        if (userExists) {
                                          print(
                                              "❤️ User exists. Proceeding to login.");
                                          // Login Flow
                                          AuthSample.verifyPhoneNumber(
                                              context, phone, country_code);
                                        } else {
                                          print(
                                              "❤️ User does not exist. Proceeding to sign up.");
                                          // Sign Up Flow
                                          if (mounted) {
                                            // context.pushReplacementNamed(
                                            //     'createAccountScreen');
                                            Navigator.pushReplacement(context,
                                                MaterialPageRoute(
                                                    builder: (context) {
                                              return const CreateAccountScreenWidget();
                                            }));
                                          }
                                        }
                                      } catch (e) {
                                        print("Error during check: $e");
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                              content: Text(
                                                  "Something went wrong: $e")),
                                        );
                                      } finally {
                                        // 4. Stop Loading
                                        if (mounted) {
                                          setState(() {
                                            isLoading = false;
                                          });
                                        }
                                      }
                                    },
                            ),

                            const SizedBox(height: 20),
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
