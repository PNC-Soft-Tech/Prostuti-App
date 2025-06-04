import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';


class BottomFixedSubmitContestWidget extends StatelessWidget {
  final String timeLeft;
  final VoidCallback? onCompletePressed;
  final int currentQuestionIndex;
  final int totalQuestions;
  final bool isSubmitted;

  const BottomFixedSubmitContestWidget({
    super.key,
    required this.timeLeft,
    this.onCompletePressed,
    required this.currentQuestionIndex,
    required this.totalQuestions,
    this.isSubmitted = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16.r),
          topRight: Radius.circular(16.r),
        ),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
            spreadRadius: 2,
          )
        ],
      ),
      child: Column(
        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.min,
        children: [
              SizedBox(height: 15.h,),
          _buildTimerWidget(),
          SizedBox(height: 15.h,),
          // CountDownTimerWidget(),
          _buildCompleteButton(),
        ],
      ),
    );
  }

  Widget _buildTimerWidget() {
    // Default colors
    Color backgroundColor = Colors.blue.shade50;
    Color textColor = Colors.blue.shade800;
    Color iconColor = Colors.blue;
    
    // Only try to parse if it's a time format (MM:SS) and not a human-readable string
    if (!timeLeft.contains('in') && timeLeft.contains(':')) {
      try {
        final timeParts = timeLeft.split(':');
        if (timeParts.length == 2) {
          final minutes = int.tryParse(timeParts[0]) ?? 0;
          
          // Set colors based on remaining time
          if (minutes < 2) {
            backgroundColor = Colors.red.shade50;
            textColor = Colors.red.shade800;
            iconColor = Colors.red;
          } else if (minutes < 5) {
            backgroundColor = Colors.orange.shade50;
            textColor = Colors.orange.shade800;
            iconColor = Colors.orange;
          }
        }
      } catch (e) {
        // Fallback to default colors if parsing fails
      }
    }
    
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 12.w),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(50.r),
      ),
      child: Row(
        children: [
          Icon(Icons.access_time, color: iconColor, size: 20.sp),
          SizedBox(width: 6.w),
          Text(
            "Time Left: $timeLeft",
            style: GoogleFonts.inter(
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }
  Widget _buildCompleteButton() {
    return Container(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: isSubmitted ? null : onCompletePressed,
        style: ElevatedButton.styleFrom( 
          padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 24.w),
          shape: RoundedRectangleBorder( 
            borderRadius: BorderRadius.circular(50.r),
          ),
          backgroundColor: isSubmitted ? Colors.grey : Colors.blue,
          disabledBackgroundColor: Colors.grey.withOpacity(0.6),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (isSubmitted) ...[
              Icon(
                Icons.check_circle,
                color: Colors.white,
                size: 18.sp,
              ),
              SizedBox(width: 8.w),
            ],
            Text(
              isSubmitted ? 'Already Submitted' : 'Complete Exam',
              style: GoogleFonts.inter(
                fontSize: 15.sp,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
