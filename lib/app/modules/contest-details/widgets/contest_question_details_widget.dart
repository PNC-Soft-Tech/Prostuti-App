import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../common/utils/prostuti_utils.dart';
import '../../../common/widgets/shared_question_widget.dart';
import '../../../constant/app_color.dart';
import '../controller/contest_details_controller.dart';
import 'contest_status_widget.dart';
import 'question_navigator.dart';
import 'subject_tabs_widget.dart';

class ContestQuestionDetailsWidget extends GetWidget<ContestDetailsController> {
  const ContestQuestionDetailsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final questions = controller.filteredQuestions;
      // Always show a visible fallback for debugging
      if (questions.isEmpty || questions == null) {
        return Container(
          color: Colors.white,
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.info_outline, color: Colors.grey, size: 48),
              SizedBox(height: 16),
              Text('No questions available', style: TextStyle(fontSize: 18, color: Colors.grey)),
            ],
          ),
        );
      }
      return Column(
        children: [
          // Subject Filter - Only display ONCE
          SubjectTabsWidget(
            onSubjectSelected: (subject) {
              controller.selectSubject(subject);
            },
            selectedSubject: controller.selectedSubject.value,
            subjects: controller.subjectLists,
            isQuestionOpened: controller.isQuestionOpened.value,
          ),
          // Status Bar - Question/Marking count
          Container(
            padding: EdgeInsets.all(8.w),
            color: Colors.white,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Questions: ${questions.length}',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  'Marked: ${controller.markedQuestionIds.length}',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
          // Questions List
          Expanded(
            child: Stack(
              children: [
                ListView.builder(
                  controller: controller.scrollController,
                  padding: EdgeInsets.only(bottom: 100.h),
                  itemCount: questions.length,
                  itemBuilder: (context, index) {
                    final question = questions[index];
                    return SharedQuestionWidget(
                      key: controller.questionKeys[question.id],
                      question: question,
                      contestId: controller.contestId.value,
                      controller: controller,
                      index: index,
                    );
                  },
                ),
                // Question navigator widget - only visible when questions are open
                Positioned(
                  right: 16.w,
                  bottom: 16.h,
                  child: const QuestionNavigatorWidget(),
                ),
              ],
            ),
          ),
        ],
      );
    });
  }
}
