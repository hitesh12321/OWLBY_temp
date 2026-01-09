import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:owlby_serene_m_i_n_d_s/sample_auth/login_sample.dart';
import 'package:owlby_serene_m_i_n_d_s/sample_auth/otp_sample.dart';
import 'package:provider/provider.dart';
import 'package:owlby_serene_m_i_n_d_s/appUser/app_user_model.dart';
import 'package:owlby_serene_m_i_n_d_s/appUser/app_user_provider.dart';
import 'package:owlby_serene_m_i_n_d_s/backend/api_requests/api_calls.dart';
import 'package:owlby_serene_m_i_n_d_s/local_database/db/project_database.dart';
import 'package:owlby_serene_m_i_n_d_s/main.dart';

class AuthSample {
  static String verId = "";
  static final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  static void verifyPhoneNumber(BuildContext context, String number) async {
    await _firebaseAuth.verifyPhoneNumber(
      phoneNumber: '+91 $number',
      verificationCompleted: (PhoneAuthCredential credential) {
        signInWithPhoneNumber(
            context, credential.verificationId!, credential.smsCode!);
      },
      verificationFailed: (FirebaseAuthException e) {
        if (e.code == 'invalid-phone-number') {
          print('The provided phone number is not valid.');
        }
      },
      codeSent: (String verificationId, int? resendToken) {
        verId = verificationId;
        print("verficationId $verId");
        Navigator.push(context, MaterialPageRoute(builder: (ctx) {
          return const OtpSample();
        }));
        print("code sent");
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
  }

  static void logoutApp(BuildContext context) async {
    await _firebaseAuth.signOut();
    // ignore: use_build_context_synchronously
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (ctx) => const LoginSample(),
      ),
    );
  }

  static void submitOtp(BuildContext context, String otp) {
    signInWithPhoneNumber(context, verId, otp);
  }
// Inside auth_sample.dart

  static Future<void> signInWithPhoneNumber(
      BuildContext context, String verificationId, String smsCode) async {
    try {
      // 1. Firebase Sign In
      final AuthCredential credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: smsCode,
      );
      final UserCredential userCredential =
          await _firebaseAuth.signInWithCredential(credential);

      print('✅ Firebase sign-in success: ${userCredential.user?.uid}');

      // 2. Format Phone Number (Remove +91 or + code if your API expects 10 digits)
      String rawPhoneNumber = userCredential.user!.phoneNumber ?? '';
      if (rawPhoneNumber.startsWith('+91')) {
        rawPhoneNumber = rawPhoneNumber.replaceAll('+91', '').trim();
      }
      // Remove space just in case
      rawPhoneNumber = rawPhoneNumber.replaceAll(' ', '');

      print("📞 Fetching details for: $rawPhoneNumber");

      // 3. Fetch user details
      final response = await GetUserDetails.call(phoneNumber: rawPhoneNumber);
      final exists = GetUserDetails.userExists(response);

      if (exists) {
        try {
          // Parse data
          final userDataMap =
              response.jsonBody['data']; // Ensure 'data' is the Map, not a List
          final user = AppUserModel.fromApi(userDataMap);

          // 4. Save to Provider (Which saves to SQLite internally)
          await context.read<AppUserProvider>().login(user);

          // Debug check
          final dbUser = await OwlbyDatabase.instance.getUser();
          print('🟢 USER SAVED IN DB: ${dbUser?.fullName}');

          // 5. Navigate ONLY after success
          if (context.mounted) {
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) {
              return const NavBarPage();
            }));
          }
        } catch (e) {
          print("🔴 Error parsing or saving user data: $e");
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Data Error: $e")),
          );
        }
      } else {
        print('❌ User does not exist in Backend');
        // Handle case: User passed OTP but isn't in your SQL Database
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text("Login Failed: User not found in database.")),
          );
          // Optionally redirect to SignUp
        }
      }
    } catch (e) {
      print('Error signing in with phone number: $e');
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Auth Error: $e")),
        );
      }
    }
  }
}
