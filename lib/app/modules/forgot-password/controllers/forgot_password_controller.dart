import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../APIs/api_helper.dart';
import '../../../common/utils/prostuti_utils.dart';
import '../../../routes/app_pages.dart';
import '../../../common/widgets/breathing_animation/global_loading_manager.dart';

class ForgotPasswordController extends GetxController {
  final ApiHelper _apiHelper = Get.find<ApiHelper>();
  
  final emailController = TextEditingController();
  // Removed: var isLoading = false.obs; - Now using GlobalLoadingManager
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
    }    GlobalLoadingManager.instance.show(message: "Sending reset code...");
    
    try {
      final result = await _apiHelper.forgotPassword(email);

      result.fold(
        (error) {
          GlobalLoadingManager.instance.hide();
          Utils.showSnackbar(
            message: error.message,
            isSuccess: false,
          );
        },
        (response) {
          GlobalLoadingManager.instance.hide();
          Utils.showSnackbar(
            message: 'Password reset code has been sent to your email',
            isSuccess: true,
          );
          
          // Show navigation loading
          GlobalLoadingManager.instance.showForNavigation(message: 'Redirecting to reset password...');
          
          // Navigate to reset password screen with email
          Get.toNamed(Routes.resetPassword, arguments: {"email": email});
        },
      );
    } catch (e) {
      GlobalLoadingManager.instance.hide();
      Utils.showSnackbar(
        message: 'An error occurred. Please try again.',
        isSuccess: false,
      );
    }
  }

  @override
  void onClose() {
    emailController.dispose();
    super.onClose();
  }
}
