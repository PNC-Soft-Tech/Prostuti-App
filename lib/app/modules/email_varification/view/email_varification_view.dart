import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:prostuti/app/common/custom_buttons.dart';
import 'package:prostuti/app/common/custom_styles.dart';
import 'package:prostuti/app/constant/app_color.dart';

import '../../../common/widgets/header_curve_logo_widget.dart';
import '../../../common/widgets/otp_input_widget.dart';
import '../controller/email_varification_controller.dart';

class EmailVarificationView extends GetView<EmailVarificationController> {
  const EmailVarificationView({super.key});  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 40, horizontal: 10.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const HeaderCurveLogoWidget(),
              const SizedBox(height: 20),
              Center(
                child: Text(
                  'Enter the 4 Digit Code we sent to',
                  style: CustomStyles.textStyle.copyWith(
                    fontSize: 18.sp, 
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              const SizedBox(height: 10),              Center(
                child: Text(
                  '${controller.email}',
                  style: CustomStyles.textStyle.copyWith(
                    color: AppColors.midnightBlue.withOpacity(0.7),
                  ),
                ),
              ),              SizedBox(height: 60.h),
                // OTP Input Widget
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: Obx(() => OTPInputWidget(
                  length: 4,
                  fieldWidth: 65,
                  fieldHeight: 65,
                  spacing: 16,
                  autoFocus: true,
                  hasError: controller.otpError.value.isNotEmpty,
                  errorText: controller.otpError.value.isNotEmpty 
                      ? controller.otpError.value 
                      : null,
                  enableHapticFeedback: true,
                  onChanged: controller.onOTPChanged,
                  onCompleted: controller.onOTPCompleted,
                )),              ),
              
              SizedBox(height: 40.h),SizedBox(height: 40.h),
              
              // Submit Button
              Obx(() => Container(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: CustomButton.button(
                  text: controller.isSubmitEnable.value 
                      ? "Verify OTP" 
                      : "Enter 4-digit OTP",
                  onPressed: controller.isSubmitEnable.value 
                      ? controller.verifyOtpAndHandleResponse
                      : () {}, // Empty callback for disabled state
                  backgroundColor: controller.isSubmitEnable.value 
                      ? null // Use default primary color
                      : Colors.grey[400], // Gray for disabled
                  textColor: Colors.white,
                ),
              )),
              
              SizedBox(height: 30.h),
              
              // Resend OTP Section
              Obx(() => Column(
                children: [
                  if (!controller.canResend.value)
                    Text(
                      'Resend OTP in ${controller.resendTimer.value}s',
                      style: CustomStyles.textStyle.copyWith(
                        fontSize: 16.sp,
                        color: AppColors.midnightBlue.withOpacity(0.6),
                      ),
                    ),
                  
                  SizedBox(height: 10.h),
                  
                  GestureDetector(
                    onTap: controller.canResend.value ? controller.resendOTP : null,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        vertical: 12.h,
                        horizontal: 24.w,
                      ),
                      decoration: BoxDecoration(
                        color: controller.canResend.value 
                            ? AppColors.primary.withOpacity(0.1)
                            : Colors.grey.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8.r),
                        border: Border.all(
                          color: controller.canResend.value 
                              ? AppColors.primary
                              : Colors.grey.withOpacity(0.5),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (controller.isResendingOTP.value)
                            SizedBox(
                              width: 16.w,
                              height: 16.h,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  AppColors.primary,
                                ),
                              ),
                            )
                          else
                            Icon(
                              Icons.refresh,
                              size: 18.sp,
                              color: controller.canResend.value 
                                  ? AppColors.primary
                                  : Colors.grey,
                            ),
                          SizedBox(width: 8.w),
                          Text(
                            controller.isResendingOTP.value 
                                ? 'Sending...'
                                : 'Resend OTP',
                            style: CustomStyles.textStyle.copyWith(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600,
                              color: controller.canResend.value 
                                  ? AppColors.primary
                                  : Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              )),
              
              SizedBox(height: 30.h),
            ],
          ),
        ),
      ),
    );
  }
}

class SocialButton extends StatelessWidget {
  final String icon;
  final VoidCallback onPressed;

  const SocialButton({
    super.key,
    required this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        padding: const EdgeInsets.all(16),
        backgroundColor: Colors.white,
        side: const BorderSide(color: AppColors.midnightBlue, width: 0.5),
      ),
      child: Image.asset(
        icon,
        width: 30.w,
        height: 30.h,
      ),
    );
  }
}
