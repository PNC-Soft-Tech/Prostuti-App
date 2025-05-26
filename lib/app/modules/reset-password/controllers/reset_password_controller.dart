import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../APIs/api_helper.dart';
import '../../../common/utils/prostuti_utils.dart';
import '../../../routes/app_pages.dart';

class ResetPasswordController extends GetxController {
  final ApiHelper _apiHelper = Get.find<ApiHelper>();
  
  final codeController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  
  var isLoading = false.obs;
  var isPasswordVisible = false.obs;
  var isConfirmPasswordVisible = false.obs;
  late String email;

  @override
  void onInit() {
    super.onInit();
    final Map<String, dynamic> args = Get.arguments ?? {};
    email = args['email'] ?? '';
  }

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  void toggleConfirmPasswordVisibility() {
    isConfirmPasswordVisible.value = !isConfirmPasswordVisible.value;
  }

  Future<void> resetPassword() async {
    final code = codeController.text.trim();
    final newPassword = newPasswordController.text.trim();
    final confirmPassword = confirmPasswordController.text.trim();
    
    if (code.isEmpty) {
      Utils.showSnackbar(
        message: 'Please enter the reset code',
        isSuccess: false,
      );
      return;
    }
    
    if (newPassword.isEmpty) {
      Utils.showSnackbar(
        message: 'Please enter a new password',
        isSuccess: false,
      );
      return;
    }
    
    if (newPassword.length < 6) {
      Utils.showSnackbar(
        message: 'Password must be at least 6 characters',
        isSuccess: false,
      );
      return;
    }
    
    if (newPassword != confirmPassword) {
      Utils.showSnackbar(
        message: 'Passwords do not match',
        isSuccess: false,
      );
      return;
    }

    isLoading.value = true;

    final result = await _apiHelper.resetPassword(
      email: email,
      code: code,
      newPassword: newPassword,
    );

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
          message: 'Password has been reset successfully!',
          isSuccess: true,
        );
        
        // Navigate back to login screen
        Get.offAllNamed(Routes.login);
      },
    );
  }

  @override
  void onClose() {
    codeController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }
}
