import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../APIs/api_helper.dart';
import '../../../common/controller/app_controller.dart';
import '../../../common/utils/prostuti_utils.dart';
import '../../../common/widgets/breathing_animation/global_loading_manager.dart';
import '../../../routes/app_pages.dart';
import '../../../storage/storage_helper.dart';

class EmailVarificationController extends GetxController {
  final ApiHelper _apiHelper = Get.find<ApiHelper>();
  final AppController appController = Utils.getAppController();

  final code1 = TextEditingController();
  final code2 = TextEditingController();
  final code3 = TextEditingController();  final code4 = TextEditingController();
  late RxString email = ''.obs;
  RxBool isSubmitEnable = false.obs;
  RxBool isResendingOTP = false.obs;
  FocusNode code1FocusNode = FocusNode();
  FocusNode code2FocusNode = FocusNode();
  FocusNode code3FocusNode = FocusNode();
  FocusNode code4FocusNode = FocusNode();
  @override
  void onInit() {
    final Map<String, dynamic> args = Get.arguments;
    FocusScope.of(Get.context!).requestFocus(code1FocusNode);

    email.value = args['email'];
    isSubmitEnable.value = false;
    super.onInit();
  }

  void onCode1Change(String value) {
    if (int.tryParse(value) != null && int.parse(value) > 10) {
      code1.text = '';
    } else {
      FocusScope.of(Get.context!).requestFocus(code2FocusNode);
    }
    print("Code1 changed to: $value");
    isSubmitEnable.value = false;
  }

  void onCode2Change(String value) {
    if (int.tryParse(value) != null && int.parse(value) > 10) {
      code2.text = '';
    } else {
      FocusScope.of(Get.context!).requestFocus(code3FocusNode);
    }
    print("Code2 changed to: $value");
    isSubmitEnable.value = false;
  }

  void onCode3Change(String value) {
    if (int.tryParse(value) != null && int.parse(value) > 10) {
      code3.text = '';
    } else {
      FocusScope.of(Get.context!).requestFocus(code4FocusNode);
    }
    print("Code3 changed to: $value");
    isSubmitEnable.value = false;
  }

  void onCode4Change(String value) {
    if (int.tryParse(value) != null && int.parse(value) > 10) {
      code4.text = '';
    } else {
      // FocusScope.of(Get.context!).requestFocus(code2FocusNode);
      if (code1.text.isNotEmpty &&
          code2.text.isNotEmpty &&
          code3.text.isNotEmpty &&
          code4.text.isNotEmpty) isSubmitEnable.value = true;
    }
    print("Code4 changed to: $value");
  }
  Future<void> verifyOtpAndHandleResponse() async {
    var payload = {
      "otp": (int.tryParse(code1.text) ?? 0) * 1000 +
          (int.tryParse(code2.text) ?? 0) * 100 +
          (int.tryParse(code3.text) ?? 0) * 10 +
          (int.tryParse(code4.text) ?? 0),
      "email": email.value,
    };

    await GlobalLoadingManager.instance.showDuring(
      _apiHelper.verifyOtp(payload),
      message: 'Verifying OTP...',
    ).then((result) {
      result.fold(
        (error) {
          // Handle error scenario
          print('Error: ${error.message}');
          // Show an error message to the user
          Get.snackbar('Error', error.message,
              snackPosition: SnackPosition.BOTTOM);
        },
        (response) async {
          // Handle success scenario
          print('Success: ${response.body}');
          // Extract token from response
          final String? token = response.body['data']['token'];
          final Map<String, dynamic> userData = response.body['data']['user'];

          if (token != null) {
            await StorageHelper.setUserData(userData);
            await StorageHelper.setUserId(userData['_id']);

            // Save token using StorageHelper
            await StorageHelper.setToken(token);
            appController.decodeJWT(
                token); // saving the jwt payload ( id & userRole) into appcontroller variable
            print('Token saved successfully.');
            // Navigate to the next screen or perform an action
            Get.toNamed(Routes.home, arguments: response.body);
          }
        },
      );
    });
  }
    Future<void> resendOTP() async {
    // TODO: Implement resend OTP API endpoint
    // For now, just show a message that this feature is not available
    Get.snackbar(
      'Feature Unavailable', 
      'Resend OTP feature is not implemented yet',
      snackPosition: SnackPosition.BOTTOM,
    );
    
    /*
    var payload = {
      "email": email.value,
    };

    isResendingOTP.value = true;
    
    final result = await _apiHelper.resendOtp(payload);
    
    result.fold(
      (error) {
        // Handle error scenario
        print('Error: ${error.message}');
        Get.snackbar('Error', error.message,
            snackPosition: SnackPosition.BOTTOM);
        isResendingOTP.value = false;
      },
      (response) {
        // Handle success scenario
        print('Success: OTP resent');
        Get.snackbar('Success', 'OTP has been resent to your email',
            snackPosition: SnackPosition.BOTTOM);
        isResendingOTP.value = false;
        
        // Clear existing OTP fields
        code1.clear();
        code2.clear();
        code3.clear();
        code4.clear();
        isSubmitEnable.value = false;
        
        // Focus on first field
        FocusScope.of(Get.context!).requestFocus(code1FocusNode);
      },
    );
    */
  }
}
