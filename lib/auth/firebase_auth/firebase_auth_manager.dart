import 'dart:async';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

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

  @override
  Future signOut() => FirebaseAuth.instance.signOut();

  @override
  Future deleteUser(BuildContext context) async {
    try {
      if (!loggedIn) return;
      await currentUser?.delete();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'requires-recent-login') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Sign in again before deleting your account.',
            ),
          ),
        );
      }
    }
  }

  @override
  Future updateEmail({
    required String email,
    required BuildContext context,
  }) async {
    try {
      if (!loggedIn) return;
      await currentUser?.updateEmail(email);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'requires-recent-login') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.message ?? 'Unknown error')),
        );
      }
    }
  }

  @override
  Future updatePassword({
    required String newPassword,
    required BuildContext context,
  }) async {
    try {
      if (!loggedIn) return;
      await currentUser?.updatePassword(newPassword);
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message ?? 'Unknown error')),
      );
    }
  }

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
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(e.message ?? 'Error')));
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
    print('beginPhoneAuth called for $phoneNumber'); // <--- add

    phoneAuthManager.update(() {
      phoneAuthManager.onCodeSent = onCodeSent;
    });

    if (kIsWeb) {
      try {
        phoneAuthManager.webPhoneAuthConfirmationResult =
            await FirebaseAuth.instance.signInWithPhoneNumber(phoneNumber);
        phoneAuthManager.update(() {
          phoneAuthManager.triggerOnCodeSent = true;
        });
        print('web signInWithPhoneNumber returned confirmation'); // <--- add
      } catch (e) {
        print('web signInWithPhoneNumber error: $e'); // <--- add
        phoneAuthManager.update(() {
          phoneAuthManager.phoneAuthError =
              FirebaseAuthException(code: 'web_error', message: e.toString());
          phoneAuthManager.triggerOnCodeSent = false;
        });
      }
      return;
    }

    final completer = Completer<bool>();

    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      timeout: Duration(seconds: 60),
      verificationCompleted: (credential) async {
        print('verificationCompleted'); // <--- add
        await FirebaseAuth.instance.signInWithCredential(credential);
        phoneAuthManager.update(() {
          phoneAuthManager.triggerOnCodeSent = false;
          phoneAuthManager.phoneAuthError = null;
        });
      },
      verificationFailed: (e) {
        print('verificationFailed: ${e.code} ${e.message}'); // <--- add
        phoneAuthManager.update(() {
          phoneAuthManager.phoneAuthError = e;
          phoneAuthManager.triggerOnCodeSent = false;
        });
        completer.complete(false);
      },
      codeSent: (verificationId, _) {
        print('codeSent: $verificationId'); // <--- add
        phoneAuthManager.update(() {
          phoneAuthManager.phoneAuthVerificationCode = verificationId;
          phoneAuthManager.triggerOnCodeSent = true;
          phoneAuthManager.phoneAuthError = null;
        });
        completer.complete(true);
      },
      codeAutoRetrievalTimeout: (_) {
        print('codeAutoRetrievalTimeout'); // <--- add
      },
    );

    return completer.future;
  }

  @override
  Future<BaseAuthUser?> verifySmsCode({
    required BuildContext context,
    required String smsCode,
  }) async {
    if (kIsWeb) {
      return _finishSignIn(
        context,
        () => phoneAuthManager.webPhoneAuthConfirmationResult!.confirm(smsCode),
      );
    }

    final credential = PhoneAuthProvider.credential(
      verificationId: phoneAuthManager.phoneAuthVerificationCode!,
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
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message ?? 'Authentication error')),
      );
      return null;
    }
  }

  @override
  Future resetPassword({
    required String email,
    required BuildContext context,
  }) async {
    // Phone-only auth → reset password not supported.
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Password reset is not supported in phone login')),
    );
  }
}
