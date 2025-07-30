// lib/modules/model_tests/views/model_test_details_view.dart

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../common/custom_simple_appbar.dart';
import '../../../common/utils/prostuti_utils.dart';
import '../../../common/widgets/shared_question_widget.dart';
import '../../../constant/app_color.dart';
import '../../contest-details/widgets/subject_tabs_widget.dart';
import '../controllers/model_test_details_controller.dart';
import '../widgets/question_navigator_widget.dart';
import '../widgets/test_action_widget.dart';

class ModelTestDetailsView extends GetView<ModelTestDetailsController> {
  const ModelTestDetailsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomSimpleAppBar.appBar(        titleWidget: Obx(() => Text(
              Utils.stripHtmlTags(
                      controller.modelDetails.value?.contest.name ?? 'Model Test'),
              style: const TextStyle(fontSize: 18, color: AppColors.primary),
            )),
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
          
                // Subject Tabs
                Obx(() => SubjectTabsWidget(
                      subjects: controller.subjectLists,
                      selectedSubject: controller.selectedSubject.value,
                      onSubjectSelected: controller.selectSubject,
                      isQuestionOpened: true,
                    )),

                // Status Bar
                Container(
                  padding: const EdgeInsets.all(8.0),
                  color: Colors.white,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Questions: ${questions.length}'),
                      Text('Marked: ${controller.markedQuestionIds.length}'),
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
                        contestId:
                            controller.modelDetails.value?.contest.id ?? '',
                        index: index,
                        controller: controller,
                        showExplanation:
                            controller.currentSelectedModelTestMode.value ==
                                    'exam'
                                ? false
                                : true, 
                                showCorrectAns: controller.isModelTestSubmitted.value
                      );
                    },
                  ),
                ),
                SizedBox(
                  height: 120.h,
                ),
              ],
            );
          }),
          
          // Bottom action widget - only show when test is not submitted
          Obx(() {
            return controller.isModelTestSubmittedLocal.value == false
                ? Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: TestActionWidget(controller: controller),
                  )
                : const SizedBox.shrink(); // Completely remove when submitted
          }),
            // Question navigator - ALWAYS show it when we have questions
          Obx(() {
            // Dynamic bottom position based on whether action widget is shown
            final bottomPosition = controller.isModelTestSubmittedLocal.value == false 
                ? 100.h  // Above the action widget
                : 16.h;  // Near bottom when no action widget
                
            return Positioned(
              bottom: bottomPosition,
              right: 16.w,
              child: Obx(() {
                // The navigator should be visible when:
                // 1. Controller is initialized and not loading
                // 2. Model details are loaded
                // 3. Questions are available
                if (controller.isLoading.value || 
                    controller.modelDetails.value == null) {
                  return const SizedBox.shrink();
                }
                
                final hasQuestions = controller.filteredQuestions.isNotEmpty;
                
                return hasQuestions 
                  ? const QuestionNavigatorWidget()
                  : const SizedBox.shrink();
              }),
            );
          }),
        ],
      ),
    );
  }
}
