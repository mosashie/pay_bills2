import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:qrpay/utils/dimensions.dart';

class CustomLoadingAPI extends StatelessWidget {
  const CustomLoadingAPI({
    Key? key,
    this.colors,
  }) : super(key: key);
  final Color? colors;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SpinKitDualRing(
        color: colors ?? Theme.of(context).primaryColor,
        size: Dimensions.heightSize * 2.6,
      ),
    );
  }
}
