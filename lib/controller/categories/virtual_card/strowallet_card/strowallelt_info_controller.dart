import 'package:intl/intl.dart';

import '../../../../../backend/services/api_services.dart';
import '../../../../backend/model/categories/virtual_card/strowallet_models/strowallet_card_model.dart';
import '../../../../backend/model/common/common_success_model.dart';
// import '../../../../backend/services/ strowallet_api_services.dart';
import '../../../../backend/services/strowallet_api_services.dart';
import '../../../../routes/routes.dart';
import '../../../../utils/basic_screen_imports.dart';
import '../../../../widgets/others/congratulation_widget.dart';
import '../../../navbar/dashboard_controller.dart';

class VirtualStrowalletCardController extends GetxController {
  final dashboardController = Get.put(DashBoardController());
  final fundAmountController = TextEditingController();

  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final houseNumberController = TextEditingController();
  final idNumberController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final dateOfBirthController = TextEditingController();
  final lineController = TextEditingController();
  final stateController = TextEditingController();
  final zipcodeController = TextEditingController();
  final cityController = TextEditingController();
  final countryController = TextEditingController();
  final idTypeController = TextEditingController();

  RxString strowalletCardId = "".obs;
  RxInt activeIndicatorIndex = 0.obs;

  RxDouble totalCharge = 0.00.obs;
  RxDouble totalPay = 0.00.obs;
  RxDouble percentCharge = 0.00.obs;
  // RxDouble amount = 0.00.obs;

  @override
  void onInit() {
    dashboardController.getDashboardData().then(
      (value) {
        if (dashboardController.dashBoardModel.data.activeVirtualSystem ==
            'strowallet') {
          getStrowalletCardData();
        }
      },
    );

    super.onInit();
  }

  changeIndicator(int value) {
    activeIndicatorIndex.value = value;
  }

  final _isLoading = false.obs;
  bool get isLoading => _isLoading.value;

  late StrowalletCardModel _strowalletCardModel;
  StrowalletCardModel get strowalletCardModel => _strowalletCardModel;

  Future<StrowalletCardModel> getStrowalletCardData() async {
    _isLoading.value = true;
    update();

    await StrowalletApiServices.strowalletCardInfoApi().then((value) {
      _strowalletCardModel = value!;

      if (_strowalletCardModel.data.myCards.isNotEmpty) {
        strowalletCardId.value = _strowalletCardModel.data.myCards.first.cardId;
      }
      _calculation();
      update();
    }).catchError((onError) {
      log.e(onError);
    });

    _isLoading.value = false;
    update();
    return _strowalletCardModel;
  }

  //>> with out loading
  Future<StrowalletCardModel> getStrowalletCardInfo() async {
    update();

    await StrowalletApiServices.strowalletCardInfoApi().then((value) {
      _strowalletCardModel = value!;

      if (_strowalletCardModel.data.myCards.isNotEmpty) {
        strowalletCardId.value = _strowalletCardModel.data.myCards.first.cardId;
      }
      _calculation();
      update();
    }).catchError((onError) {
      log.e(onError);
    });

    update();
    return _strowalletCardModel;
  }

  ///  >>>>>> Start buyCard process
  final _isBuyCardLoading = false.obs;
  bool get isBuyCardLoading => _isBuyCardLoading.value;
  late CommonSuccessModel _buyCardModel;
  CommonSuccessModel get buyCardModel => _buyCardModel;

  Future<CommonSuccessModel> buyCardProcess(context) async {
    _isBuyCardLoading.value = true;
    update();
    Map<String, dynamic> inputBody = {
      "card_amount": fundAmountController.text,
      "first_name": firstNameController.text,
      "last_name": lastNameController.text,
      "house_number": houseNumberController.text,
      "id_number": idNumberController.text,
      "customer_email": emailController.text,
      "phone": emailController.text,
      "date_of_birth": dateOfBirthController.text,
      "line1": lineController.text,
      "state": stateController.text,
      "zip_code": zipcodeController.text,
      "city": cityController.text,
    };
    await StrowalletApiServices.strowalletBuyCardApi(body: inputBody)
        .then((value) {
      _buyCardModel = value!;
      update();

      StatusScreen.show(
        context: context,
        subTitle: 'Strings.yourCardSuccess.tr',
        onPressed: () {
          Get.offAllNamed(Routes.bottomNavBarScreen);
        },
      );
      update();
    }).catchError((onError) {
      log.e(onError);
      update();
    });

    _isBuyCardLoading.value = false;
    update();
    return _buyCardModel;
  }

  void _calculation() {
    CardCharge data = _strowalletCardModel.data.cardCharge;
    double amount = 0.0;

    if (fundAmountController.text.isNotEmpty) {
      try {
        amount = double.parse(fundAmountController.text);
      } catch (e) {
        // print('Error parsing double: $e');
      }
    }

    percentCharge.value = ((amount / 100) * data.percentCharge);
    totalCharge.value =
        double.parse(data.fixedCharge.toString()) + percentCharge.value;
    totalPay.value = amount + totalCharge.value;
  }

  String getDay(String value) {
    DateTime startDate = DateTime.parse(value);
    var date = DateFormat('dd').format(startDate);
    return date.toString();
  }

  String getMonth(String value) {
    DateTime startDate = DateTime.parse(value);
    var date = DateFormat('MMMM').format(startDate);
    return date.toString();
  }

  // flutterwave make card default options
  final _isMakeDefaultLoading = false.obs;

  bool get isMakeDefaultLoading => _isMakeDefaultLoading.value;

  late CommonSuccessModel _cardDefaultModel;

  CommonSuccessModel get cardDefaultModel => _cardDefaultModel;

  // ------------------------------API Function---------------------------------
  //
  Future<CommonSuccessModel> makeCardDefaultProcess(String cardId) async {
    _isMakeDefaultLoading.value = true;
    Map<String, dynamic> inputBody = {'card_id': cardId};

    update();

    await StrowalletApiServices.strowalletCardMakeOrRemoveDefaultApi(
            body: inputBody)
        .then((value) {
      _cardDefaultModel = value!;
      getStrowalletCardData();
      update();
    }).catchError((onError) {
      log.e(onError);
    });

    _isMakeDefaultLoading.value = false;
    update();
    return _cardDefaultModel;
  }
}
