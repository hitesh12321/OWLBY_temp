import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:owlby_serene_m_i_n_d_s/Global/global_snackbar.dart';

import '../auth_manager.dart';
import '../base_auth_user_provider.dart';
import 'firebase_user_provider.dart';

class FirebasePhoneAuthManager extends ChangeNotifier {
  bool? _triggerOnCodeSent;
  FirebaseAuthException? phoneAuthError;
  String? phoneAuthVerificationCode;
  ConfirmationResult? webPhoneAuthConfirmationResult;
  void Function(BuildContext)? _onCodeSent;

  bool get triggerOnCodeSent => _triggerOnCodeSent ?? false;
  set triggerOnCodeSent(bool val) => _triggerOnCodeSent = val;

  void Function(BuildContext) get onCodeSent =>
      _onCodeSent == null ? (_) {} : _onCodeSent!;
  set onCodeSent(void Function(BuildContext) func) => _onCodeSent = func;

  void update(VoidCallback callback) {
    callback();
    notifyListeners();
  }
}

class FirebaseAuthManager extends AuthManager with PhoneSignInManager {
  FirebasePhoneAuthManager phoneAuthManager = FirebasePhoneAuthManager();

// sign Out Method
  @override
  Future signOut() => FirebaseAuth.instance.signOut();
//Delete User Method
  @override
  Future deleteUser(BuildContext context) async {
    try {
      if (!loggedIn) return;
      await currentUser?.delete();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'requires-recent-login') {
        AppSnackbar.showError(
            context, "Sign in again before deleting your account.");
        // ScaffoldMessenger.of(context).showSnackBar(
        //   const SnackBar(content: Text('Sign in again before deleting your account.')),
        // );
      }
    }
  }

  // update Email Method
  @override
  Future updateEmail(
      {required String email, required BuildContext context}) async {
    try {
      if (!loggedIn) return;
      await currentUser?.updateEmail(email);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'requires-recent-login') {
        AppSnackbar.showError(context, e.message ?? 'Unknown error');
        // ScaffoldMessenger.of(context).showSnackBar(
        //   SnackBar(content: Text(e.message ?? 'Unknown error')),
        // );
      }
    }
  }
  // update Password Method

  @override
  Future updatePassword(
      {required String newPassword, required BuildContext context}) async {
    try {
      if (!loggedIn) return;
      await currentUser?.updatePassword(newPassword);
    } on FirebaseAuthException catch (e) {
      AppSnackbar.showError(context, e.message ?? 'Unknown error');
    }
  }

// Phone Auth State Changes Handler ??????????????????????? IMportant
  void handlePhoneAuthStateChanges(BuildContext context) {
    phoneAuthManager.addListener(() {
      if (!context.mounted) return;

      if (phoneAuthManager.triggerOnCodeSent) {
        phoneAuthManager.onCodeSent(context);
        phoneAuthManager.update(() {
          phoneAuthManager.triggerOnCodeSent = false;
        });
      } else if (phoneAuthManager.phoneAuthError != null) {
        final e = phoneAuthManager.phoneAuthError!;
        AppSnackbar.showError(context, e.message ?? 'Unknown error');
        phoneAuthManager.update(() {
          phoneAuthManager.phoneAuthError = null;
        });
      }
    });
  }

  @override
  Future beginPhoneAuth({
    required BuildContext context,
    required String phoneNumber,
    required void Function(BuildContext) onCodeSent,
  }) async {
    phoneAuthManager.onCodeSent = onCodeSent;

    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: (phoneAuthCredential) async {
        await _finishSignIn(
          context,
          () => FirebaseAuth.instance.signInWithCredential(phoneAuthCredential),
        );
      },
      verificationFailed: (e) {
        phoneAuthManager.update(() => phoneAuthManager.phoneAuthError = e);
      },
      codeSent: (verificationId, _) {
        // FIXED: Update the ID FIRST, then trigger the notification
        phoneAuthManager.phoneAuthVerificationCode = verificationId;
        phoneAuthManager.update(() {
          phoneAuthManager.triggerOnCodeSent = true;
        });
      },
      codeAutoRetrievalTimeout: (_) {},
    );
  }

  @override
  Future<BaseAuthUser?> verifySmsCode({
    required BuildContext context,
    required String smsCode,
    required String verificationId,
  }) async {
    final credential = PhoneAuthProvider.credential(
      verificationId: verificationId,
      smsCode: smsCode,
    );

    return _finishSignIn(
      context,
      () => FirebaseAuth.instance.signInWithCredential(credential),
    );
  }

  Future<BaseAuthUser?> _finishSignIn(
    BuildContext context,
    Future<UserCredential?> Function() signInFunc,
  ) async {
    try {
      final userCredential = await signInFunc();
      if (userCredential == null) return null;

      return OwlbySereneMINDSFirebaseUser.fromUserCredential(userCredential);
    } on FirebaseAuthException catch (e) {
      AppSnackbar.showError(context, e.message ?? 'Authentication error');
      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(content: Text(e.message ?? 'Authentication error')),
      // );
      return null;
    }
  }

  @override
  Future resetPassword(
      {required String email, required BuildContext context}) async {
    AppSnackbar.showInfo(
        context, 'Password reset is not supported in phone login');
    // ScaffoldMessenger.of(context).showSnackBar(
    //   const SnackBar(
    //       content: Text('Password reset is not supported in phone login')),
    // );
  }
}
