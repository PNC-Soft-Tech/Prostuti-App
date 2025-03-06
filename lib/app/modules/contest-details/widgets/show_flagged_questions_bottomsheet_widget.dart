import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controller/contest_details_controller.dart';

void showFlaggedQuestionsBottomSheet(List<String> flaggedQuestionIds) {
  final controller = Get.find<ContestDetailsController>();

  if (flaggedQuestionIds.isEmpty) {
    Get.snackbar('No Flagged Questions', 'You have not flagged any questions yet.');
    return;
  }

  Get.bottomSheet(
    Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Flagged Questions',
            style: GoogleFonts.inter(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 16.h),

          Wrap(
            spacing: 12.w,
            runSpacing: 12.h,
            children: flaggedQuestionIds.map((questionId) {
              final questionIndex = controller.questionIdToIndexMap[questionId];

              if (questionIndex == null) {
                return const SizedBox(); // Handle unexpected case (shouldn't happen if map is correctly initialized)
              }

              final questionNumber = questionIndex + 1; // 1-based numbering

              return GestureDetector(
                onTap: () {
                  Get.back(); // Close the bottom sheet
                  controller.scrollToQuestion(questionId); // Scroll using GlobalKey
                },
                child: Container(
                  padding: EdgeInsets.all(12.r),
                  decoration: BoxDecoration(
                    color: Colors.blueAccent,
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Text(
                    questionNumber.toString(),
                    style: GoogleFonts.inter(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),

          SizedBox(height: 16.h),
        ],
      ),
    ),
    isScrollControlled: true,
  );
}
