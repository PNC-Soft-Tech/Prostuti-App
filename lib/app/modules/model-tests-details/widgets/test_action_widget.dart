// lib/modules/model_tests/widgets/test_action_widget.dart

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../constant/app_color.dart';
import '../controllers/model_test_details_controller.dart';

class TestActionWidget extends StatelessWidget {
  final ModelTestDetailsController controller;

  const TestActionWidget({
    Key? key,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final isExamMode = controller.currentSelectedModelTestMode.value == 'exam';
      
      return controller.isModelTestSubmittedLocal.value == false ? Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isExamMode) _buildTimerRow(),
            SizedBox(height: 8.h),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: isExamMode
                    ? _showSubmitDialog
                    : () => controller.toggleMode(false),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 14.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  backgroundColor:  AppColors.primary,
                      
                ),
                child: Text(
                  isExamMode ? 'Complete Exam' : 'View in Exam Mode',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16.sp,
                  ),
                ),
              ),
            ),
          ],
        ),
      ):SizedBox.shrink();
    });
  }

  Widget _buildTimerRow() {
    // Determine color based on time format
    Color backgroundColor = Colors.blue.shade50;
    Color textColor = Colors.blue.shade800;
    Color iconColor = Colors.blue;

    // Only try to parse countdown when in MM:SS format
    final timeLeft = controller.formattedCountdownTime;
    if (timeLeft.contains(':') && !timeLeft.contains('and')) {
      try {
        final timeParts = timeLeft.split(':');
        if (timeParts.length == 2) {
          final minutes = int.tryParse(timeParts[0]) ?? 0;
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
        // Fallback to default color if parsing fails
      }
    }

    return Container(
      padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 12.w),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Row(
        children: [
          Icon(Icons.timer, size: 20.sp, color: iconColor),
          SizedBox(width: 8.w),
          Text(
            'Time Left: ${controller.formattedCountdownTime}',
            style: TextStyle(
              color: textColor,
              fontWeight: FontWeight.w500,
              fontSize: 14.sp,
            ),
          ),
        ],
      ),
    );
  }

  void _showSubmitDialog() {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Container(
          padding: EdgeInsets.all(16.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.help_outline,
                size: 48.sp,
                color: Colors.blue,
              ),
              SizedBox(height: 16.h),
              Text(
                'Exam Completed?',
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                "Do you want to submit the answer script?\nOnce the action is done, it can't be undone'",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14.sp,
                  color: Colors.black54,
                ),
              ),
              SizedBox(height: 24.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButton(
                    onPressed: () => Get.back(),
                    child: const Text('Cancel'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Get.back();
                      // controller.submitContest(
                      //     controller.modelDetails.value?.contest.id ?? '');
                          controller.isModelTestSubmittedLocal.value=true;
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                    ),
                    child: const Text(
                      'Submit Now',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}