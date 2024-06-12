import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:qrpay/views/auth/kyc_from/new_kyc_form.dart';

import 'otp_screen.dart'; // Import the OtpScreen

import 'package:qrpay/views/auth/kyc_from/kyc_from_screen.dart';

class RegistrationScreen extends StatelessWidget {
  const RegistrationScreen({Key? key}) : super(key: key);
  // bool isRegister;
  // String screen;
  // RegistrationScreen({Key? key,required this.isRegister,required this.screen}) : super(key: key);
  static RxString phone = ''.obs;
  @override
  Widget build(BuildContext context) {
    log('==========reg');
    return Scaffold(
      appBar: AppBar(
        // title:  isRegister? Text(
        title: const Text(
          'User Registration',
          style: TextStyle(
              fontSize: 18, fontWeight: FontWeight.w700, color: Colors.white),
        ),
        //     :Text(
        //   'Verfy Phone Number',
        //   style: TextStyle(
        //       fontSize: 18, fontWeight: FontWeight.w700, color: Colors.white),
        // ),
        backgroundColor: const Color.fromARGB(255, 45, 38, 235),
      ),
      body: const RegistrationForm(),
      // body:  RegistrationForm(screen: screen,),
      //
    );
  }
}

class RegistrationForm extends StatefulWidget {
  const RegistrationForm({Key? key}) : super(key: key);
  // final String screen;
  // RegistrationForm({Key? key, required this.screen}) : super(key: key);

  @override
  _RegistrationFormState createState() => _RegistrationFormState();
}

class _RegistrationFormState extends State<RegistrationForm> {
  final TextEditingController _phonenumController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  String _selectedCountry = '';
  bool _isPhoneVerified = false;
  bool _isLoading = false;
  String? _verificationId;
  bool _showVerificationInfo = false; // Add this variable
  bool _isPasswordVisible = false; // Add this variable
  bool _isConfirmPasswordVisible = false; // Add this variable

  final Map<String, String> countryCodes = {
    // 'Kenya': '+254',
    'Kenya': '+92',
    'Tanzania': '+255',
    'Uganda': '+256',
    'Somalia': '+252',
  };

  @override
  void initState() {
    super.initState();
    _phonenumController.addListener(_updateVerificationInfoVisibility);
  }

  void _updateVerificationInfoVisibility() {
    setState(() {
      _showVerificationInfo =
          _phonenumController.text.length == 10; //10 farrukh changed
    });
  }

  @override
  void dispose() {
    _phonenumController.removeListener(_updateVerificationInfoVisibility);
    _phonenumController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }
  // void _verifyPhoneNumber(String screen) async {

