// lib/modules/contests/views/contest_details_view.dart

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
import '../../contest-details/widgets/bottom_fixed_submit_contest_widget.dart';
import '../../contest-details/widgets/subject_tabs_widget.dart';
import '../controller/custom_exam_details_controller.dart';
import '../widgets/custom_exam_question_navigator.dart';

class CustomExamDetailsView extends GetView<CustomExamDetailsController> {
  const CustomExamDetailsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomSimpleAppBar.appBar(
        titleWidget: Obx(() => Text(
              Utils.stripHtmlTags(
                      controller.customExamDetails.value?.contest.name ?? '') ??
                  'Custom Exam Details',
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
                // Remove the conditional rendering of the details
                // if (!controller.isQuestionOpened.value)
                //   Container(
                //     padding:
                //         EdgeInsets.symmetric(vertical: 16.h, horizontal: 16.w),
                //     child: Column(
                //       crossAxisAlignment: CrossAxisAlignment.start,
                //       children: [
                //         Row(
                //           children: [
                //             controller.customExamDetails.value?.contest
                //                             .imageUrl !=
                //                         null &&
                //                     controller.customExamDetails.value!.contest
                //                         .imageUrl!
                //                         .contains('http')
                //                 ? Image.network(
                //                     controller.customExamDetails.value?.contest
                //                             .imageUrl ??
                //                         '',
                //                     height: 34.r,
                //                     width: 34.r,
                //                   )
                //                 : Image.asset(
                //                     'assets/govt-bd.png',
                //                     height: 34.r,
                //                     width: 34.r,
                //                   ),
                //             SizedBox(
                //               width: 12.w,
                //             ),
                //             Text(
                //               Utils.stripHtmlTags(controller
                //                       .customExamDetails.value?.contest.name ??
                //                   "বিসিএস কনটেস্ট-০১ custom exam"),
                //               style: GoogleFonts.notoSansBengali(
                //                   textStyle: TextStyle(
                //                 fontSize: 20.sp,
                //                 color: AppColors.textPrimaryColor,
                //                 fontWeight: FontWeight.w600,
                //               )),
                //             )
                //           ],
                //         ),
                //         SizedBox(
                //           height: 19.h,
                //         ),
                //         Text(
                //           Utils.stripHtmlTags(
                //               " ${controller.customExamDetails.value?.contest.stringTopics ?? 'গনিত - জ্যামিতি'}"),
                //           style: GoogleFonts.notoSansBengali(
                //               textStyle: TextStyle(
                //             fontSize: 16.sp,
                //             color: AppColors.textPrimaryColor,
                //             fontWeight: FontWeight.w500,
                //           )),
                //         ),
                //         SizedBox(
                //           height: 16.h,
                //         ),

                //         SizedBox(
                //           height: 21.h,
                //         ),
                //         Text(
                //           Utils.stripHtmlTags(controller.customExamDetails.value
                //                   ?.contest.description ??
                //               "বিসিএস কনটেস্ট-০১ desc"),
                //           style: GoogleFonts.notoSansBengali(
                //               textStyle: TextStyle(
                //             fontSize: 15.sp,
                //             color: AppColors.textPrimaryColor,
                //             fontWeight: FontWeight.w400,
                //           )),
                //         ),
                //         SizedBox(
                //           height: 27.h,
                //         ),
                //       ],
                //     ),
                //   ),

                // Subject Filter - Always display
                SubjectTabsWidget(
                  onSubjectSelected: (subject) {
                    controller.selectSubject(subject);
                  },
                  selectedSubject: controller.selectedSubject.value,
                  subjects: controller.subjectLists,
                  isQuestionOpened: true,
                ),

                // Status Bar - Question/Marking count - Always display
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

                // Questions List - Always display
                Expanded(
                  child: ListView.builder(
                    controller: controller.scrollController,
                    itemCount: questions.length,
                    itemBuilder: (context, index) {
                      final question = questions[index];
                      return SharedQuestionWidget(
                        key: controller.questionKeys[question.id],
                        question: question,
                        contestId: controller.customExamId.value,
                        controller: controller,
                        index: index,
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
          SizedBox(
            height: 187.h,
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: BottomFixedSubmitContestWidget(
              timeLeft: "00:00",
              onCompletePressed: () {
                // controller.onCompletePressed();
              },
              currentQuestionIndex: controller.currentQuestionIndex.value,
              totalQuestions: controller.filteredQuestions.length,
            ),
          ),

          // Question navigator widget - always visible
          Positioned(
            right: 16.w,
            bottom: 100.h,
            child: CustomExamQuestionNavigator(),
          ),
        ],
      ),
    );
  }
}
