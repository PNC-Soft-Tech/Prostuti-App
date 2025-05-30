import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:prostuti/app/common/custom_styles.dart';
import 'package:prostuti/app/constant/app_color.dart';
import '../../../common/widgets/header_curve_logo_widget.dart';
import '../controllers/forgot_password_controller.dart';

class ForgotPasswordView extends StatelessWidget {
  final ForgotPasswordController controller = Get.put(ForgotPasswordController());

  ForgotPasswordView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: 20.h),
              
              // Header
              const HeaderCurveLogoWidget(),
              SizedBox(height: 40.h),
              
              // Title
              Text(
                'Forgot Password?',
                style: CustomStyles.textStyle.copyWith(
                  fontSize: 28.sp,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 10.h),
              
              // Subtitle
              Text(
                'Don\'t worry! Enter your email address and we\'ll send you a code to reset your password.',
                style: CustomStyles.textStyle.copyWith(
                  fontSize: 16.sp,
                  color: AppColors.midnightBlue.withOpacity(0.7),
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 40.h),
              
              // Email Input
              TextField(
                controller: controller.emailController,
                decoration: CustomStyles.inputDecoration(
                  'Email Address', 
                  'Enter your email address'
                ).copyWith(
                  prefixIcon: const Padding(
                    padding: EdgeInsets.only(left: 12),
                    child: Icon(
                      Icons.email,
                      color: AppColors.blueGray,
                      size: 20,
                    ),
                  ),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              SizedBox(height: 30.h),
              
              // Send Code Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: controller.sendResetCode,
                  style: CustomStyles.buttonStyle,
                  child: Text(
                    "Send Reset Code",
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
                  onPressed: () => Get.back(),
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
    );
  }
}
