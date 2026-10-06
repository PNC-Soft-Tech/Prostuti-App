import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../common/widgets/otp_input_widget.dart';
import '../../../constant/app_color.dart';
import '../../../routes/app_pages.dart';
import '../controller/email_varification_controller.dart';

class EmailVarificationView extends GetView<EmailVarificationController> {
  const EmailVarificationView({super.key});

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light.copyWith(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          padding: EdgeInsets.zero,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const _BlueBanner(),
              SizedBox(height: 28.h),
              _Heading(controller: controller),
              SizedBox(height: 28.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.w),
                child: Obx(
                  () => OTPInputWidget(
                    length: 4,
                    fieldWidth: 64,
                    fieldHeight: 68,
                    spacing: 12,
                    autoFocus: true,
                    hasError: controller.otpError.value.isNotEmpty,
                    errorText: controller.otpError.value.isNotEmpty
                        ? controller.otpError.value
                        : null,
                    enableHapticFeedback: true,
                    onChanged: controller.onOTPChanged,
                    onCompleted: controller.onOTPCompleted,
                  ),
                ),
              ),
              SizedBox(height: 32.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                child: _VerifyButton(controller: controller),
              ),
              SizedBox(height: 20.h),
              _ResendRow(controller: controller),
              SizedBox(height: 24.h),
            ],
          ),
        ),
      ),
    );
  }
}

class _BlueBanner extends StatelessWidget {
  const _BlueBanner();

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final topPadding = MediaQuery.of(context).padding.top;
    final contentHeight = 150.h;

    return SizedBox(
      width: screenWidth,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: screenWidth,
            height: topPadding + contentHeight,
            color: AppColors.primary,
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: -1,
            child: SvgPicture.asset(
              'assets/blue-banner.svg',
              width: screenWidth,
              fit: BoxFit.fitWidth,
            ),
          ),
          Positioned(
            top: topPadding + 8.h,
            left: 12.w,
            child: Material(
              color: Colors.white.withValues(alpha: 0.18),
              shape: const CircleBorder(),
              child: InkWell(
                customBorder: const CircleBorder(),
                onTap: () => Get.back(),
                child: SizedBox(
                  width: 40.w,
                  height: 40.w,
                  child: Icon(
                    Icons.arrow_back_rounded,
                    color: Colors.white,
                    size: 20.sp,
                  ),
                ),
              ),
            ),
          ),
          Positioned.fill(
            top: topPadding,
            child: Padding(
              padding: EdgeInsets.only(bottom: 24.h),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 64.w,
                    height: 64.w,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.18),
                      borderRadius: BorderRadius.circular(18.r),
                    ),
                    alignment: Alignment.center,
                    child: Icon(
                      Icons.mark_email_read_outlined,
                      size: 30.sp,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 10.h),
                  Text(
                    'Check your email',
                    style: GoogleFonts.inter(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                      letterSpacing: -0.2,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Heading extends StatelessWidget {
  final EmailVarificationController controller;

  const _Heading({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Column(
        children: [
          Text(
            'Enter verification code',
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              fontSize: 22.sp,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimaryColor,
              letterSpacing: -0.4,
            ),
          ),
          SizedBox(height: 8.h),
          Text.rich(
            TextSpan(
              style: GoogleFonts.inter(
                fontSize: 14.sp,
                fontWeight: FontWeight.w400,
                color: AppColors.gray,
                height: 1.5,
              ),
              children: [
                const TextSpan(text: 'We sent a 4-digit code to '),
                TextSpan(
                  text: controller.email.value,
                  style: GoogleFonts.inter(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimaryColor,
                  ),
                ),
              ],
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 6.h),
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                // offNamed replaces the current screen, so the back-stack
                // doesn't have to contain register for this to work — robust
                // whether the user got here via deep link, restart, or normal
                // signup flow.
                Get.offNamed(Routes.register);
              },
              borderRadius: BorderRadius.circular(8.r),
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 6.h, horizontal: 12.w),
                child: Text(
                  'Wrong email? Edit',
                  style: GoogleFonts.inter(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _VerifyButton extends StatelessWidget {
  final EmailVarificationController controller;

  const _VerifyButton({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final enabled = controller.isSubmitEnable.value;
      return SizedBox(
        width: double.infinity,
        height: 54.h,
        child: ElevatedButton(
          onPressed: enabled ? controller.verifyOtpAndHandleResponse : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            disabledBackgroundColor:
                AppColors.primary.withValues(alpha: 0.45),
            foregroundColor: Colors.white,
            disabledForegroundColor: Colors.white,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14.r),
            ),
          ),
          child: Text(
            'Verify',
            style: GoogleFonts.inter(
              fontSize: 15.sp,
              fontWeight: FontWeight.w600,
              color: Colors.white,
              letterSpacing: 0.1,
            ),
          ),
        ),
      );
    });
  }
}

class _ResendRow extends StatelessWidget {
  final EmailVarificationController controller;

  const _ResendRow({required this.controller});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final canResend = controller.canResend.value;
      final isResending = controller.isResendingOTP.value;
      final secondsLeft = controller.resendTimer.value;

      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Didn't receive the code? ",
            style: GoogleFonts.inter(
              fontSize: 13.sp,
              fontWeight: FontWeight.w400,
              color: AppColors.gray,
            ),
          ),
          if (isResending)
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: 14.w,
                  height: 14.w,
                  child: const CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor:
                        AlwaysStoppedAnimation<Color>(AppColors.primary),
                  ),
                ),
                SizedBox(width: 6.w),
                Text(
                  'Sending…',
                  style: GoogleFonts.inter(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
                  ),
                ),
              ],
            )
          else if (canResend)
            GestureDetector(
              onTap: controller.resendOTP,
              behavior: HitTestBehavior.opaque,
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 4.h, horizontal: 4.w),
                child: Text(
                  'Resend',
                  style: GoogleFonts.inter(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
                  ),
                ),
              ),
            )
          else
            Text(
              'Resend in ${secondsLeft}s',
              style: GoogleFonts.inter(
                fontSize: 13.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.lightGray,
              ),
            ),
        ],
      );
    });
  }
}
