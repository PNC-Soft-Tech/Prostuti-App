import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:prostuti/app/constant/app_color.dart';

import '../../../routes/app_pages.dart';
import '../../../storage/storage_helper.dart';
import '../../../common/services/auth_service.dart';
import '../../../common/controller/app_controller.dart';
import '../../../common/utils/prostuti_utils.dart';

class SplashView extends GetView {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration.zero, () async {
      await _handleAuthenticationCheck();
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
        ),      ),
    );
  }

  /// Handle authentication check and app state restoration
  Future<void> _handleAuthenticationCheck() async {
    try {
      // Get required services
      final AuthService authService = Get.find<AuthService>();
      final AppController appController = Utils.getAppController();
      
      print("SplashView: Starting authentication check...");
      
      // Check if user has valid authentication
      final isAuthenticated = await authService.isAuthenticated();
      
      if (isAuthenticated) {
        print("SplashView: User is authenticated, restoring state");
        
        // Restore authentication state in AppController
        await authService.updateAuthenticationState();
        
        // Navigate to home
        Get.offAllNamed(Routes.home);
      } else {
        print("SplashView: User not authenticated, redirecting to login");
        
        // Clear any invalid state
        await authService.clearAuthenticationState();
        
        // Navigate to login
        Get.offAllNamed(Routes.login);
      }
    } catch (e) {
      print("SplashView: Error during authentication check: $e");
      
      // On error, redirect to login for safety
      Get.offAllNamed(Routes.login);
    }
  }
}
