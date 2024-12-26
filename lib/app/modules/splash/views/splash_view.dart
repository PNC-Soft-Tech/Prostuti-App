import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:prostuti/app/constant/app_color.dart';

class SplashView extends StatelessWidget {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    // Start the timer to navigate after 3 seconds
    Future.delayed(const Duration(seconds: 3), () {
      Get.offAllNamed('/onboarding');
    });

    double screenWidth = ScreenUtil().screenWidth;
    double screenHeight = ScreenUtil().screenHeight;

    return Scaffold(
      backgroundColor: Colors.white, // Set the background color to white
      body: Center(
        child: Padding(
          padding: const EdgeInsets.only(top: 40, bottom: 10),
          child: Container(
            width: screenWidth - 20.w,
            height: screenHeight - 20.h,
            decoration: BoxDecoration(
              color: AppColors.secondary, // White background
              borderRadius: BorderRadius.circular(30.r), // Rounded corners
            ),
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    'assets/main-logo.svg',
                    width: 80.w,
                    height: 80.h,
                  ),
                  SizedBox(width: 10.w),
                  Text(
                    'Prostuti',
                    style: TextStyle(
                      fontSize: 40.sp,
                      fontWeight: FontWeight.bold,
                      color: AppColors.blueGray,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
