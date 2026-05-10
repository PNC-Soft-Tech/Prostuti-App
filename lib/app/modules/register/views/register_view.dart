import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:prostuti/app/common/utils/prostuti_utils.dart';
import 'package:prostuti/app/constant/app_color.dart';

import '../../../routes/app_pages.dart';
import '../controllers/register_controller.dart';
import '../widgets/register_form.dart';

class RegisterView extends StatelessWidget {
  RegisterView({super.key}) {
    Get.put(RegisterController());
  }

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
            SizedBox(height: 24.h),
            _Heading(),
            SizedBox(height: 22.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: const RegisterForm(),
            ),
            SizedBox(height: 14.h),
            const _TermsNote(),
            SizedBox(height: 24.h),
            const _OrDivider(),
            SizedBox(height: 20.h),
            const _SocialRow(),
            SizedBox(height: 18.h),
            const _LoginRow(),
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
    // Total banner height = status bar inset + content area + curve overlay.
    final contentHeight = 150.h;

    return SizedBox(
      width: screenWidth,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Solid blue background (extends behind status bar)
          Container(
            width: screenWidth,
            height: topPadding + contentHeight,
            color: AppColors.primary,
          ),
          // Curved white wave at the bottom of the banner
          Positioned(
            left: 0,
            right: 0,
            bottom: -1, // overlap by 1px to avoid hairline gap
            child: SvgPicture.asset(
              'assets/blue-banner.svg',
              width: screenWidth,
              fit: BoxFit.fitWidth,
            ),
          ),
          // Back button (top-left)
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
          // Logo + wordmark (centered)
          Positioned.fill(
            top: topPadding,
            child: Padding(
              padding: EdgeInsets.only(bottom: 24.h),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    'assets/main-logo.svg',
                    width: 56.w,
                    height: 56.w,
                    colorFilter: const ColorFilter.mode(
                      Colors.white,
                      BlendMode.srcIn,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    'Prostuti',
                    style: GoogleFonts.inter(
                      fontSize: 26.sp,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                      letterSpacing: -0.4,
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
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'Create your account',
            style: GoogleFonts.inter(
              fontSize: 22.sp,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimaryColor,
              letterSpacing: -0.4,
            ),
          ),
          SizedBox(height: 6.h),
          Text(
            'Prepare, perform, progress.',
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              fontSize: 13.sp,
              fontWeight: FontWeight.w400,
              color: AppColors.gray,
            ),
          ),
        ],
      ),
    );
  }
}

class _TermsNote extends StatelessWidget {
  const _TermsNote();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 28.w),
      child: Text.rich(
        TextSpan(
          style: GoogleFonts.inter(
            fontSize: 12.sp,
            color: AppColors.gray,
            height: 1.45,
          ),
          children: [
            const TextSpan(
              text: 'By creating an account you agree to our ',
            ),
            TextSpan(
              text: 'Terms',
              style: GoogleFonts.inter(
                fontSize: 12.sp,
                color: AppColors.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
            const TextSpan(text: ' and '),
            TextSpan(
              text: 'Privacy Policy',
              style: GoogleFonts.inter(
                fontSize: 12.sp,
                color: AppColors.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
            const TextSpan(text: '.'),
          ],
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}

class _OrDivider extends StatelessWidget {
  const _OrDivider();

  @override
  Widget build(BuildContext context) {
    final lineColor = AppColors.lightGray.withValues(alpha: 0.5);
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Row(
        children: [
          Expanded(child: Divider(color: lineColor, thickness: 1)),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.w),
            child: Text(
              'or continue with',
              style: GoogleFonts.inter(
                fontSize: 12.sp,
                color: AppColors.gray,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(child: Divider(color: lineColor, thickness: 1)),
        ],
      ),
    );
  }
}

class _SocialRow extends StatelessWidget {
  const _SocialRow();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SocialButton(
          icon: 'assets/icons/google.png',
          onPressed: () => _showSocialComingSoon('Google'),
        ),
        SizedBox(width: 16.w),
        SocialButton(
          icon: 'assets/icons/facebook.png',
          onPressed: () => _showSocialComingSoon('Facebook'),
        ),
        SizedBox(width: 16.w),
        SocialButton(
          icon: 'assets/icons/apple.png',
          onPressed: () => _showSocialComingSoon('Apple'),
        ),
      ],
    );
  }

  void _showSocialComingSoon(String provider) {
    Utils.showSnackbar(
      title: 'Coming soon',
      message: '$provider sign-in is on the way.',
      isSuccess: true,
    );
  }
}

class _LoginRow extends StatelessWidget {
  const _LoginRow();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Already have an account? ",
          style: GoogleFonts.inter(
            fontSize: 14.sp,
            color: AppColors.gray,
          ),
        ),
        GestureDetector(
          onTap: () => Get.toNamed(Routes.login),
          behavior: HitTestBehavior.opaque,
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 4.h, horizontal: 4.w),
            child: Text(
              'Log in',
              style: GoogleFonts.inter(
                fontSize: 14.sp,
                color: AppColors.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ],
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
    return Material(
      color: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14.r),
        side: BorderSide(
          color: AppColors.lightGray.withValues(alpha: 0.5),
          width: 1,
        ),
      ),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(14.r),
        child: Container(
          width: 64.w,
          height: 52.h,
          alignment: Alignment.center,
          child: Image.asset(
            icon,
            width: 24.w,
            height: 24.w,
          ),
        ),
      ),
    );
  }
}
