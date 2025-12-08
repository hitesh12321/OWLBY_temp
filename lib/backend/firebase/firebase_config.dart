import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

Future initFirebase() async {
  if (kIsWeb) {
    await Firebase.initializeApp(
        options: FirebaseOptions(
            apiKey: "AIzaSyBptJSigwPVeLuMWDY2rsS_t6pHJtQZSSk",
            authDomain: "owl-by-serene-minds.firebaseapp.com",
            projectId: "owl-by-serene-minds",
            storageBucket: "owl-by-serene-minds.firebasestorage.app",
            messagingSenderId: "235649149955",
            appId: "1:235649149955:web:9b697a6fb706347e977236",
            measurementId: "G-3KHN6QK769"));
  } else {
    await Firebase.initializeApp();
  }
}
