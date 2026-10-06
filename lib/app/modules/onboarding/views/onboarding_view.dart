import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:prostuti/app/common/custom_styles.dart';
import 'package:prostuti/app/constant/app_color.dart';
import 'package:flutter_svg/flutter_svg.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = ScreenUtil().screenWidth;
    double screenHeight = ScreenUtil().screenHeight;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.only(
          top: 40,
        ),
        // left: 10, right: 10
        child: SizedBox(
          width: screenWidth,
          height: screenHeight - 40.h,
          child: Stack(
            children: [
              Container(
                width: screenWidth,
                height: 600.h,
                decoration: const BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30)),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: screenWidth,
                      height: 600.h,
                      child: Stack(
                        children: [
                          Positioned(
                            top: 36.w,
                            left: 36.w,
                            child: Text(
                              'Your Journey towards\nSuccess Starts\nHere',
                              style: TextStyle(
                                fontSize: 30.sp,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 70.h,
                            left: 30.w,
                            child: SvgPicture.asset(
                              'assets/onboarding/people-prep.svg',
                              width: 300.w,
                              height: 300.h,
                            ),
                          ),
                          Positioned(
                            bottom: -1,
                            child: SvgPicture.asset(
                              'assets/onboarding/wave-white.svg',
                              width: screenWidth,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                bottom: 220.h,
                child: SizedBox(
                  width: screenWidth,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset(
                        'assets/main-logo.svg',
                        width: 50.w,
                        height: 50.h,
                      ),
                      SizedBox(width: 5.w),
                      Text(
                        'Prostuti',
                        style: TextStyle(
                          fontSize: 25.sp,
                          fontWeight: FontWeight.bold,
                          color: AppColors.blueGray,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                bottom: 70.h,
                child: SizedBox(
                  width: screenWidth,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: ElevatedButton(
                      onPressed: () {
                        Get.toNamed('/login');
                      },
                      style: CustomStyles.buttonStyle,
                      child: Text(
                        'Get Started',
                        style: TextStyle(
                          fontSize: 18.sp,
                          color: Colors.white,
                        ),
                      ),
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
