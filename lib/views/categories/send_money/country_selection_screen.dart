import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'send_money_screen.dart';

class CountrySelectionScreen extends StatelessWidget {
  final List<Map<String, String>> countries = [
    {
      'name': 'Kenya',
      'flag': 'assets/flags/kenya.png',
      'paymentMethod': 'M-Pesa',
      'paymentMethodImage': 'assets/payments/mpesa.jpg',
      'countryCode': //'+254'
          '+92'
    },
    {
      'name': 'Somalia',
      'flag': 'assets/flags/somalia.png',
      'paymentMethod': 'EVC Plus',
      'paymentMethodImage': 'assets/payments/evc_plus.png',
      'countryCode': '+252'
    },
    {
      'name': 'Uganda',
      'flag': 'assets/flags/uganda.png',
      'paymentMethod': 'MTN',
      'paymentMethodImage': 'assets/payments/mtn.jpg',
      'countryCode': '+92', //'+256'
    },
    {
      'name': 'Tanzania',
      'flag': 'assets/flags/tanzania.png',
      'paymentMethod': 'Tigo Pesa',
      'paymentMethodImage': 'assets/payments/tigo_pesa.png',
      'countryCode': '+255'
    },
    {
      'name': 'Tanzania',
      'flag': 'assets/flags/tanzania.png',
      'paymentMethod': 'Vodacom M-Pesa',
      'paymentMethodImage': 'assets/payments/vodacom_mpesa.png',
      'countryCode': '+255'
    },
    // add more options
  ];

  String getAbbreviatedFlag(String countryName) {
    switch (countryName.toLowerCase()) {
      case 'kenya':
        return '🇰🇪';
      case 'somalia':
        return '🇸🇴';
      case 'uganda':
        return '🇺🇬';
      case 'tanzania':
        return '🇹🇿';
      default:
        return ''; // Default case, return empty string
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Send Money to:',
          style: TextStyle(
              fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color.fromRGBO(7, 29, 227, 0.966),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: GridView.count(
        crossAxisCount: 2,
        padding: EdgeInsets.zero,
        childAspectRatio: 1.5 / 1,
        children: countries.map((country) {
          return InkWell(
            onTap: () {
              if (country['name'] == 'Somalia') {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: const Text(
                        'Coming Soon!',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w700),
                        textAlign: TextAlign.center,
                      ),
                      content: const Text(
                        'This feature is coming soon to Somalia.',
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
              } else {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SendMoneyScreen(
                      country: country['name']!,
                      flag: getAbbreviatedFlag(country['name']!),
                      countryCode: country['countryCode']!,
                      paymentMethodImage: country['paymentMethodImage']!,
                    ),
                  ),
                );
              }
            },
            child: Container(
              // height: 100,
              child: Card(
                elevation: 5,
                shadowColor: const Color.fromARGB(255, 0, 59, 197),
                surfaceTintColor: const Color.fromRGBO(255, 255, 255, 0.98),
                margin: const EdgeInsets.all(10),
                child: Padding(
                  padding: const EdgeInsets.all(7),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset(country['flag']!, width: 50, height: 50),
                      Text(
                        country['name']!,
                        style: const TextStyle(
                            fontSize: 15, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
