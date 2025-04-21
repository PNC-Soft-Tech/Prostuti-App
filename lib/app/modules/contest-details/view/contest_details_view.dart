import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../common/custom_simple_appbar.dart';
import '../../../common/utils/prostuti_utils.dart';
import '../../../common/widgets/shared_question_widget.dart';
import '../../../constant/app_color.dart';
import '../controller/contest_details_controller.dart';
import '../widgets/contest_action_widget.dart';
import '../widgets/contest_details_widget.dart';
import '../widgets/contest_status_widget.dart';
import '../widgets/question_navigator.dart';
import '../widgets/subject_tabs_widget.dart';

class ContestDetailsView extends GetView<ContestDetailsController> {
  const ContestDetailsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:CustomSimpleAppBar.appBar( titleWidget:Obx(() => Text(
              Utils.stripHtmlTags(controller.contestDetails.value?.contest.name??'') ?? 'Contest',
              style: const TextStyle(fontSize: 18, color: AppColors.primary), 
            )), ),
      //  AppBar(
      //   title: Obx(() => Text(
      //         controller.contestDetails.value?.contest.name ?? 'Contest',
      //         style: const TextStyle(fontSize: 18),
      //       )),
      //   actions: [
      //     Center(
      //       child: Padding(
      //         padding: const EdgeInsets.all(8.0),
      //         child: Obx(() => Text(
      //               controller.formattedCountdownTime,
      //               style: const TextStyle(
      //                 fontSize: 16,
      //                 fontWeight: FontWeight.bold,
      //               ),
      //             )),
      //       ),
      //     ),
      //   ],
      // ),
      body: Stack(
        children: [
          // controller.submitContest(controller.contestId.value),
          Align(
              alignment: Alignment.topLeft,
              child: Container(
                  color: Colors.white,
                  child: Obx(() => SubjectTabsWidget(
                        onSubjectSelected: (subject) {
                          controller.selectSubject(subject); // update logic
                        },
                        selectedSubject: controller.selectedSubject.value,
                        subjects: controller.subjectLists,
                        isQuestionOpened: controller.isQuestionOpened.value,
                      )))),
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
                // Subject Filter
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  child: Row(
                    children: [
                      // FilterChip(
                      //   label: const Text('All'),
                      //   selected: controller.selectedSubject.value == 'All',
                      //   onSelected: (_) => controller.selectSubject('All'),
                      // ),
                      // const SizedBox(width: 8),
                      // ...controller.subjectLists.map((subject) => Padding(
                      //       padding: const EdgeInsets.only(right: 8),
                      //       child: FilterChip(
                      //         label: Text(subject),
                      //         selected: controller.selectedSubject.value == subject,
                      //         onSelected: (_) => controller.selectSubject(subject),
                      //       ),
                      //     )),
                    ],
                  ),
                ),

                // Question Navigation
                Padding(
                  padding: const EdgeInsets.all(8.0),
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
                        contestId: controller.contestId.value,
                        controller: controller, // Pass the controller instance
                        index: index,
                      );
                    },
                  ),
                ),
              ],
            );
          }),
          const ContestActionWidget(), // ✅ Handles submit/register buttons
          const QuestionNavigatorWidget(), // ✅ Handles floating question navigator
          Align(
              alignment: Alignment.topLeft,
              child: Container(
                  color: Colors.white,
                  child: Obx(() => SubjectTabsWidget(
                        onSubjectSelected: (subject) {
                          controller.selectSubject(subject); // update logic
                        },
                        selectedSubject: controller.selectedSubject.value,
                        subjects: controller.subjectLists,
                        isQuestionOpened: controller.isQuestionOpened.value,
                      )))),
          SizedBox(
            height: 15.h,
          ),
        ],
      ),
    );
  }
}