  void _verifyPhoneNumber() async {
    final phoneNumber =
        countryCodes[_selectedCountry]! + _phonenumController.text.trim();

    setState(() {
      _isLoading = true;
    });

    try {
      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        timeout: const Duration(seconds: 60),
        verificationCompleted: (PhoneAuthCredential credential) async {
          await FirebaseAuth.instance.signInWithCredential(credential);
          setState(() {
            _isPhoneVerified = true;
            // RegistrationScreen.phone.value=phoneNumber;
            _isLoading = false;
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Phone number verified successfully'),
                backgroundColor: Colors.green,
                duration: Duration(seconds: 2),
              ),
            );
          });
        },
        verificationFailed: (FirebaseAuthException e) {
          print('Failed to verify phone number');
          setState(() {
            _isLoading = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Failed to verify phone number'),
              backgroundColor: Colors.red,
              duration: const Duration(seconds: 2),
            ),
          );
        },
        codeSent: (String verificationId, int? resendToken) {
          setState(() {
            _isLoading = false;
            _verificationId = verificationId;
          });
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => OtpScreen(
                verificationId: verificationId,
                onVerified: () {
                  setState(() {
                    _isPhoneVerified = true;
                  });
                },
                onResendOtp: _verifyPhoneNumber,
                // onResendOtp: ()=>_verifyPhoneNumber(screen),
                // screen: screen,
              ),
            ),
          ).then((_) {
            setState(() {
              _showVerificationInfo = false;
            });
          });
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          setState(() {
            _isLoading = false;
            _verificationId = verificationId;
          });
        },
      );
    } catch (e) {
      print('Error verifying phone number: xxx');
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error verifying phone number: xxx'),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: ListView(
          children: [
            const SizedBox(height: 50),
            DropdownButtonFormField<String>(
              value: _selectedCountry.isEmpty ? null : _selectedCountry,
              hint: const Text('Select Country'),
              items: countryCodes.keys.map((String country) {
                return DropdownMenuItem<String>(
                  value: country,
                  child: Row(
                    children: [
                      Image.asset(
                        'assets/flags/${country.toLowerCase()}.png',
                        width: 32,
                        height: 32,
                      ),
                      const SizedBox(width: 10),
                      Text(country),
                    ],
                  ),
                );
              }).toList(),
              onChanged: _isPhoneVerified
                  ? null
                  : (value) {
                      setState(() {
                        _selectedCountry = value!;
                        if (value == 'Somalia') {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text(
                                  'Coming Soon',
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w700),
                                  textAlign: TextAlign.center,
                                ),
                                content: const Text(
                                  'Registration for Somalia is coming soon.',
                                  style: TextStyle(fontSize: 15),
                                  textAlign: TextAlign.center,
                                ),
                                actions: <Widget>[
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text(
                                      'OK',
                                      style: TextStyle(color: Colors.black),
                                    ),
                                  ),
                                ],
                              );
                            },
                          );
                        }
                      });
                    },
              decoration: InputDecoration(
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide:
                      const BorderSide(color: Color.fromARGB(255, 45, 38, 235)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide:
                      const BorderSide(color: Color.fromARGB(255, 45, 38, 235)),
                ),
              ),
              isExpanded: true,
            ),
            const SizedBox(height: 20),
            if (_selectedCountry != 'Somalia')
              TextField(
                controller: _phonenumController,
                enabled: !_isPhoneVerified,
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(
                      10), // 10 Farrukh Changed to 9
                ],
                decoration: InputDecoration(
                  labelText: 'Phone Number',
                  prefix: SizedBox(
                    width: 45,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          countryCodes[_selectedCountry] ?? '',
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(width: 8),
                      ],
                    ),
                  ),
                ),
                onChanged: (value) {
                  if (_selectedCountry.isEmpty) {
                    _phonenumController.clear();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Please select your country first.'),
                        backgroundColor: Colors.red,
                        duration: Duration(seconds: 2),
                      ),
                    );
                  }
                },
              ),
            const SizedBox(height: 50),
            if (_selectedCountry != 'Somalia' && !_isPhoneVerified)
              ElevatedButton(
                // onPressed: (){_verifyPhoneNumber(widget.screen);},
                onPressed: _verifyPhoneNumber,
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
                        'Perform Captcha Verification',
                        style: TextStyle(fontSize: 17),
                      ),
              ),
            const SizedBox(
              height: 30,
            ),
            Visibility(
                visible: _showVerificationInfo,
                child: Stack(
                  children: [
                    Center(
                        child: Image.asset(
                      'assets/message/message.png',
                      height: 140,
                      width: 220,
                      fit: BoxFit.cover,
                    )),
                    Center(
                        child: Container(
                            padding: EdgeInsets.only(top: 15),
                            width: 180,
                            child: Text(
                              'You might be taken out of the app in a browser for Google ReCaptcha Verification.',
                              textAlign: TextAlign.center,
                            )))
                  ],
                )

                // Container(
                //   padding:
                //       const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
                //   child: const Text(
                //     'You might be taken out of the app in a browser for Google ReCaptcha Verification.',
                //     style: TextStyle(
                //         fontSize: 14, color: Color.fromARGB(255, 199, 63, 18)),
                //     textAlign: TextAlign.center,
                //   ),
                // ),
                ),
            if (_isPhoneVerified)
              Column(
                children: [
                  TextField(
                    controller: _passwordController,
                    obscureText: !_isPasswordVisible,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      suffixIcon: IconButton(
                        icon: Icon(
                          _isPasswordVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                        ),
                        onPressed: () {
                          setState(() {
                            _isPasswordVisible = !_isPasswordVisible;
                          });
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: _confirmPasswordController,
                    obscureText: !_isConfirmPasswordVisible,
                    decoration: InputDecoration(
                      labelText: 'Confirm Password',
                      suffixIcon: IconButton(
                        icon: Icon(
                          _isConfirmPasswordVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                        ),
                        onPressed: () {
                          setState(() {
                            _isConfirmPasswordVisible =
                                !_isConfirmPasswordVisible;
                          });
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),
                  ElevatedButton(
                    onPressed: () => _registerUser(context),
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.blue,
                      minimumSize: const Size(170, 60),
                    ),
                    child: const Text(
                      'Register',
                      style: TextStyle(fontSize: 17),
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  void _registerUser(BuildContext context) async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No internet connection. Please try again.'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    if (!_isPhoneVerified) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Phone number is not verified.'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    if (_passwordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Passwords do not match.'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    try {
      final UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email:
            '${_selectedCountry}${_phonenumController.text.trim()}@paybill.com',
        password: _passwordController.text,
      );

      final String uid = userCredential.user!.uid;

      await FirebaseFirestore.instance.collection('users').doc(uid).set({
        'countryCode': countryCodes[_selectedCountry],
        'phonenum': _phonenumController.text,
        'country': _selectedCountry,
      });
      RegistrationScreen.phone.value = _phonenumController.text;

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text(
              'Registration Successful',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
              textAlign: TextAlign.center,
            ),
            content: const Text(
              'Your account has been registered successfully.',
              style: TextStyle(
                fontSize: 15,
              ),
              textAlign: TextAlign.center,
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) => NewKycFormScreen(
                          phone: _phonenumController.text,
                          password: _passwordController.text,
                          confirmPassword: _confirmPasswordController.text,
                          countryCode: _selectedCountry,
                          email:
                              '${_selectedCountry}${_phonenumController.text.trim()}@gmail.com'),
                    ),
                    (route) => false,
                  );
                },
                child: const Text(
                  'OK',
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ],
          );
        },
      );
    } catch (e) {
      if (e is FirebaseAuthException) {
        if (e.code == 'weak-password') {
          _showErrorDialog(context, 'The password provided is too weak.');
        } else if (e.code == 'email-already-in-use') {
          _showErrorDialog(context, 'The user is already registered.');
        } else {
          _showErrorDialog(context, e.message ?? 'An error occurred.');
        }
      } else {
        _showErrorDialog(context, 'An error occurred.');
      }
    }
  }

  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Registration Error',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
            textAlign: TextAlign.center,
          ),
          content: Text(
            message,
            style: const TextStyle(
              fontSize: 15,
            ),
            textAlign: TextAlign.center,
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                'OK',
                style: TextStyle(color: Colors.black),
              ),
            ),
          ],
        );
      },
    );
  }
}
