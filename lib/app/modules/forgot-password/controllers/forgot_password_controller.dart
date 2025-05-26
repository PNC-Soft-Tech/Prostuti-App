import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../APIs/api_helper.dart';
import '../../../common/utils/prostuti_utils.dart';
import '../../../routes/app_pages.dart';

class ForgotPasswordController extends GetxController {
  final ApiHelper _apiHelper = Get.find<ApiHelper>();
  
  final emailController = TextEditingController();
  var isLoading = false.obs;

  Future<void> sendResetCode() async {
    final email = emailController.text.trim();
    
    if (email.isEmpty) {
      Utils.showSnackbar(
        message: 'Please enter your email address',
        isSuccess: false,
      );
      return;
    }
    
    if (!GetUtils.isEmail(email)) {
      Utils.showSnackbar(
        message: 'Please enter a valid email address',
        isSuccess: false,
      );
      return;
    }

    isLoading.value = true;

    final result = await _apiHelper.forgotPassword(email);

    result.fold(
      (error) {
        isLoading.value = false;
        Utils.showSnackbar(
          message: error.message,
          isSuccess: false,
        );
      },
      (response) {
        isLoading.value = false;
        Utils.showSnackbar(
          message: 'Password reset code has been sent to your email',
          isSuccess: true,
        );
        
        // Navigate to reset password screen with email
        Get.toNamed(Routes.resetPassword, arguments: {"email": email});
      },
    );
  }

  @override
  void onClose() {
    emailController.dispose();
    super.onClose();
  }
}
