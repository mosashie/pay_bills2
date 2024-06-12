import 'package:flutter/material.dart';
import 'package:qrpay/utils/basic_screen_imports.dart';
import 'package:qrpay/utils/custom_color.dart';
import 'package:qrpay/utils/custom_style.dart';
import 'package:qrpay/utils/dimensions.dart';
import 'package:qrpay/views/categories/send_money/recipient_phone_screen.dart';
import 'package:qrpay/widgets/text_labels/custom_title_heading_widget.dart';

class SelectPaymentMethod extends StatefulWidget {
  final String country;
  final String flag;
  final String countryCode;
  final String amount;
  final String paymentMethodImage;
  final String convertedAmount;
  const SelectPaymentMethod(
      {required this.country,
      required this.flag,
      required this.countryCode,
      required this.amount,
      required this.paymentMethodImage,
      required this.convertedAmount,
      super.key});

  @override
  State<SelectPaymentMethod> createState() => _SelectPaymentMethodState();
}

class _SelectPaymentMethodState extends State<SelectPaymentMethod> {
  List<List<String>> listOfKenya = [
    [
      'assets/payments/mpesa.jpg',
      'M-pesa',
    ],
    [
      'assets/payments/airtel_1.JPG',
      'Airtel',
    ],
  ];
  List<List<String>> listOfTanzania = [
    [
      'assets/payments/vodacom_mpesa.png',
      "Vodacom Mpesa",
    ],
    [
      'assets/payments/tigo_pesa.png',
      'Tigo Pesa',
    ],
  ];
  List<List<String>> listOfUganda = [
    ['assets/payments/mtn.jpg', 'MTN'],
    ['assets/payments/airtel_1.JPG', 'Airtel'],
  ];
  List<List<String>> listOfEthiopia = [
    ['assets/payments/airtel_1.JPG', 'Airtel'],
  ];
  //  3325010168
  List<List<String>> methodsList = [];
  void checkCountry() {
    switch (widget.country) {
      case "Kenya":
        methodsList = listOfKenya;
        break;
      case "Tanzania":
        methodsList = listOfTanzania;
        break;
      case "Uganda":
        methodsList = listOfUganda;
        break;
      case "Ethiopia":
        methodsList = listOfEthiopia;
        break;
      default:
        methodsList = listOfKenya;
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkCountry();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Select Wallet',
          style: TextStyle(
              fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color.fromRGBO(7, 29, 227, 0.966),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SafeArea(
        child: Container(
          margin: EdgeInsets.all(15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomTitleHeadingWidget(
                style: CustomStyle.darkHeading1TextStyle.copyWith(
                  fontSize: Dimensions.headingTextSize4 * 2,
                  fontWeight: FontWeight.w800,
                  color: CustomColor.blackColor,
                ),
                text: 'Mobile Money',
              ),
              Text("Select a Mobile wallet Option"),
              SizedBox(
                height: 10.h,
              ),
              Expanded(
                  child: Container(
                child: ListView.builder(
                    itemCount: methodsList.length,
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => RecipientPhoneScreen(
                                    country: widget.country,
                                    flag: widget.flag,
                                    countryCode: widget.countryCode,
                                    amount: widget.amount,
                                    paymentMethodImage:
                                        widget.paymentMethodImage,
                                    convertedAmount: widget.convertedAmount),
                              ));
                        },
                        child: methodsCard(
                            iconUrl: methodsList[index][0],
                            tile: methodsList[index][1]),
                      );
                    }),
              ))
            ],
          ),
        ),
      ),
    );
  }

  Widget methodsCard({required String iconUrl, required String tile}) {
    return Container(
      margin: EdgeInsets.only(top: 10),
      decoration: BoxDecoration(
          border: Border.all(), borderRadius: BorderRadius.circular(10)),
      padding: EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 10),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.asset(
              iconUrl,
              scale: 1,
              height: 50,
              // width: 100,
            ),
          ),
          SizedBox(
            width: 10,
          ),
          Expanded(child: Text(tile)),
          Icon(Icons.arrow_forward_ios),
        ],
      ),
    );
  }
}
