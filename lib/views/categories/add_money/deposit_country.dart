import 'package:flutter/material.dart';

import 'package:qrpay/views/categories/add_money/add_money_screen.dart';

class DepositCountryScreen extends StatelessWidget {
  const DepositCountryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Deposit Money:',
          style: TextStyle(
              fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color.fromRGBO(7, 29, 227, 0.966),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: SingleChildScrollView(
          child: DataTable(
            columnSpacing: 10,
            horizontalMargin: 10,
            border: const TableBorder(
              bottom: BorderSide(
                  width: 1, color: Color.fromARGB(255, 183, 181, 181)),
              verticalInside: BorderSide(
                color: Color.fromARGB(255, 183, 181, 181),
                width: 1,
              ),
            ),
            columns: const [
              DataColumn(label: Text('     Country')),
              DataColumn(label: Text('     Payment Method')),
              DataColumn(label: Text('     Deposit')),
            ],
            rows: _buildRows(context),
          ),
        ),
      ),
    );
  }

  List<DataRow> _buildRows(BuildContext context) {
    List<Map<String, dynamic>> countries = [
      {
        'country': 'Kenya',
        'flag': 'assets/flags/kenya.png',
        'paymentMethod': 'M-Pesa',
        'paymentMethodImage': 'assets/payments/mpesa.jpg',
        'countryCode': '+254',
        'flagEmoji': '🇰🇪',
      },
      {
        'country': 'Somalia',
        'flag': 'assets/flags/somalia.png',
        'paymentMethod': 'EVC Plus',
        'paymentMethodImage': 'assets/payments/evc_plus.png',
        'countryCode': '+252',
        'flagEmoji': '🇸🇴',
      },
      {
        'country': 'Uganda',
        'flag': 'assets/flags/uganda.png',
        'paymentMethod': 'MTN',
        'paymentMethodImage': 'assets/payments/mtn.jpg',
        'countryCode': '+256',
        'flagEmoji': '🇺🇬',
      },
      // {
      //   'country': 'Tanzania',
      //   'flag': 'assets/flags/tanzania.png',
      //   'paymentMethod': 'Tigo Pesa',
      //   'paymentMethodImage': 'assets/payments/tigo_pesa.png',
      //   'countryCode': '+255',
      //   'flagEmoji': '🇹🇿',
      // },
      {
        'country': 'Tanzania',
        'flag': 'assets/flags/tanzania.png',
        'paymentMethod': 'Vodacom M-Pesa',
        'paymentMethodImage': 'assets/payments/vodacom_mpesa.png',
        'countryCode': '+255',
        'flagEmoji': '🇹🇿',
      },
      // {
      //   'country': 'Worldwide',
      //   'flag': 'assets/flags/worldwide.png',
      //   'paymentMethod': 'Bank Cards',
      //   'paymentMethodImage': 'assets/payments/cards.jpg',
      //   'countryCode': '',
      //   'flagEmoji': '',
      // },
      // {
      //   'country': 'Worldwide',
      //   'flag': 'assets/flags/worldwide.png',
      //   'paymentMethod': 'PayPal',
      //   'paymentMethodImage': 'assets/payments/paypal.png',
      //   'countryCode': '',
      //   'flagEmoji': '',
      // },
    ];

    return countries.map((country) {
      return DataRow(cells: [
        DataCell(Row(
          children: [
            Image.asset(country['flag'], width: 32, height: 32),
            const SizedBox(width: 8),
            Text(country['country']),
          ],
        )),
        DataCell(Row(
          children: [
            Image.asset(country['paymentMethodImage'], width: 32, height: 32),
            const SizedBox(width: 8),
            Text(country['paymentMethod']),
          ],
        )),
        DataCell(
          ElevatedButton(
            onPressed: () {
              if (country['country'] == 'Somalia') {
                // Show an alert dialog for Somalia
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text(
                      'Coming Soon!',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
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
                        child: const Text('OK'),
                      ),
                    ],
                  ),
                );
              } else {
                // Navigate to DepositScreen for other countries
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => DepositScreen()),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              minimumSize: const Size(10, 30),
            ),
            child: const Text(
              'Deposit',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
      ]);
    }).toList();
  }
}
