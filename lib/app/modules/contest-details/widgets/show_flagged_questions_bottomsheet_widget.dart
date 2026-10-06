import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../controller/contest_details_controller.dart';
import 'question_navigator_floating_widget.dart';

void showFlaggedQuestionsBottomSheet(RxList<String> flaggedIds) {
  final controller = Get.find<ContestDetailsController>();
  
  if (flaggedIds.isEmpty) {
    Get.snackbar('No Marked Questions', 'No questions have been flagged yet.');
    return;
  }

  Get.bottomSheet(
    Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Flagged Questions',
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 16.h),
          Obx(() => Wrap(
                spacing: 12.w,
                runSpacing: 12.h,
                children: flaggedIds.map((id) {
                  final index = controller.questionIdToIndexMap[id] ?? 0;
                  return GestureDetector(
                    onTap: () {
                      Get.back();
                      // Use the new navigation method that ensures scrolling
                      QuestionNavigatorFloating.ensureScrollToQuestion(id);
                    },
                    child: Container(
                      width: 50.w,
                      height: 50.w,
                      decoration: BoxDecoration(
                        color: const Color(0xFFFF8143),
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                      child: Center(
                        child: Text(
                          '${index + 1}',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16.sp,
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              )),
        ],
      ),
    ),
    isScrollControlled: true,
  );
}
