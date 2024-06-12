import 'dart:convert';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:image_picker/image_picker.dart';
import 'package:qrpay/firebase%20auth/login_screen.dart';
import 'package:qrpay/firebase%20auth/registration_screen.dart';
import 'dart:io';
import 'package:http_parser/http_parser.dart';

import '../../../backend/local_storage/local_storage.dart';
import '../../../controller/auth/registration/kyc_form_controller.dart';
import '../../../routes/routes.dart';
import 'package:http/http.dart' as http;

class NewKycController extends GetxController {
  RxBool isLoading = false.obs;
  final idNumController = TextEditingController();
  final idNameController = TextEditingController();
  RxBool termsAndCondition = false.obs;
  RxBool isFront = false.obs;
  RxBool frontId = false.obs;
  RxBool backId = false.obs;
  RxString errorMessage = ''.obs;
  // final _isLoading = false.obs;
  //
  // bool get isLoading => _isLoading.value;

  final Rx<XFile?> frontIdImage = Rx<XFile?>(null);
  final Rx<XFile?> backIdImage = Rx<XFile?>(null);

  Future<void> getImage(ImageSource source) async {
    try {
      XFile? image = await ImagePicker().pickImage(
        source: source,
        imageQuality: 25,
      );

      if (image != null) {
        if (isFront.value) {
          frontIdImage.value = image;
          print('=============front======${frontIdImage}');
          isFront.value = false;
          frontId.value = true;
        } else {
          backIdImage.value = image;
          print('=============back======${backIdImage}');
          backId.value = true;
        }
      }
    } catch (e) {
      print(e);
    }
  }

  final kycController = Get.put(BasicDataController());
  // final kycControllerR = Get.put(NewKycController());
  void uploadIdData(String phoneNumber, String code, String password,
      String confirmPass, String email) async {
    Get.defaultDialog(
        title: "Loading....",
        content: Center(
          child: CircularProgressIndicator(),
        ));
    try {
      // Initialize controllers
      final kycController = Get.put(BasicDataController());
      final kycControllerR = Get.put(NewKycController());

      // Log data for debugging
      print("===================data sending");
      print('Front Image Path: ${kycControllerR.frontIdImage.value!.path}');
      print('Back Image Path: ${kycControllerR.backIdImage.value!.path}');

      // Firebase Firestore upload
      await FirebaseFirestore.instance
          .collection('id_cards')
          .doc(phoneNumber)
          .set({
        'phoneNumber': phoneNumber,
        'email': '$code$phoneNumber@gmail.com',
        // Add other fields as necessary
      });

      // Prepare the request
      var request = http.MultipartRequest(
          'POST', Uri.parse('https://paybillcompany.xyz/api/user/register'));

      // Add fields
      request.fields.addAll({
        'firstname': kycControllerR.idNameController.text,
        'lastname': kycControllerR.idNameController.text,
        'email': email,
        'password': password,
        'country': 'pakistan',
        'city': 'peshawar',
        'phone_code': '92',
        'phone': phoneNumber,
        'zip_code': '25000',
        'agree': kycControllerR.termsAndCondition.value.toString(),
        'password_confirmation': confirmPass,
        'id_number': kycControllerR.idNumController.text,
        'full_name_on_the_id': kycControllerR.idNameController.text,
      });

      // Add image files
      request.files.add(await http.MultipartFile.fromPath(
          'id_frontside', kycControllerR.frontIdImage.value!.path,
          contentType: MediaType('image', 'jpeg')));
      request.files.add(await http.MultipartFile.fromPath(
          'id__backside', kycControllerR.backIdImage.value!.path,
          contentType: MediaType('image', 'jpeg')));

      // Log request fields for debugging
      print("====================request ${request.fields}");

      // Send the request
      http.StreamedResponse response = await request.send();

      // Handle response
      if (response.statusCode == 200) {
        String responseBody = await response.stream.bytesToString();
        Map<String, dynamic> data = jsonDecode(responseBody);

        print("Response Data: $data");

        // Extract and save data
        final token = data['data']['token'];
        final user = data['data']["user"];
        LocalStorage.saveToken(token: token);
        LocalStorage.saveImage(image: user['userImage']);
        LocalStorage.saveEmail(email: user['email']);
        LocalStorage.saveKycVerification(
            isKycVerification: user["kyc_verified"] == 2 ? true : false);
        LocalStorage.saveName(name: "${user['firstname']} ${user['lastname']}");
        LocalStorage.saveId(id: user["id"].toString());
        LocalStorage.saveCountryCode(countryCodeValue: user["mobile_code"]);
        LocalStorage.saveCountry(countryValue: user['address']['country']);
        // Get.back(); Farrukh Changed

        // Navigate to the dashboard or other appropriate screen
        Get.find<BasicDataController>().goToDashboardScreen();
      } else {
        print("Error: ${response.statusCode}");
        print(await response.stream.bytesToString());
        print(response.reasonPhrase);
        Get.back();
      }
    } catch (e) {
      print('Error: $e');
      Get.back();
    }
  }

  Future<String> _uploadImage(
      XFile? frontImage, XFile? backImage, String fileName) async {
    if (frontImage == null || backImage == null) {
      log('==========null');
      errorMessage.value = 'Please upload all documents';
      return '';
    }
    final file = File(frontImage!.path);
    if (!(await file.exists())) {
      log('==========file does not exist');
      errorMessage.value = 'Please upload all documents';
      return '';
    }
    await getFileSize(frontImage.path);
    try {
      errorMessage.value = '';
      log('=================file exists');
      Reference ref =
          FirebaseStorage.instance.ref().child('user_ids').child(fileName);
      log('=================uploading file');
      var content = frontImage.path;
      final task = ref.putFile(File(content));

      final snapshot = await task.whenComplete(() => null);

      content = await snapshot.ref.getDownloadURL();
      // await ref.putFile(File(image.path)).catchError((error, stackTrace){
      //   print('-----------------error $error');
      // });
      log('=================file uploaded');
      String downloadUrl = await ref.getDownloadURL();
      log('=================download url: $downloadUrl');
      return downloadUrl;
    } catch (e, stack) {
      print('Error loading status list: $e\n------------${stack}');
      return '';
    }
  }

  Future<int?> getFileSize(String filePath) async {
    try {
      File file = File(filePath);
      if (await file.exists()) {
        int size = await file.length();
        log("===============size $size");
        return size;
      } else {
        print('File does not exist');
        return null;
      }
    } catch (e) {
      print('Error getting file size: $e');
      return null;
    }
  }
}
