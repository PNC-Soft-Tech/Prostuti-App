// lib/modules/contests/views/contest_details_view.dart

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
  const ContestDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomSimpleAppBar.appBar(
        titleWidget: Obx(() => Text(
              Utils.stripHtmlTags(
                     controller.isQuestionOpened.value? (controller.contestDetails.value?.contest.name ?? ''):"Contest Details") 
                  ,
              style: const TextStyle(fontSize: 18, color: AppColors.primary),
            )),      ),
      body: Column(
        children: [
          Obx(() {
            if (controller.isLoading.value) {
              return const Expanded(child: Center(child: CupertinoActivityIndicator()));
            }

            final questions = controller.filteredQuestions;
            if (questions.isEmpty) {
              return const Expanded(child: Center(child: Text('No questions available')));
            }

            return Expanded(
              child: Column(
                children: [
                  // if (!controller.isQuestionOpened.value)
                  if (!controller.isQuestionOpened.value)
                    Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 16.h, horizontal: 16.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              controller.contestDetails.value?.contest.imageUrl !=
                                          null &&
                                      controller
                                          .contestDetails.value!.contest.imageUrl!
                                          .contains('http')
                                  ? Image.network(
                                      controller.contestDetails.value?.contest
                                              .imageUrl ??
                                          '',
                                      height: 34.r,
                                      width: 34.r,
                                    )
                                  : Image.asset(
                                      'assets/govt-bd.png',
                                      height: 34.r,
                                      width: 34.r,
                                    ),
                              SizedBox(
                                width: 12.w,
                              ),
                              // Text("Mode: ${controller.currentQuestionIndex}"),
                              // HtmlWidget(
                              //     controller.contestDetails.value?.contest.name ??
                              //         "Model Test -০১")
                              Flexible(
                                child: Text(
                                  Utils.stripHtmlTags(controller
                                          .contestDetails.value?.contest.name ??
                                      "বিসিএস কনটেস্ট-০১"),
                                  style: GoogleFonts.notoSansBengali(
                                      textStyle: TextStyle(
                                    fontSize: 20.sp,
                                    color: AppColors.textPrimaryColor,
                                    fontWeight: FontWeight.w600,
                                  )),
                                ),
                              )
                            ],
                          ),
                          SizedBox(
                            height: 19.h,
                          ),
                          Text(
                            Utils.stripHtmlTags(
                                " ${controller.contestDetails.value?.contest.stringTopics ?? 'গনিত - জ্যামিতি'}"),
                            style: GoogleFonts.notoSansBengali(
                                textStyle: TextStyle(
                              fontSize: 16.sp,
                              color: AppColors.textPrimaryColor,
                              fontWeight: FontWeight.w500,
                            )),
                          ),
                          SizedBox(
                            height: 16.h,
                          ),

                          const ContestStatusWidget(), // ✅ Displays running or countdown UI
                          SizedBox(
                            height: 21.h,
                          ),
                          Text(
                            Utils.stripHtmlTags(controller
                                    .contestDetails.value?.contest.description ??
                                "বিসিএস কনটেস্ট-০১ desc"),
                            style: GoogleFonts.notoSansBengali(
                                textStyle: TextStyle(
                              fontSize: 15.sp,
                              color: AppColors.textPrimaryColor,
                              fontWeight: FontWeight.w400,
                            )),
                          ),
                          SizedBox(
                            height: 27.h,
                          ),
                          const ContestDetailsWidget(),
                        ],
                      ),
                    ),

                  // Subject Filter - Only display ONCE

                  Obx(() => (controller.isQuestionOpened.value)
                      ? SubjectTabsWidget(
                          onSubjectSelected: (subject) {
                            controller.selectSubject(subject);
                          },
                          selectedSubject: controller.selectedSubject.value,
                          subjects: controller.subjectLists,
                          isQuestionOpened: controller.isQuestionOpened.value,
                        )
                      : const SizedBox.shrink()),

                  // Status Bar - Question/Marking count
                  if (controller.isQuestionOpened.value)
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
                        ],                      ),
                    ),   
                  //  Text(controller.contestDetails.value?.contest.isSubmitted.toString()??'False'),
                  // Message for submitted contest
                  if (controller.contestDetails.value?.contest.isSubmitted == true && 
                      !controller.isQuestionOpened.value)
                    Container(
                      padding: EdgeInsets.all(16.w),
                      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8.r),
                        border: Border.all(color: AppColors.primary.withOpacity(0.3)),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.check_circle,
                            color: AppColors.primary,
                            size: 24.r,
                          ),
                          SizedBox(width: 12.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Contest Submitted Successfully!',
                                  style: GoogleFonts.notoSansBengali(
                                    textStyle: TextStyle(
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.primary,
                                    ),
                                  ),
                                ),
                                SizedBox(height: 4.h),
                                Text(
                                  'You have already submitted this contest. Check the leaderboard for your position.',
                                  style: GoogleFonts.notoSansBengali(
                                    textStyle: TextStyle(
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w400,
                                      color: AppColors.textPrimaryColor,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                   
                                 // Questions List
                  if (controller.isQuestionOpened.value)
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
                            child:                          const QuestionNavigatorWidget(),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            );
          }),
          const ContestActionWidget(),
        ],
      ),
    );
  }
}
