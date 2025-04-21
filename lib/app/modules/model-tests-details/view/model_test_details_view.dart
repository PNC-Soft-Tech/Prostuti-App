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
      appBar: CustomSimpleAppBar.appBar(
        titleWidget: Obx(() => Text(
              Utils.stripHtmlTags(
                      controller.modelDetails.value?.contest.name ?? '') ??
                  'Model Test',
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
                      // isQuestionOpened: controller.currentSelectedModelTestMode.value ==
                      //     'exam',
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
                      );
                    },
                  ),
                ),
              ],
            );
          }),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: TestActionWidget(controller: controller),
          ),
          Positioned(
            bottom: 100.h,
            right: 16.w,
            child: Obx(() =>
                controller.currentSelectedModelTestMode.value == 'exam' ||
                        controller.isQuestionOpened.value
                    ? QuestionNavigatorWidget(controller: controller)
                    : const SizedBox.shrink()),
          ),
        ],
      ),
    );
  }
}
