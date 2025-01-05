import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:prostuti/app/constant/app_color.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int? currentIndex;
   final ValueChanged<int> onTap; // Correct type for the callback
  const CustomBottomNavBar({super.key, this.currentIndex, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
        type: BottomNavigationBarType.fixed, // Ensures icons don't shift
        currentIndex:  currentIndex??0,
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
        elevation: 3.2,
        iconSize: 30.sp,
        selectedLabelStyle:  TextStyle(fontSize: 13.sp),
        unselectedLabelStyle:  TextStyle(fontSize: 13.sp),
      );
  }
}