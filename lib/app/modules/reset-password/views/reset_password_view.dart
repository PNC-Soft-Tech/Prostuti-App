import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:prostuti/app/common/custom_styles.dart';
import 'package:prostuti/app/constant/app_color.dart';
import '../../../common/widgets/breathing_animation/custom_loader_widget.dart';
import '../../../common/widgets/header_curve_logo_widget.dart';
import '../controllers/reset_password_controller.dart';

class ResetPasswordView extends StatelessWidget {
  final ResetPasswordController controller = Get.put(ResetPasswordController());

  ResetPasswordView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      // appBar: AppBar(
      //   backgroundColor: Colors.transparent,
      //   elevation: 0,
      //   leading: IconButton(
      //     icon: const Icon(Icons.arrow_back, color: AppColors.primary),
      //     onPressed: () => Get.back(),
      //   ),
      // ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 20),
          child: Obx(
            () => controller.isLoading.value
                ? SizedBox(
                    height: MediaQuery.of(context).size.height - 200,
                    child: const Center(child: CustomLoaderWidget()),
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SizedBox(height: 20.h),
                      
                      // Header
                      const HeaderCurveLogoWidget(),
                      SizedBox(height: 40.h),
                      
                      // Title
                      Text(
                        'Reset Password',
                        style: CustomStyles.textStyle.copyWith(
                          fontSize: 28.sp,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 10.h),
                      
                      // Subtitle
                      Text(
                        'Enter the reset code sent to your email and create a new password.',
                        style: CustomStyles.textStyle.copyWith(
                          fontSize: 16.sp,
                          color: AppColors.midnightBlue.withOpacity(0.7),
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 40.h),
                      
                      // Reset Code Input
                      TextField(
                        controller: controller.codeController,
                        decoration: CustomStyles.inputDecoration(
                          'Reset Code', 
                          'Enter 6-digit code'
                        ).copyWith(
                          prefixIcon: const Padding(
                            padding: EdgeInsets.only(left: 12),
                            child: Icon(
                              Icons.security,
                              color: AppColors.blueGray,
                              size: 20,
                            ),
                          ),
                        ),
                        keyboardType: TextInputType.number,
                        maxLength: 6,
                      ),
                      SizedBox(height: 20.h),
                      
                      // New Password Input
                      Obx(() => TextField(
                        controller: controller.newPasswordController,
                        decoration: CustomStyles.inputDecoration(
                          'New Password', 
                          'Enter new password'
                        ).copyWith(
                          prefixIcon: const Padding(
                            padding: EdgeInsets.only(left: 12),
                            child: Icon(
                              Icons.lock,
                              color: AppColors.blueGray,
                              size: 20,
                            ),
                          ),
                          suffixIcon: IconButton(
                            icon: Padding(
                              padding: const EdgeInsets.only(right: 12),
                              child: Icon(
                                controller.isPasswordVisible.value
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color: AppColors.blueGray,
                              ),
                            ),
                            onPressed: controller.togglePasswordVisibility,
                          ),
                        ),
                        obscureText: !controller.isPasswordVisible.value,
                      )),
                      SizedBox(height: 20.h),
                      
                      // Confirm Password Input
                      Obx(() => TextField(
                        controller: controller.confirmPasswordController,
                        decoration: CustomStyles.inputDecoration(
                          'Confirm Password', 
                          'Confirm new password'
                        ).copyWith(
                          prefixIcon: const Padding(
                            padding: EdgeInsets.only(left: 12),
                            child: Icon(
                              Icons.lock_outline,
                              color: AppColors.blueGray,
                              size: 20,
                            ),
                          ),
                          suffixIcon: IconButton(
                            icon: Padding(
                              padding: const EdgeInsets.only(right: 12),
                              child: Icon(
                                controller.isConfirmPasswordVisible.value
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color: AppColors.blueGray,
                              ),
                            ),
                            onPressed: controller.toggleConfirmPasswordVisibility,
                          ),
                        ),
                        obscureText: !controller.isConfirmPasswordVisible.value,
                      )),
                      SizedBox(height: 30.h),
                      
                      // Reset Password Button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: controller.resetPassword,
                          style: CustomStyles.buttonStyle,
                          child: Text(
                            "Reset Password",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 30.h),
                      
                      // Back to Login
                      Center(
                        child: TextButton(
                          onPressed: () => Get.offAllNamed('/login'),
                          child: Text(
                            "Back to Login",
                            style: TextStyle(
                              fontSize: 16.sp,
                              color: AppColors.primary,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}
