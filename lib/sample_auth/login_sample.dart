import 'package:flutter/material.dart';
import 'package:owlby_serene_m_i_n_d_s/backend/api_requests/api_calls.dart';
import 'package:owlby_serene_m_i_n_d_s/flutter_flow/nav/nav.dart';
import 'package:owlby_serene_m_i_n_d_s/sample_auth/auth_sample.dart';

class LoginSample extends StatefulWidget {
  const LoginSample({super.key});

  @override
  State<LoginSample> createState() => _LoginSampleState();
}

class _LoginSampleState extends State<LoginSample> {
  TextEditingController phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    String phoneNumber = phoneController.text;
    return Scaffold(
      backgroundColor: Colors.purple.shade100,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Login / SignUp',
                style: TextStyle(
                  shadows: [
                    Shadow(
                      color: Colors.black,
                      offset: Offset(1, 2),
                    ),
                  ],
                  color: Colors.white,
                  fontSize: 28,
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 40,
              ),
              TextField(
                controller: phoneController,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(15),
                    ),
                  ),
                  labelText: "Enter Phone Number",
                  counterText: "",
                ),
                maxLength: 10,
                keyboardType: TextInputType.number,
              ),
              const SizedBox(
                height: 10,
              ),
              ElevatedButton(
                style: const ButtonStyle(
                  backgroundColor: MaterialStatePropertyAll(Colors.red),
                  foregroundColor: MaterialStatePropertyAll(Colors.white),
                ),
                onPressed: () async {
                  final phone = phoneController.text.trim();

                  if (RegExp(r'^[0-9]{10}$').hasMatch(phone)) {
                    final checkuserResponse =
                        await CheckUserApi.call(phoneNumber: phone);

                    final userExists =
                        CheckUserApi.userExists(checkuserResponse);

                    print("❤️ check user exists: $userExists");
                    if (userExists) {
                      print("❤️ User exists. Proceeding to login.");
                      AuthSample.verifyPhoneNumber(context, phone);
                    } else {
                      print("❤️ User does not exist. Proceeding to sign up.");
                      context.pushReplacementNamed('createAccountScreen');
                    }
                  }
                },
                child: const Text("Send OTP"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
