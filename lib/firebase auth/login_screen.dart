import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import 'package:qrpay/views/navbar/bottom_navbar_screen.dart';

import '../backend/local_storage/local_storage.dart';
import '../backend/services/api_services.dart';
import 'package:http/http.dart' as http;

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Login',
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Colors.white)),
        backgroundColor: const Color.fromARGB(255, 45, 38, 235),
      ),
      body: const LoginForm(),
    );
  }
}

// today commit -m hello world how about you
String selectedCountry = 'Kenya';

class LoginForm extends StatefulWidget {
  const LoginForm({Key? key}) : super(key: key);

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final TextEditingController _phonenumController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  // String _selectedCountry = 'Kenya'; // Initialize to a default country
  bool _isPasswordVisible = false; // Password visibility toggle

  final Map<String, String> countryCodes = {
    'Kenya': '+92',
    // 'Kenya': '+254',
    'Tanzania': '+255',
    'Uganda': '+256',
    'Somalia': '+252',
  };

  Future<void> _signIn(BuildContext context) async {
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

    // Ensure phone number and password are not empty
    if (_phonenumController.text.trim().isEmpty ||
        _passwordController.text.trim().isEmpty) {
      print('Phone number and password cannot be empty');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Phone number and password cannot be empty'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    Future<void> loginApi() async {
      try {
        var request = http.MultipartRequest(
            'POST', Uri.parse('https://paybillcompany.xyz/api/user/login'));
        request.fields.addAll({
          'mobileno':
              '${countryCodes[selectedCountry].toString().substring(1)}${_phonenumController.text}',
          // 'email':
          //     '${selectedCountry.toLowerCase()}${_phonenumController.text}@gmail.com',
          'password': _passwordController.text
        });
        print(request.fields);

        http.StreamedResponse response = await request.send();

        if (response.statusCode == 200) {
          Map<String, dynamic> data =
              jsonDecode(await response.stream.bytesToString());
          final token = data['data']['token'];
          final user = data['data']["user"];
          LocalStorage.saveToken(token: token);
          LocalStorage.saveImage(image: user['userImage']);
          LocalStorage.saveEmail(email: user['email']);
          LocalStorage.saveName(
              name: "${user['firstname']} ${user['lastname']}");
          LocalStorage.saveId(id: user["id"].toString());
          LocalStorage.saveKycVerification(
              isKycVerification: user["kyc_verified"] == 2 ? true : false);
          LocalStorage.saveCountryCode(countryCodeValue: user["mobile_code"]);
          LocalStorage.saveCountry(countryValue: user['address']['country']);
          Get.to(BottomNavBarScreen());
        } else {
          final errorResponse = await response.stream.bytesToString();
          print('Error response: $errorResponse');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Login failed: ${response.reasonPhrase}'),
              backgroundColor: Colors.red,
              duration: const Duration(seconds: 2),
            ),
          );
        }
      } catch (e) {
        print('Error during API call: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error during API call: $e'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 2),
          ),
        );
      }
    }

    // Construct the email as countryname+phonenumber@paybill.com
    final email =
        '${selectedCountry.toLowerCase()}${_phonenumController.text.trim()}@paybill.com';
    print(email);
    print("Api request link => ${ApiServices.loginApi(body: {
          // 'email' email,   Farrukh Changed to
          'mobileno': //this
              '${countryCodes[selectedCountry].toString().substring(1)}${_phonenumController.text}', //
          'password': _passwordController.text
        })}");

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: _passwordController.text,
      );
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Logged in successfully'),
          backgroundColor: Color.fromARGB(255, 65, 189, 85),
          duration: Duration(seconds: 2),
        ),
      );
      await loginApi();
    } on FirebaseAuthException catch (e) {
      if (e.code == 'wrong-password') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Incorrect password. Please try again.'),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 2),
          ),
        );
      } else if (e.code == 'user-not-found') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('This user is not registered.'),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 2),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.message ?? 'Error signing in'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      print('Error signing in: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error signing in: $e'),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 50),
            DropdownButtonFormField<String>(
              value: selectedCountry.isEmpty ? null : selectedCountry,
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
              onChanged: (value) {
                setState(() {
                  selectedCountry = value!;
                  if (value == 'Somalia') {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text(
                            'Coming Soon',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          content: const Text(
                            'Login for Somalia is coming soon.',
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
            if (selectedCountry != 'Somalia') ...[
              GestureDetector(
                onTap: () {
                  if (selectedCountry.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Please select your country first.'),
                        backgroundColor: Colors.red,
                        duration: Duration(seconds: 2),
                      ),
                    );
                  }
                },
                child: AbsorbPointer(
                  absorbing: selectedCountry.isEmpty,
                  child: TextField(
                    controller: _phonenumController,
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(10), // Limit to 9 digits
                    ],
                    decoration: InputDecoration(
                      labelText: 'Phone Number',
                      prefix: SizedBox(
                        width: 45,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              countryCodes[selectedCountry] ?? '',
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
                  ),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _passwordController,
                obscureText: !_isPasswordVisible, // Toggle password visibility
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
              const SizedBox(height: 50),
              SizedBox(
                height: 55,
                width: 200,
                child: ElevatedButton(
                  onPressed: () => _signIn(context),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.blue,
                    minimumSize: const Size(170, 60),
                    elevation: 4,
                  ),
                  child: const Text(
                    'Login',
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
