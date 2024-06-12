import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';
import 'package:qrpay/controller/categories/deposit/deposti_controller.dart';

import '../../../backend/services/notification_service.dart';
import '../../../backend/utils/custom_loading_api.dart';
import '../../../language/english.dart';
import '../../../routes/routes.dart';
import '../../../utils/dimensions.dart';
import '../../../widgets/appbar/appbar_widget.dart';
import '../../../widgets/buttons/primary_button.dart';
import '../../../widgets/others/congratulation_widget.dart';

class AddMoneyManualPaymentScreen extends StatelessWidget {
  AddMoneyManualPaymentScreen({super.key});

  final controller = Get.put(DepositController());
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      onPopInvoked: (value) {
        Get.offAllNamed(Routes.bottomNavBarScreen);
      },
      child: Scaffold(
        appBar: const AppBarWidget(text: Strings.preview),
        body: Obx(
          () => controller.isLoading
              ? const CustomLoadingAPI()
              : _bodyWidget(context),
        ),
      ),
    );
  }

  _bodyWidget(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: Dimensions.paddingSize * 0.7,
        vertical: Dimensions.paddingSize * 0.7,
      ),
      child: Form(
        key: formKey,
        child: ListView(
          scrollDirection: Axis.vertical,
          physics: const BouncingScrollPhysics(),
          children: [
            _descriptionWidget(context),
            ...controller.inputFields.map((element) {
              return element;
            }).toList(),
            _buttonWidget(context)
          ],
        ),
      ),
    );
  }

  _buttonWidget(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: Dimensions.marginSizeVertical),
      child: Obx(() => controller.isConfirmManualLoading
          ? const CustomLoadingAPI()
          : PrimaryButton(
              title: Strings.payNow.tr,
              onPressed: () {
                if (formKey.currentState!.validate()) {
                  controller
                      .manualPaymentProcess()
                      .then((value) => StatusScreen.show(
                          context: context,
                          subTitle: Strings.yourmoneyDepositSuccess.tr,
                          onPressed: () {
                            Get.offAllNamed(Routes.bottomNavBarScreen);
                            NotificationService.showLocalNotification(
                              title: 'Success',
                              body:
                                  'Your money has been add successfully. Thanks for using QRPAY',
                            );
                          }));
                }
              },
            )),
    );
  }

  _descriptionWidget(BuildContext context) {
    final data = controller.addMoneyManualInsertModel.data;
    return Container(
      padding: EdgeInsets.symmetric(
          vertical: Dimensions.paddingSize * 0.5,
          horizontal: Dimensions.paddingSize * 0.2),
      margin:
          EdgeInsets.symmetric(vertical: Dimensions.marginSizeVertical * 0.4),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(Dimensions.radius),
          // color: Theme.of(context).primaryColor.withOpacity(0.5),
          border: Border.all(
              width: 0.8,
              color: Theme.of(context).primaryColor.withOpacity(0.3))),
      child: Html(
        data: data.details,
      ),
    );
  }
}
