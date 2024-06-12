import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';

import 'package:get/get.dart';
import 'package:qrpay/firebase%20auth/registration_screen.dart';

import '../routes/routes.dart';

class OtpScreen extends StatefulWidget {
  final String verificationId;
  final VoidCallback onVerified;
  final VoidCallback onResendOtp;
  // final String screen;

  const OtpScreen({
    Key? key,
    required this.verificationId,
    required this.onVerified,
    required this.onResendOtp,
    // required this.screen
  }) : super(key: key);

  @override
  _OtpScreenState createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  final List<TextEditingController> _otpControllers =
      List.generate(6, (_) => TextEditingController());
  bool _isLoading = false;
  int _resendTimeout = 60;
  Timer? _resendTimer;

  @override
  void initState() {
    super.initState();
    _startResendTimer();
  }

  @override
  void dispose() {
    _resendTimer?.cancel();
    _otpControllers.forEach((controller) => controller.dispose());
    super.dispose();
  }

  void _startResendTimer() {
    setState(() {
      _resendTimeout = 60;
    });
    _resendTimer?.cancel();
    _resendTimer = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      setState(() {
        if (_resendTimeout > 0) {
          _resendTimeout--;
        } else {
          timer.cancel();
        }
      });
    });
  }

  void _submitOtp() async {
    String otp = _otpControllers.map((controller) => controller.text).join();
    if (otp.length != 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter the complete OTP'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    PhoneAuthCredential credential = PhoneAuthProvider.credential(
      verificationId: widget.verificationId,
      smsCode: otp,
    );

    setState(() {
      _isLoading = true;
    });

    try {
      await FirebaseAuth.instance.signInWithCredential(credential);
      widget.onVerified();
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Phone number verified successfully'),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 2),
      ));
      // Get.offAndToNamed(Routes.waitForApprovalScreen);
      Navigator.pop(context);
    } catch (e) {
      print('Failed to sign in: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to sign in: $e'),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 2),
        ),
      );
      setState(() {
        _isLoading = false;
      });
    }
  }

  Widget _buildOtpDigitField(int index) {
    return SizedBox(
      width: 40,
      child: TextField(
        controller: _otpControllers[index],
        maxLength: 1,
        keyboardType: TextInputType.number,
        decoration: const InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(8.0)),
          ),
          counterText: '',
        ),
        textAlign: TextAlign.center,
        onChanged: (value) {
          if (value.length == 1 && index < 5) {
            FocusScope.of(context).nextFocus();
          } else if (value.isEmpty && index > 0) {
            FocusScope.of(context).previousFocus();
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'OTP Verification',
          style: TextStyle(
              fontSize: 18, fontWeight: FontWeight.w700, color: Colors.white),
        ),
        backgroundColor: const Color.fromARGB(255, 45, 38, 235),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Enter OTP received on your phone',
              style: TextStyle(fontSize: 14, color: Colors.black54),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(6, (index) => _buildOtpDigitField(index)),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _isLoading ? null : _submitOtp,
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.blue,
                minimumSize: const Size(170, 60),
              ),
              child: _isLoading
                  ? const CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    )
                  : const Text(
                      'Submit OTP',
                      style: TextStyle(fontSize: 17),
                    ),
            ),
            const SizedBox(height: 20),
            Text(
              'Resend OTP in $_resendTimeout seconds',
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.grey),
            ),
            TextButton(
              onPressed: _resendTimeout == 0
                  ? () {
                      widget.onResendOtp();
                      _startResendTimer();
                    }
                  : null,
              child: const Text('Resend OTP'),
            ),
          ],
        ),
      ),
    );
  }
}
