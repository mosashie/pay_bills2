import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qrpay/controller/categories/virtual_card/flutter_wave_virtual_card/virtual_card_controller.dart';
import 'package:qrpay/controller/categories/virtual_card/strowallet_card/strowallelt_info_controller.dart';
import 'package:qrpay/routes/routes.dart';
import 'package:qrpay/utils/responsive_layout.dart';
import 'package:qrpay/widgets/appbar/appbar_widget.dart';

import '../../../backend/utils/custom_loading_api.dart';
import '../../../controller/categories/virtual_card/stripe_card/stripe_card_controller.dart';
import '../../../controller/categories/virtual_card/sudo_virtual_card/virtual_card_sudo_controller.dart';
import '../../../controller/navbar/dashboard_controller.dart';
import '../../../language/english.dart';
import 'flutter_wave_virtual_card/flutter_wave_virtual_screen.dart';
import 'stripe_card/stripe_create_card_screen.dart';
import 'strowallet_card/strowallet_card_screen.dart';
import 'sudo_virtual_card/sudo_virtual_screen.dart';

class VirtualCardScreen extends StatelessWidget {
  VirtualCardScreen({super.key});

  final flutterWaveController = Get.put(VirtualCardController());
  final sudoController = Get.put(VirtualSudoCardController());
  final dashboardController = Get.put(DashBoardController());
  final stripeCardController = Get.put(StripeCardController());
  final strowalletCardController = Get.put(VirtualStrowalletCardController());

  @override
  Widget build(BuildContext context) {
    String? activeVirtualSystem =
        dashboardController.dashBoardModel.data.activeVirtualSystem;
    return ResponsiveLayout(
      mobileScaffold: Scaffold(
        appBar: AppBarWidget(
          text: Strings.virtualCard,
          homeButtonShow: activeVirtualSystem == 'sudo' ? true : false,
          onTapAction: () {
            if (activeVirtualSystem == 'sudo') {
              Get.toNamed(Routes.sudoCreateCardScreen);
            } else if (activeVirtualSystem == 'flutterwave') {
              Get.toNamed(Routes.buyCardScreen);
            }
          },
          actionIcon: Icons.add_circle_outline_outlined,
        ),
        body: Obx(
          () => dashboardController.isLoading ||
                  stripeCardController.isLoading ||
                  flutterWaveController.isLoading ||
                  sudoController.isLoading ||
                  strowalletCardController.isLoading
              ? const CustomLoadingAPI()
              : dashboardController.dashBoardModel.data.activeVirtualSystem ==
                      'sudo'
                  ? SudoVirtualCardScreen(controller: sudoController)
                  : dashboardController
                              .dashBoardModel.data.activeVirtualSystem ==
                          'stripe'
                      ? StripeCreateCardScreen(
                          controller: stripeCardController,
                        )
                      : dashboardController
                                  .dashBoardModel.data.activeVirtualSystem ==
                              'flutterwave'
                          ? FlutterWaveVirtualCardScreen(
                              controller: flutterWaveController,
                            )
                          : StrowalletCardScreen(
                              controller: strowalletCardController,
                            ),
        ),
      ),
    );
  }
}
