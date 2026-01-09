// import 'package:firebase_auth/firebase_auth.dart';

// import 'package:owlby_serene_m_i_n_d_s/appUser/app_user_model.dart';
// import 'package:owlby_serene_m_i_n_d_s/appUser/app_user_provider.dart';

// import 'package:owlby_serene_m_i_n_d_s/backend/api_requests/api_calls.dart';
// import 'package:owlby_serene_m_i_n_d_s/local_database/db/project_database.dart';
// import 'package:owlby_serene_m_i_n_d_s/main.dart';

// import '/flutter_flow/flutter_flow_theme.dart';
// import '/flutter_flow/flutter_flow_util.dart';
// import '/flutter_flow/flutter_flow_widgets.dart';
// import 'package:provider/provider.dart';
// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'otp_screen_model.dart';
// export 'otp_screen_model.dart';

// class OtpScreenWidget extends StatefulWidget {
//   const OtpScreenWidget({
//     super.key,
//     required this.phoneNumber,
//     required this.verificationId,
//   });

//   // final String verificationId;
//   final String phoneNumber;
//   final String verificationId;

//   static String routeName = 'otpScreen';
//   static String routePath = '/otpScreen';

//   @override
//   State<OtpScreenWidget> createState() => _OtpScreenWidgetState();
// }

// class _OtpScreenWidgetState extends State<OtpScreenWidget> {
//   late OtpScreenModel _model;
//   final scaffoldKey = GlobalKey<ScaffoldState>();
//   bool _isVerifying = false;

//   @override
//   void initState() {
//     super.initState();
//     _model = createModel(context, () => OtpScreenModel());

//     _model.pinCodeController ??= TextEditingController();
//     _model.pinCodeFocusNode ??= FocusNode();
//   }

//   @override
//   void dispose() {
//     _model.dispose();
//     super.dispose();
//   }

//   Future<void> verifyOtp(String smsCode) async {
//     if (_isVerifying) return;

//     if (smsCode.length != 6) return;
//     if (widget.verificationId.isEmpty) {
//       print("Error: No Verification ID found");
//       return;
//     }

//     _isVerifying = true;
//     setState(() {});

//     try {
//       print('🔐 Verifying OTP manually');

//       final credential = PhoneAuthProvider.credential(
//         verificationId: widget.verificationId,
//         smsCode: smsCode,
//       );

//       final userCredential =
//           await FirebaseAuth.instance.signInWithCredential(credential);

//       print('✅ Firebase sign-in success: ${userCredential.user?.uid}');

//       // 🔽 Fetch user details ONCE
//       final response =
//           await GetUserDetails.call(phoneNumber: widget.phoneNumber);

//       final exists = GetUserDetails.userExists(response);

//       if (exists) {
//         final user = AppUserModel.fromApi(response.jsonBody['data']);

//         // ✅ Save locally
//         await context.read<AppUserProvider>().login(user);
//         final dbUser = await OwlbyDatabase.instance.getUser();
//         print('🟢 USER FROM DB AFTER SAVE: $dbUser');

//         // ✅ Navigate
//         if (mounted) {
//           Navigator.pushReplacement(
//             context,
//             MaterialPageRoute(builder: (_) => const NavBarPage()),
//           );
//         }
//       } else {
//         // TODO: navigate to onboarding / signup
//         print('❌ User does not exist');
//       }
//     } catch (e) {
//       print("Firebase Auth Error: $e");

//       String errorMessage = "Invalid OTP. Please try again.";

//       if (e.toString().contains("session-expired") ||
//           e.toString().contains("expired")) {
//         errorMessage =
//             "The code has expired. Please go back and request a new one.";
//       }

//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text(errorMessage)),
//         );
//       }
//     } finally {
//       _isVerifying = false;
//       if (mounted) setState(() {});
//     }
//   }

//   //

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       key: scaffoldKey,
//       backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
//       body: SafeArea(
//         child: Center(
//           child: SingleChildScrollView(
//             child: Container(
//               constraints: const BoxConstraints(maxWidth: 570),
//               padding: const EdgeInsets.all(20),
//               decoration: BoxDecoration(
//                 color: FlutterFlowTheme.of(context).secondary,
//                 borderRadius: BorderRadius.circular(16),
//               ),
//               child: Column(
//                 children: [
//                   const SizedBox(height: 60),
//                   Text(
//                     'Verification Code',
//                     style: FlutterFlowTheme.of(context).displaySmall.override(
//                           font: GoogleFonts.poppins(
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                   ),
//                   const SizedBox(height: 10),
//                   Text(
//                     'Enter the code sent to ${widget.phoneNumber}',
//                     style: FlutterFlowTheme.of(context).labelLarge,
//                     textAlign: TextAlign.center,
//                   ),
//                   const SizedBox(height: 30),
//                   Padding(
//                     padding: const EdgeInsets.all(12),
//                     child: TextField(
//                       controller: _model.pinCodeController,
//                       focusNode: _model.pinCodeFocusNode,
//                       keyboardType: TextInputType.number,
//                       maxLength: 6,
//                       decoration: InputDecoration(
//                         labelText: 'Enter OTP',
//                         hintText: '6-digit code',
//                         counterText: '',
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(12),
//                         ),
//                         enabledBorder: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(12),
//                           borderSide: BorderSide(
//                             color: FlutterFlowTheme.of(context)
//                                 .secondaryBackground,
//                           ),
//                         ),
//                         focusedBorder: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(12),
//                           borderSide: BorderSide(
//                             color: FlutterFlowTheme.of(context).primary,
//                             width: 2,
//                           ),
//                         ),
//                       ),
//                       onChanged: (value) {
//                         if (value.length == 6) {
//                           FocusScope.of(context).unfocus();
//                           verifyOtp(value);
//                         }
//                       },
//                     ),
//                   ),
//                   const SizedBox(height: 20),
//                   FFButtonWidget(
//                     onPressed: () {
//                       final smsCode = _model.pinCodeController?.text ?? "";
//                       if (smsCode.length == 6) {
//                         verifyOtp(smsCode);
//                       } else {
//                         ScaffoldMessenger.of(context).showSnackBar(
//                           const SnackBar(
//                             content: Text("Enter a valid 6-digit code"),
//                           ),
//                         );
//                       }
//                     },
//                     text: 'Continue >',
//                     options: FFButtonOptions(
//                       width: double.infinity,
//                       height: 56,
//                       color: const Color(0xFF2596BE),
//                       textStyle:
//                           FlutterFlowTheme.of(context).titleMedium.override(
//                                 font: GoogleFonts.poppins(
//                                   fontWeight: FontWeight.w600,
//                                 ),
//                                 color: Colors.white,
//                               ),
//                       borderRadius: BorderRadius.circular(25),
//                     ),
//                   ),
//                   const SizedBox(height: 20),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
