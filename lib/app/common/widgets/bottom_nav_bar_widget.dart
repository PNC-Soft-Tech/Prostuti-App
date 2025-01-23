import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:prostuti/app/common/custom_buttons.dart';
import 'package:prostuti/app/constant/app_color.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int? currentIndex;
  final ValueChanged<int> onTap; // Correct type for the callback
  const CustomBottomNavBar({super.key, this.currentIndex, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10.h),
      decoration: navDecoration(),
      child: BottomNavigationBar(
        backgroundColor:
            Colors.transparent, // Set the background to transparent
        type: BottomNavigationBarType.fixed, // Ensures icons don't shift
        currentIndex: currentIndex ?? 0,
        onTap: onTap,
        items: [
          _buildNavItem('Home', 'assets/navigation/home.svg', 0),
          _buildNavItem('Search', 'assets/navigation/search.svg', 1),
          _buildNavItem('Ranking', 'assets/navigation/rank.svg', 2),
          _buildNavItem('History', 'assets/navigation/history.svg', 3),
          _buildNavItem('More', 'assets/navigation/more.svg', 4),
        ],
        selectedItemColor: AppColors.primary,
        unselectedItemColor: Colors.grey,
        elevation: 0, // Remove internal shadow of the bottom navigation
        iconSize: 30.sp,
        selectedLabelStyle: TextStyle(fontSize: 13.sp),
        unselectedLabelStyle: TextStyle(fontSize: 13.sp),
      ),
    );
  }

  BottomNavigationBarItem _buildNavItem(
      String label, String iconPath, int index) {
    return BottomNavigationBarItem(
      icon: Padding(
        padding: EdgeInsets.only(bottom: 5.w),
        child: Stack(
          clipBehavior: Clip.none, // Allow indicator to overflow if necessary
          children: [
            SvgPicture.asset(
              iconPath,
              width: 20.w,
              colorFilter: currentIndex == index
                  ? const ColorFilter.mode(
                      AppColors.primary,
                      BlendMode.srcIn,
                    )
                  : null,
            ),
            if (currentIndex == index)
              Positioned(
                top: -15,
                left: 2.5,
                child: Container(
                  height: 5.w,
                  width: 15.w,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
          ],
        ),
      ),
      label: label,
    );
  }
}

class CustomBottomNavButton extends StatelessWidget {
  final String buttonText;
  final VoidCallback onPressed;
  const CustomBottomNavButton(
      {super.key, required this.buttonText, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 20.w),
      decoration: navDecoration(),
      child: CustomButton.button(
          mainAxisSize: MainAxisSize.max,
          text: buttonText,
          onPressed: onPressed,
          fontSize: 14),
    );
  }
}

BoxDecoration navDecoration() {
  return BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.only(
      topLeft: Radius.circular(30.r), // Rounded top-left corner
      topRight: Radius.circular(30.r), // Rounded top-right corner
    ),
    boxShadow: [
      BoxShadow(
        color: Colors.grey.withOpacity(0.2),
        spreadRadius: 0,
        blurRadius: 8,
        offset: const Offset(0, -2), // Shadow position
      ),
    ],
  );
}
