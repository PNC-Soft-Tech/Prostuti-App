import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.emoji_events),
            label: 'Ranking',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'History',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.more_horiz),
            label: 'More',
          ),
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
