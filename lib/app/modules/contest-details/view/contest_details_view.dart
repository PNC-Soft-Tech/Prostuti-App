// lib/modules/contests/views/contest_details_view.dart

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../common/custom_simple_appbar.dart';
import '../../../common/utils/prostuti_utils.dart';
import '../../../common/widgets/shared_question_widget.dart';
import '../../../constant/app_color.dart';
import '../controller/contest_details_controller.dart';
import '../widgets/contest_action_widget.dart';
import '../widgets/question_navigator.dart';
import '../widgets/subject_tabs_widget.dart';

class ContestDetailsView extends GetView<ContestDetailsController> {
  const ContestDetailsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomSimpleAppBar.appBar(
        titleWidget: Text(
          Utils.stripHtmlTags(controller.contestDetails.value?.contest.name ?? '') ?? 'Contest Details',
          style: const TextStyle(fontSize: 18, color: AppColors.primary),
        ),
      ),
      body: Stack(
        children: [
          Obx(() {
            if (controller.isLoading.value) {
              return const Center(child: CupertinoActivityIndicator());
            }

            final questions = controller.filteredQuestions;
            if (questions.isEmpty) {
              return const Center(child: Text('No questions available'));
            }

            return Column(
              children: [
                // Subject Filter - Only display ONCE
                Obx(() => SubjectTabsWidget(
                  onSubjectSelected: (subject) {
                    controller.selectSubject(subject);
                  },
                  selectedSubject: controller.selectedSubject.value,
                  subjects: controller.subjectLists,
                  isQuestionOpened: controller.isQuestionOpened.value,
                )),

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
                          color: Colors.tealAccent,
                        ),
                      ),
                    ],
                  ),
                ),

                // Questions List
                Expanded(
                  child: ListView.builder(
                    controller: controller.scrollController,
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
                ),
              ],
            );
          }),
          
          // Action widget for contest submission
          Obx(() => controller.isQuestionOpened.value
            ? const ContestActionWidget()
            : const SizedBox.shrink()
          ),
          
          // Question navigator widget - only visible when questions are open
          Obx(() => controller.isQuestionOpened.value
            ? Positioned(
                right: 16.w,
                bottom: 100.h,
                child: QuestionNavigatorWidget(),
              )
            : const SizedBox.shrink()
          ),
        ],
      ),
    );
  }
}