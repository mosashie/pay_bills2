import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:qrpay/utils/basic_screen_imports.dart';

import '../../../backend/utils/custom_loading_api.dart';
import '../../../controller/auth/registration/kyc_form_controller.dart';
import '../../../language/english.dart';
import '../../../language/language_controller.dart';
import '../../../routes/routes.dart';
import '../../../utils/dimensions.dart';
import '../../../utils/responsive_layout.dart';
import '../../../utils/size.dart';
import '../../../widgets/appbar/back_button.dart';
import '../../../widgets/text_labels/title_heading2_widget.dart';
import '../../../widgets/text_labels/title_heading4_widget.dart';
import 'new_kyc_controller.dart';

class NewKycFormScreen extends StatefulWidget {
  const NewKycFormScreen(
      {super.key,
      this.phone,
      this.email,
      this.password,
      this.confirmPassword,
      this.countryCode});

  final email;
  final phone;
  final password;
  final confirmPassword;
  final countryCode;

  @override
  State<NewKycFormScreen> createState() => _NewKycFormScreenState();
}

class _NewKycFormScreenState extends State<NewKycFormScreen> {
  final kycController = Get.put(NewKycController());
  final kycController2 = Get.put(BasicDataController());
  final languageController = Get.find<LanguageController>();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    print(
        "Password ${widget.password} ====== Confirm Password ${widget.confirmPassword} ===== Country Code ${widget.countryCode}   ===== Phone ${widget.phone} ====== Email ${widget.email}");
    return ResponsiveLayout(
      mobileScaffold: PopScope(
        canPop: true,
        onPopInvoked: (value) {
          // _navigateToRegistrationScreen();
        },
        child: Scaffold(
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            leading: BackButtonWidget(
              onTap: () {
                // _navigateToRegistrationScreen();
              },
            ),
          ),
          body:
              // Obx(
              // () =>
              // kycController.isLoading.value
              // ? const CustomLoadingAPI()
              // :
              _bodyWidget(context),
          // ),
        ),
      ),
    );
  }

  Widget _bodyWidget(BuildContext context) {
    return ListView(
      padding: EdgeInsets.symmetric(horizontal: Dimensions.paddingSize),
      physics: const BouncingScrollPhysics(),
      children: [
        _titleAndSubtitleWidget(context),
        // _inputWidget(context),
        _buttonWidget(context),
      ],
    );
  }

  Widget _titleAndSubtitleWidget(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        top: Dimensions.marginSizeVertical,
        bottom: Dimensions.marginSizeVertical * 1.4,
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TitleHeading2Widget(text: Strings.identityVerify.tr),
            verticalSpace(Dimensions.heightSize * 0.7),
            TitleHeading4Widget(text: Strings.VerifyFormDetails.tr),
            SizedBox(
              height: 20,
            ),
            PrimaryInputWidget(
                controller: kycController.idNumController,
                hint: 'ID Number',
                label: 'ID Number'),
            SizedBox(
              height: 20,
            ),
            PrimaryInputWidget(
                controller: kycController.idNameController,
                hint: 'Full Name',
                label: 'Full Name'),
            SizedBox(
              height: 20,
            ),
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                        width: Get.width / 2.8,
                        child: Text('Front Id Card photo')),
                    Container(
                        width: Get.width / 2.8,
                        child: Text('Back Id card Photo')),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // First Container
                    GestureDetector(
                      onTap: () {
                        kycController.isFront.value = true;
                        showBottomsheet(context);
                      },
                      child: Container(
                        width: 150,
                        height: 150,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                              color: Theme.of(context)
                                  .primaryColor
                                  .withOpacity(0.2),
                              width: 2),
                        ),
                        child: Obx(
                          () => Center(
                            child: kycController.frontIdImage.value != null
                                ? ClipRRect(
                                    borderRadius: BorderRadius.circular(12.0),
                                    child: Image.file(
                                      File(kycController
                                          .frontIdImage.value!.path),
                                      fit: BoxFit.cover,
                                      width: 150,
                                      height: 150,
                                    ),
                                  )
                                : ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: Image.asset(
                                      'assets/kycID/id_front_placeholder.png',
                                      width: 100,
                                      height: 100,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                          ),
                        ),
                      ),
                    ),
                    // Second Container
                    GestureDetector(
                      onTap: () {
                        showBottomsheetForback(context);
                      },
                      child: Container(
                        width: 150,
                        height: 150,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                              color: Theme.of(context)
                                  .primaryColor
                                  .withOpacity(0.2),
                              width: 2),
                        ),
                        child: Obx(
                          () => Center(
                            child: kycController.backIdImage.value != null
                                ? ClipRRect(
                                    borderRadius: BorderRadius.circular(12.0),
                                    child: Image.file(
                                      File(kycController
                                          .backIdImage.value!.path),
                                      fit: BoxFit.cover,
                                      width: 150,
                                      height: 150,
                                    ),
                                  )
                                : ClipRRect(
                                    borderRadius: BorderRadius.circular(16),
                                    child: Image.asset(
                                      'assets/kycID/id_back_placeholder.png',
                                      width: 100,
                                      height: 100,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Visibility(
                visible: kycController.errorMessage.value.toString().isEmpty,
                child: Obx(() => Text(
                      kycController.errorMessage.value,
                      style: TextStyle(color: Colors.red),
                    ))),
            SizedBox(
              height: 20,
            ),
            FittedBox(
              child: Row(
                children: [
                  Obx(
                    () => SizedBox(
                      width: 20,
                      child: Checkbox(
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(Dimensions.radius * 0.3),
                        ),
                        fillColor: MaterialStateProperty.all(
                            Theme.of(context).primaryColor),
                        value: kycController.termsAndCondition.value,
                        onChanged: (bool? value) {
                          kycController.termsAndCondition.value =
                              value ?? false;
                        },
                        side: MaterialStateBorderSide.resolveWith(
                          (states) => BorderSide(
                            width: 1.4,
                            color:
                                Theme.of(context).primaryColor.withOpacity(0.2),
                          ),
                        ),
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: TitleHeading4Widget(
                      color: Theme.of(context).primaryColor,
                      fontSize: Dimensions.headingTextSize5,
                      fontWeight: FontWeight.w500,
                      text: Strings.agreed.tr,
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  void showBottomsheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Pick from Gallery'),
              onTap: () async {
                Navigator.pop(context);
                try {
                  XFile? image = await ImagePicker().pickImage(
                    source: ImageSource.gallery,
                    imageQuality: 25,
                  );

                  if (image != null) {
                    kycController.frontIdImage.value = image;
                    print(
                        '=============front======${kycController.frontIdImage}');
                  }
                } catch (e) {
                  print(e);
                }
                // _getImage(ImageSource.gallery);
              },
            ),
            ListTile(
              leading: const Icon(Icons.camera),
              title: const Text('Take a Picture'),
              onTap: () async {
                Navigator.pop(context);
                try {
                  XFile? image = await ImagePicker().pickImage(
                    source: ImageSource.camera,
                    imageQuality: 25,
                  );

                  if (image != null) {
                    kycController.frontIdImage.value = image;
                    print(
                        '=============front======${kycController.frontIdImage}');
                  }
                } catch (e) {
                  print(e);
                }
                // _getImage(ImageSource.camera);
              },
            ),
            SizedBox(
              height: 20,
            )
          ],
        );
      },
    );
  }

  void showBottomsheetForback(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Pick from Gallery'),
              onTap: () async {
                Navigator.pop(context);
                try {
                  XFile? image = await ImagePicker().pickImage(
                    source: ImageSource.gallery,
                    imageQuality: 25,
                  );

                  if (image != null) {
                    kycController.backIdImage.value = image;
                    print(
                        '=============back======${kycController.backIdImage}');
                  }
                } catch (e) {
                  print(e);
                }
                // _getImage(ImageSource.gallery);
              },
            ),
            ListTile(
              leading: const Icon(Icons.camera),
              title: const Text('Take a Picture'),
              onTap: () async {
                Navigator.pop(context);
                try {
                  XFile? image = await ImagePicker().pickImage(
                    source: ImageSource.camera,
                    imageQuality: 25,
                  );

                  if (image != null) {
                    kycController.backIdImage.value = image;
                    print(
                        '=============back======${kycController.backIdImage}');
                  }
                } catch (e) {
                  print(e);
                }
                // _getImage(ImageSource.camera);
              },
            ),
            SizedBox(
              height: 20,
            )
          ],
        );
      },
    );
  }

  Widget _buttonWidget(BuildContext context) {
    return Container(
      margin:
          EdgeInsets.symmetric(vertical: Dimensions.marginSizeVertical * 0.5),
      child: /*Obx(
            () => kycController.isLoading.value
            ? const CustomLoadingAPI()
            : */
          PrimaryButton(
        title: Strings.continuee.tr,
        onPressed: () {
          // print("==============${(kycController.frontIdImage.value!.path)}");

          // kycController.uploadIdData(widget.phone, "${widget.code}");
          // kycController.isLoading.value=true;
          if (_formKey.currentState!.validate()) {
            kycController.uploadIdData("${widget.phone}", "${widget.email}",
                widget.password, widget.confirmPassword, widget.email);
          } else {
            // kycController.isLoading.value=false;
          }
          if (_formKey.currentState!.validate()) {
            // kycController2.registrationProcess();
          }
        },
      ),
      // ),
    );
  }
}
