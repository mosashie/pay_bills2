import 'package:flutter/material.dart';
import 'confirmation_screen.dart';

class RecipientPhoneScreen extends StatefulWidget {
  final String country;
  final String flag;
  final String countryCode;
  final String amount;
  final String paymentMethodImage;
  final String convertedAmount;

  RecipientPhoneScreen({
    required this.country,
    required this.flag,
    required this.countryCode,
    required this.amount,
    required this.paymentMethodImage,
    required this.convertedAmount,
  });

  @override
  _RecipientPhoneScreenState createState() => _RecipientPhoneScreenState();
}

class _RecipientPhoneScreenState extends State<RecipientPhoneScreen> {
  final _recipientPhoneController = TextEditingController();
  final _confirmPhoneController = TextEditingController();

  @override
  void dispose() {
    _recipientPhoneController.dispose();
    _confirmPhoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Recipient Phone',
          style: TextStyle(
              fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color.fromRGBO(7, 29, 227, 0.966),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 100),
              TextField(
                controller: _recipientPhoneController,
                keyboardType: TextInputType.phone,
                style: const TextStyle(fontSize: 20),
                decoration: InputDecoration(
                  labelText: 'Recipient phone',
                  prefixText: '${widget.flag} ${widget.countryCode} ',
                  prefixStyle: const TextStyle(fontSize: 20),
                  counterText: '',
                ),
                maxLength: 10,
              ),
              const SizedBox(height: 25),
              TextField(
                controller: _confirmPhoneController,
                keyboardType: TextInputType.phone,
                style: const TextStyle(fontSize: 20),
                decoration: InputDecoration(
                  labelText: 'Confirm recipient phone',
                  prefixText: '${widget.flag} ${widget.countryCode} ',
                  prefixStyle: const TextStyle(fontSize: 20),
                  counterText: '',
                ),
                maxLength: 10,
              ),
              const SizedBox(height: 50),
              ElevatedButton(
                onPressed: () {
                  if (_recipientPhoneController.text.length != 10) {
                    //Farrukh Changed

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Number incorrectly formatted!'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  } else if (_recipientPhoneController.text !=
                      _confirmPhoneController.text) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Phone numbers do not match!'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  } else {
                    print(
                        "ConfirmationScreen........................ forwarding Data${widget.country}${widget.flag}${widget.countryCode}${widget.amount}${_recipientPhoneController.text}${widget.paymentMethodImage}${widget.convertedAmount}");
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ConfirmationScreen(
                                country: widget.country,
                                flag: widget.flag,
                                countryCode: widget.countryCode,
                                amount: widget.amount,
                                phoneNumber: _recipientPhoneController.text,
                                paymentMethodImage: widget.paymentMethodImage,
                                convertedAmount: widget.convertedAmount,
                              )),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.blue,
                  minimumSize: const Size(170, 60),
                ),
                child: const Text(
                  'Confirm',
                  style: TextStyle(fontSize: 20),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
