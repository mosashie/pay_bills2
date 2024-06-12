import 'package:flutter/material.dart';
import 'package:qrpay/views/categories/send_money/select_payment_method.dart';
import 'recipient_phone_screen.dart';

class SendMoneyScreen extends StatefulWidget {
  final String country;
  final String flag;
  final String countryCode;
  final String paymentMethodImage;

  SendMoneyScreen({
    required this.country,
    required this.flag,
    required this.countryCode,
    required this.paymentMethodImage,
  });

  @override
  _SendMoneyScreenState createState() => _SendMoneyScreenState();
}

class _SendMoneyScreenState extends State<SendMoneyScreen> {
  final _amountController = TextEditingController();

  String _getCurrency(String country) {
    switch (country) {
      case 'Kenya':
        return 'KES';
      case 'Somalia':
        return 'SOS';
      case 'Uganda':
        return 'UGX';
      case 'Tanzania':
        return 'TZS';
      default:
        return 'USD';
    }
  }

  double _getExchangeRate(String fromCurrency, String toCurrency) {
    if (fromCurrency == 'KES' && toCurrency == 'USD') return 0.0091;
    if (fromCurrency == 'SOS' && toCurrency == 'USD') return 0.0017;
    if (fromCurrency == 'UGX' && toCurrency == 'USD') return 0.00027;
    if (fromCurrency == 'TZS' && toCurrency == 'USD') return 0.00043;
    return 1.0;
  }

  @override
  Widget build(BuildContext context) {
    String recipientCurrency = _getCurrency(widget.country);
    String senderCurrency = 'KES';

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Send Money',
          style: TextStyle(
              fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color.fromRGBO(7, 29, 227, 0.966),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 25),
              const Text(
                'You send',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _amountController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: null,
                  prefixIcon: const Padding(
                    padding: EdgeInsets.fromLTRB(10, 5, 30, 0),
                    child: Text('🇰🇪', style: TextStyle(fontSize: 24)),
                  ),
                  suffixText: senderCurrency,
                ),
                onChanged: (value) {
                  setState(() {});
                },
              ),
              const SizedBox(height: 35),
              const Text(
                'They receive',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                textAlign: TextAlign.left,
              ),
              const SizedBox(height: 8),
              Container(
                height: 70,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.blue.shade600),
                  borderRadius: BorderRadius.circular(4.0),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(10, 5, 20, 0),
                          child: Text(widget.flag,
                              style: const TextStyle(
                                  fontSize: 24, fontWeight: FontWeight.bold)),
                        ),
                        const SizedBox(width: 8),
                        Text(_calculateReceivedAmount(),
                            style: const TextStyle(fontSize: 16)),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(10, 5, 10, 0),
                      child: Text(recipientCurrency,
                          style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.blue)),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 45),
              Text(
                'Exchange rate: 1 $senderCurrency = ${_getExchangeRate(senderCurrency, recipientCurrency)} $recipientCurrency',
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
              Text('Fee: 0.00 $senderCurrency'),
              Text('Total cost: ${_amountController.text} $senderCurrency'),
              const SizedBox(height: 45),
              ElevatedButton(
                onPressed: () {
                  if (_amountController.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Enter the Amount to continue.'),
                        backgroundColor: Colors.red,
                      ),
                    );
                  } else {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => SelectPaymentMethod(
                              country: widget.country,
                              flag: widget.flag,
                              countryCode: widget.countryCode,
                              amount: _amountController.text,
                              paymentMethodImage: widget.paymentMethodImage,
                              convertedAmount: _calculateReceivedAmount())),
                    );

                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //       builder: (context) => RecipientPhoneScreen(
                    //           country: widget.country,
                    //           flag: widget.flag,
                    //           countryCode: widget.countryCode,
                    //           amount: _amountController.text,
                    //           paymentMethodImage: widget.paymentMethodImage,
                    //           convertedAmount: _calculateReceivedAmount())),
                    // );
                  }
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.blue,
                  minimumSize: const Size(170, 60),
                ),
                child: const Text(
                  'Next',
                  style: TextStyle(fontSize: 20),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _calculateReceivedAmount() {
    String fromCurrency = 'KES';
    String toCurrency = _getCurrency(widget.country);
    double amount = double.tryParse(_amountController.text) ?? 0;
    double rate = _getExchangeRate(fromCurrency, toCurrency);
    double receivedAmount = amount * rate;
    return receivedAmount.toStringAsFixed(2);
  }
}
