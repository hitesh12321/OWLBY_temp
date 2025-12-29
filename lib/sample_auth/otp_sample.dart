import 'package:flutter/material.dart';
import 'package:owlby_serene_m_i_n_d_s/sample_auth/auth_sample.dart';

class OtpSample extends StatefulWidget {
  const OtpSample({super.key});

  @override
  State<OtpSample> createState() => _OtpSampleState();
}

class _OtpSampleState extends State<OtpSample> {
    TextEditingController otpController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.purple.shade100,

      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'OTP',
                style: TextStyle(
                  shadows: [Shadow(color: Colors.black,offset: Offset(1, 2),),],
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
                keyboardType: TextInputType.number,
                controller: otpController,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(15),
                      ),
                    ),
                    labelText: "Enter Otp"),
              ),
              ElevatedButton(  
                style: const ButtonStyle(
                    backgroundColor: MaterialStatePropertyAll(Colors.blue),
                    foregroundColor: MaterialStatePropertyAll(Colors.white)),
                onPressed: () {
                  AuthSample.submitOtp(context, otpController.text);
                },
                child: const Text("Submit OTP"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}