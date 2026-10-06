import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:prostuti/app/constant/app_color.dart';

import '../../../common/services/auth_service.dart';
import '../../../routes/app_pages.dart';
import '../../../storage/storage_helper.dart';

class SplashView extends GetView {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration.zero, () async {
      // await StorageHelper.removeToken();
      final isLogged = await StorageHelper.hasToken();
      if (isLogged) {
        // Rehydrate AppController from persisted storage BEFORE routing to
        // home. Without this, screens that read `appController.userId` find
        // an empty value on cold start and AuthService bounces the user to
        // login despite a valid session.
        await Get.find<AuthService>().updateAuthenticationState();
        Get.offAllNamed(Routes.home);
      } else {
        Get.offAllNamed(Routes.login);
      }
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
