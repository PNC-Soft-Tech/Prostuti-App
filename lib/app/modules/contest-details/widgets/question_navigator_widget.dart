import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

class QuestionNavigator extends StatelessWidget {
  final int currentQuestion;
  final int totalQuestions;
  final VoidCallback onNext;
  final VoidCallback onPrevious;

  const QuestionNavigator({
    Key? key,
    required this.currentQuestion,
    required this.totalQuestions,
    required this.onNext,
    required this.onPrevious,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 50.w,
      height: 150.h,
      padding: EdgeInsets.symmetric(vertical: 8.h),
      decoration: BoxDecoration(
        color: Color(0xFFFF8143), // Matching your orange color
        borderRadius: BorderRadius.circular(25.r),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _navButton(Icons.keyboard_arrow_up, onPrevious),
          SizedBox(height: 8.h),
          Column(
            children: [
              Icon(Icons.flag, color: Colors.white, size: 18.sp),
              SizedBox(height: 4.h),
              Text(
                "$currentQuestion / $totalQuestions",
                style: GoogleFonts.inter(
                  fontSize: 14.sp,
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              )
            ],
          ),
          SizedBox(height: 8.h),
          _navButton(Icons.keyboard_arrow_down, onNext),
        ],
      ),
    );
  }

  Widget _navButton(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 36.w,
        height: 36.w,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: Colors.grey, size: 24.sp),
      ),
    );
  }
}
