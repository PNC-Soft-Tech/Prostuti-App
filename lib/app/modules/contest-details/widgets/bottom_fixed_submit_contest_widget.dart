import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';


class BottomFixedSubmitContestWidget extends StatelessWidget {
  final String timeLeft;
  final VoidCallback onCompletePressed;
  final int currentQuestionIndex;
  final int totalQuestions;

  const BottomFixedSubmitContestWidget({
    super.key,
    required this.timeLeft,
    required this.onCompletePressed,
    required this.currentQuestionIndex,
    required this.totalQuestions,
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
    // Extract time components to check if time is low
    final timeParts = timeLeft.split(':');
    final isTimeRunningLow = timeParts.length <= 2 && 
                            int.parse(timeParts[0]) < 5; // Less than 5 minutes
    final isTimeCritical = timeParts.length <= 2 && 
                           int.parse(timeParts[0]) < 2; // Less than 2 minutes
    
    // Change colors based on time remaining
    final backgroundColor = isTimeCritical 
                          ? Colors.red.shade50 
                          : (isTimeRunningLow 
                             ? Colors.orange.shade50 
                             : Colors.blue.shade50);
    
    final textColor = isTimeCritical 
                    ? Colors.red.shade800 
                    : (isTimeRunningLow 
                       ? Colors.orange.shade800 
                       : Colors.blue.shade800);
    
    final iconColor = isTimeCritical 
                    ? Colors.red 
                    : (isTimeRunningLow 
                       ? Colors.orange 
                       : Colors.blue);
      
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
      
        onPressed: onCompletePressed,
        style: ElevatedButton.styleFrom( 
          padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 24.w),
          shape: RoundedRectangleBorder( 
            borderRadius: BorderRadius.circular(50.r),
          ),
          backgroundColor: Colors.blue,
          
        ),
        child: Text(
          'Complete Exam',
          style: GoogleFonts.inter(
            fontSize: 15.sp,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
