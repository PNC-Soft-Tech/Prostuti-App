import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:prostuti/app/constant/app_color.dart';
import 'package:flutter_svg/flutter_svg.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          AppColors.primary, // Set the background color as per your design
      body: Padding(
        padding: EdgeInsets.all(20.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              'assets/onboarding/people-prep.svg',
              // assets\onboarding\people-prep.svg
              width: 200.w,
              height: 200.h,
            ),
            SizedBox(height: 20.h),

            // Heading Text
            Text(
              'Your Journey towards\nSuccess Starts Here',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24.sp, // Responsive font size
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 40.h),

            // Get Started Button
            ElevatedButton(
              onPressed: () {
                // Your button action, e.g., navigate to login
                Get.toNamed('/login'); // Replace with your login route
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue, // Button color
                padding: EdgeInsets.symmetric(horizontal: 50.w, vertical: 15.h),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25.r)),
              ),
              child: Text(
                'Get Started',
                style: TextStyle(
                  fontSize: 18.sp, // Responsive font size
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
