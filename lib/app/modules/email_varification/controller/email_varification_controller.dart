import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

  // OTP Management
  RxString otpValue = ''.obs;
  late RxString email = ''.obs;
  RxBool isSubmitEnable = false.obs;
  RxBool isResendingOTP = false.obs;
  RxBool isOTPComplete = false.obs;
  RxString otpError = ''.obs;
  
  // Timer for resend functionality
  RxInt resendTimer = 0.obs;
  RxBool canResend = true.obs;
  Timer? _timer;

  // Global key for OTP widget to access its methods
  final GlobalKey<State<StatefulWidget>> otpWidgetKey = GlobalKey();

  @override
  void onInit() {
    final Map<String, dynamic> args = Get.arguments;
    email.value = args['email'];
    _startResendTimer();
    super.onInit();
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }

  // Handle OTP input changes
  void onOTPChanged(String otp) {
    otpValue.value = otp;
    otpError.value = ''; // Clear any previous errors
    isOTPComplete.value = otp.length == 4;
    isSubmitEnable.value = otp.length == 4;
    
    // Auto-submit when OTP is complete (optional)
    if (isOTPComplete.value) {
      // You can enable auto-submit here if desired
      // verifyOtpAndHandleResponse();
    }
  }

  // Handle OTP completion
  void onOTPCompleted(String otp) {
    otpValue.value = otp;
    isOTPComplete.value = true;
    isSubmitEnable.value = true;
    otpError.value = '';
    
    // Optional: Auto-submit when OTP is complete
    // verifyOtpAndHandleResponse();
  }

  // Validate OTP format
  bool _validateOTP() {
    if (otpValue.value.length != 4) {
      otpError.value = 'Please enter a 4-digit OTP';
      return false;
    }
    
    if (!RegExp(r'^[0-9]{4}$').hasMatch(otpValue.value)) {
      otpError.value = 'OTP must contain only numbers';
      return false;
    }
    
    return true;
  }

  // Start resend timer (60 seconds)
  void _startResendTimer() {
    canResend.value = false;
    resendTimer.value = 60;
    
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (resendTimer.value > 0) {
        resendTimer.value--;
      } else {
        canResend.value = true;
        timer.cancel();
      }
    });
  }

  // Clear OTP and reset state
  void clearOTP() {
    otpValue.value = '';
    isOTPComplete.value = false;
    isSubmitEnable.value = false;
    otpError.value = '';
  }

  // Verify OTP
  Future<void> verifyOtpAndHandleResponse() async {
    if (!_validateOTP()) {
      // Trigger shake animation for invalid OTP
      _triggerOTPShake();
      return;
    }

    var payload = {
      "otp": int.tryParse(otpValue.value) ?? 0,
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
          otpError.value = error.message;
          
          // Trigger shake animation for incorrect OTP
          _triggerOTPShake();
          
          // Show an error message to the user
          Get.snackbar(
            'Verification Failed', 
            error.message,
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red.withOpacity(0.8),
            colorText: Colors.white,
            duration: const Duration(seconds: 4),
          );
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
            
            // Show success message
            Get.snackbar(
              'Success!', 
              'Email verified successfully',
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: Colors.green.withOpacity(0.8),
              colorText: Colors.white,
              duration: const Duration(seconds: 3),
            );
          }
        },
      );
    });
  }

  // Helper method to trigger OTP shake animation
  void _triggerOTPShake() {
    // If we have access to the OTP widget, trigger shake animation
    // This could be expanded with actual shake animation implementation
    try {
      // For now, we'll use haptic feedback to indicate error
      HapticFeedback.vibrate();
    } catch (e) {
      // Silently handle any haptic feedback errors
    }
  }

  // Resend OTP
  Future<void> resendOTP() async {
    if (!canResend.value) {
      Get.snackbar(
        'Please Wait', 
        'You can resend OTP after ${resendTimer.value} seconds',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange.withOpacity(0.8),
        colorText: Colors.white,
      );
      return;
    }

    isResendingOTP.value = true;
    
    // Clear current OTP
    clearOTP();
    
    try {
      // TODO: Replace with actual resend OTP API when available
      await Future.delayed(const Duration(seconds: 2)); // Simulate API call
      
      // Restart timer
      _startResendTimer();
      
      Get.snackbar(
        'OTP Sent!', 
        'A new OTP has been sent to ${email.value}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green.withOpacity(0.8),
        colorText: Colors.white,
        duration: const Duration(seconds: 4),
      );
      
    } catch (e) {
      Get.snackbar(
        'Error', 
        'Failed to resend OTP. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.8),
        colorText: Colors.white,
      );
    } finally {
      isResendingOTP.value = false;
    }

    /*
    // TODO: Uncomment when resend OTP API is available
    var payload = {
      "email": email.value,
    };

    final result = await GlobalLoadingManager.instance.showDuring(
      _apiHelper.resendOtp(payload),
      message: 'Sending new OTP...',
    );
    
    result.fold(
      (error) {
        // Handle error scenario
        print('Error: ${error.message}');
        Get.snackbar('Error', error.message,
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red.withOpacity(0.8),
            colorText: Colors.white);
        isResendingOTP.value = false;
      },
      (response) {
        // Handle success scenario
        print('Success: OTP resent');
        Get.snackbar('Success', 'OTP has been resent to your email',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green.withOpacity(0.8),
            colorText: Colors.white);
        isResendingOTP.value = false;
        
        // Clear existing OTP and restart timer
        clearOTP();
        _startResendTimer();
      },
    );
    */
  }
}
