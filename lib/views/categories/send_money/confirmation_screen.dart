import 'package:flutter/material.dart';
import 'package:qrpay/views/navbar/bottom_navbar_screen.dart';

class ConfirmationScreen extends StatelessWidget {
  final String country;
  final String flag;
  final String countryCode;
  final String amount;
  final String phoneNumber;
  final String paymentMethodImage;
  final String convertedAmount;

  ConfirmationScreen({
    required this.country,
    required this.flag,
    required this.countryCode,
    required this.amount,
    required this.phoneNumber,
    required this.paymentMethodImage,
    required this.convertedAmount,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            'Confirm Transaction',
            style: TextStyle(
                fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
          ),
          backgroundColor: const Color.fromRGBO(7, 29, 227, 0.966),
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        body: Padding(
          padding:
              const EdgeInsets.only(left: 50, top: 100, right: 50, bottom: 0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  'AMOUNT',
                  style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.w500,
                      color: Color.fromRGBO(13, 40, 217, 0.98)),
                  textAlign: TextAlign.center,
                ),
                Center(
                  child: Text(
                    '$amount KES',
                    style: const TextStyle(
                        fontSize: 50,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 8),
                Center(
                  child: Text(
                    '$convertedAmount ${_getCurrency(country)}',
                    style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w500,
                        color: Color.fromRGBO(7, 19, 97, 0.976)),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 50),
                Text('$flag $countryCode$phoneNumber',
                    style: const TextStyle(
                        fontSize: 20, color: Color.fromRGBO(7, 19, 97, 0.976))),
                const SizedBox(height: 40),
                const Text(
                  'Payment Method',
                  style: TextStyle(fontSize: 15, color: Colors.blue),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 5),
                Center(
                  child: Image.asset(paymentMethodImage, width: 65, height: 65),
                ),
                const SizedBox(height: 80),
                ElevatedButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      barrierColor: const Color.fromARGB(207, 21, 57, 86),
                      builder: (context) => AlertDialog(
                        backgroundColor: Colors.white,
                        title: const Text(
                          'Transaction Successful',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(255, 12, 38, 59)),
                        ),
                        content: const Icon(Icons.check_circle,
                            color: Colors.green, size: 100),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => BottomNavBarScreen()),
                                (Route<dynamic> route) => false,
                              );
                            },
                            child: const Text(
                              'Continue',
                              style: TextStyle(
                                  color: Color.fromARGB(255, 12, 38, 59)),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.blue,
                    minimumSize: const Size(170, 60),
                  ),
                  child: const Text(
                    'Send Money',
                    style: TextStyle(fontSize: 20),
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  String _getCurrency(String country) {
    switch (country) {
      case 'Kenya':
        return 'KES';
      case 'Somalia':
        return 'SOS';
      case 'Uganda':
        return 'UGX';
      case 'Tanzania':
        return 'USD';
      default:
        return 'USD';
    }
  }
}
