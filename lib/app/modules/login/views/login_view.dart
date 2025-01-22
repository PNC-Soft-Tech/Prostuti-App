import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:prostuti/app/common/custom_styles.dart';
import 'package:prostuti/app/constant/app_color.dart';
import '../../../common/widgets/breathing_animation/custom_loader_widget.dart';
import '../../../common/widgets/header_curve_logo_widget.dart';
import '../controllers/login_controller.dart';
import '../widgets/login_widget.dart';

class LoginView extends StatelessWidget {
  final LoginController controller = Get.put(LoginController());

  LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = ScreenUtil().screenWidth;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(
            top: 40,
          ),
          child: Obx(
            () => controller.isLoading.value
                ? const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Center(child: CustomLoaderWidget()),
                    ],
                  )
                : Column(
                    // mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // SizedBox(
                      //   width: screenWidth,
                      //   height: 120.h,
                      //   // height: screenHeight - 40.h,
                      //   child: Stack(
                      //     children: [
                      //       Container(
                      //           width: screenWidth,
                      //           height: 50.h,
                      //           decoration:  BoxDecoration(
                      //             color: AppColors.primary,
                      //             borderRadius: BorderRadius.only(
                      //                 topLeft: Radius.circular(30.r),
                      //                 topRight: Radius.circular(30.r)),
                      //           ),
                      //           child: null),
                      //       Positioned(
                      //         bottom: 0.h,
                      //         child: SvgPicture.asset(
                      //           'assets/blue-banner.svg',
                      //           width: screenWidth,
                      //         ),
                      //       ),
                      //       Positioned(
                      //         child: Center(
                      //           child: Row(
                      //             mainAxisAlignment: MainAxisAlignment.center,
                      //             children: [
                      //               SvgPicture.asset(
                      //                 'assets/main-logo.svg',
                      //                 width: 60.w,
                      //                 height: 60.h,
                      //                 colorFilter: const ColorFilter.mode(
                      //                     Colors.white, BlendMode.srcIn),
                      //               ),
                      //               SizedBox(width: 10.w),
                      //               Text(
                      //                 'Prostuti',
                      //                 style: TextStyle(
                      //                   fontSize: 32.sp,
                      //                   fontWeight: FontWeight.w500,
                      //                   color: Colors.white,
                      //                 ),
                      //               ),
                      //             ],
                      //           ),
                      //         ),
                      //       )
                      //     ],
                      //   ),
                      // ),
                      const HeaderCurveLogoWidget(),
                      const SizedBox(
                        height: 20,
                      ),
                      Center(
                        child: Text(
                          'Welcome Back',
                          style: CustomStyles.textStyle.copyWith(
                            fontSize: 24.sp,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Center(
                        child: Text(
                          'Prepare, Perform, Progress',
                          style: CustomStyles.textStyle.copyWith(
                              color: AppColors.midnightBlue.withOpacity(0.7)),
                        ),
                      ),
                      const SizedBox(
                        height: 40,
                      ),
                      LoginWidget(
                        emailController: controller.emailController,
                        passwordController: controller.passwordController,
                        onLoginPressed: controller.login,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Center(
                        child: Text(
                          'Or',
                          style: CustomStyles.textStyle.copyWith(
                              color: AppColors.midnightBlue.withOpacity(0.7)),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SocialButton(
                            icon: 'assets/icons/google.png',
                            onPressed: () {
                              // Handle Google login
                            },
                          ),
                          const SizedBox(width: 30),
                          SocialButton(
                            icon: 'assets/icons/facebook.png',
                            onPressed: () {
                              // Handle Facebook login
                            },
                          ),
                          const SizedBox(width: 30),
                          SocialButton(
                            icon: 'assets/icons/apple.png',
                            onPressed: () {
                              // Handle Apple login
                            },
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 50,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20.w),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Don't have an account? ",
                              style: TextStyle(
                                fontSize: 14.sp,
                                color: Colors.grey,
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                Get.toNamed('/register');
                              },
                              child: Text(
                                "Register Now",
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  color: Colors.blue,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
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
