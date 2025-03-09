import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:prostuti/app/common/custom_bottom_fixed_button.dart';
import 'package:prostuti/app/common/utils/prostuti_utils.dart';
import 'package:prostuti/app/constant/app_color.dart';
import 'package:prostuti/app/modules/questions/models/question_model.dart';

import '../../../common/custom_simple_appbar.dart';
import '../../../common/widgets/countdown_timer.dart';
import '../../contests/controller/contest_controller.dart';
import '../../questions/widgets/question_widgets.dart';
import '../controller/contest_details_controller.dart';
import '../widgets/bottom_fixed_submit_contest_widget.dart';
import '../widgets/contest_action_widget.dart';
import '../widgets/contest_details_widget.dart';
import '../widgets/contest_status_widget.dart';
import '../widgets/exam_completed_dialog.dart';
import '../widgets/question_navigator.dart';
import '../widgets/question_navigator_widget.dart';
import '../widgets/question_widget.dart';
import '../widgets/show_flagged_questions_bottomsheet_widget.dart';
import '../widgets/subject_tabs_widget.dart';

class ContestDetailsViewOld extends GetView<ContestDetailsController> {
  const ContestDetailsViewOld({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomSimpleAppBar.appBar(title: "Contest Details"),
      body: Stack(
        children: [
          Obx(() {
            final questions =
                controller.contestDetails.value?.contest.questions ?? [];
            if (controller.isLoading.value) {
              return const Center(
                  child: CupertinoActivityIndicator(
                color: AppColors.primary,
              ));
            } else {
              return Container(
                color: Colors.white,
                padding: EdgeInsets.symmetric(vertical: 18.h, horizontal: 18.w),
                child: SingleChildScrollView(
                  controller: controller.scrollController,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (!controller.isQuestionOpened.value)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                controller.contestDetails.value?.contest
                                                .imageUrl !=
                                            null &&
                                        controller.contestDetails.value!.contest
                                            .imageUrl!
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
                                HtmlWidget(controller
                                        .contestDetails.value?.contest.name ??
                                    "বিসিএস কনটেস্ট-০১")
                                // Text(
                                //   controller
                                //           .contestDetails.value?.contest.name ??
                                //       "বিসিএস কনটেস্ট-০১",
                                //   style: GoogleFonts.notoSansBengali(
                                //       textStyle: TextStyle(
                                //     fontSize: 20.sp,
                                //     color: AppColors.textPrimaryColor,
                                //     fontWeight: FontWeight.w600,
                                //   )),
                                // )
                              ],
                            ),
                            SizedBox(
                              height: 19.h,
                            ),
                            Text(
                              " ${controller.contestDetails.value?.contest.stringTopics ?? 'গনিত - জ্যামিতি'}",
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
                            if (!controller.isQuestionOpened.value)
                              const ContestStatusWidget(), // ✅ Displays running or countdown UI
                            if (!controller.isQuestionOpened.value)
                              const ContestDetailsWidget(), // ✅ Displays contest details
                          ],
                        ),

                      SizedBox(
                        height: 70.h,
                      ),

                      Obx(() {
                        final filteredQuestions =
                            controller.filteredQuestions; // Use filtered list

                        if (!controller.isQuestionOpened.value) {
                          return const SizedBox(); // Return an empty widget if questions are not opened
                        }

                        if (filteredQuestions.isEmpty) {
                          return const Center(
                            child: Text("No questions available"),
                          );
                        }

                        return Column(
                          children: List.generate(
                            filteredQuestions.length,
                            (index) => Padding(
                              padding:  EdgeInsets.only(bottom: 8.h),
                              child: QuestionWidget(
                                question: filteredQuestions[index],
                                index: index,
                              ),
                            ),
                          ),
                        );
                      }),
                      SizedBox(
                        height: 80.h,
                      ),
                    ],
                  ),
                ),
              );
            }
          }),
          const ContestActionWidget(), // ✅ Handles submit/register buttons
          const QuestionNavigatorWidget(), // ✅ Handles floating question navigator
          Positioned(
              child: Align(
                  alignment: Alignment.topCenter, child: Container(
                    color: Colors.grey.shade50,
                    child: SubjectTabsWidget()))),
          SizedBox(
            height: 15.h,
          ),
          // Obx(() {
          //   final status = controller.contestStatus.value;
          //   final isQuestionOpened = controller.isQuestionOpened.value;

          //   if (isQuestionOpened) {
          //     return Align(
          //       alignment: Alignment.bottomCenter,
          //       child: BottomFixedSubmitContestWidget(
          //         timeLeft: controller.formattedCountdownTime,
          //         currentQuestionIndex:
          //             2, // you can make this dynamic if needed
          //         totalQuestions: controller
          //                 .contestDetails.value?.contest.questions.length ??
          //             0,
          //         onCompletePressed: () {
          //           showDialog(
          //             context: context,
          //             builder: (context) => ExamCompletedDialog(
          //               onSubmit: () {
          //                 Navigator.of(context).pop();
          //                 controller.submitContest(
          //                     controller.contestDetails.value?.contest.id ??
          //                         '');
          //               },
          //             ),
          //           );
          //         },
          //       ),
          //     );
          //   } else {
          //     return Align(
          //       alignment: Alignment.bottomCenter,
          //       child: CustomBottomFixedButton(
          //         buttonText: status?.isRunning == true &&
          //                 controller
          //                         .contestDetails.value?.contest.isRegistered ==
          //                     true
          //             ? "Enter Now "
          //             : ((status?.isScheduled == true &&
          //                         controller.contestDetails.value?.contest
          //                                 .isRegistered ==
          //                             false) ||
          //                     (status?.isRunning == true &&
          //                         controller.contestDetails.value?.contest
          //                                 .isRegistered ==
          //                             false))
          //                 ? "Register Now"
          //                 : "Completed",
          //         onPressed: () {
          //           if (controller.contestDetails.value?.contest.isRegistered ==
          //                   false &&
          //               (status?.isRunning == true ||
          //                   status?.isScheduled == true)) {
          //             Get.find<ContestController>().registerForContest(
          //                 controller.contestDetails.value!.contest.id);
          //             controller.isQuestionOpened.value = true;
          //           } else if (status?.isDone == false ||
          //               status?.isRunning == true) {
          //             controller.isQuestionOpened.value = true;
          //           }
          //         },
          //       ),
          //     );
          //   }
          // }),
          // Obx(() {
          //   if (controller.isQuestionOpened.value) {
          //     return Positioned(
          //       right: 16.w,
          //       bottom: 100.h,
          //       child: QuestionNavigatorFloating(
          //         onOpenFlaggedSheet: () => showFlaggedQuestionsBottomSheet(
          //             controller.markedQuestionIds),
          //       ),
          //     );
          //   }
          //   return const SizedBox.shrink(); // If not opened, don't show
          // }),
        ],
      ),
    );
  }

  Widget buildQuestionWidget(
          {required Question question, required int index}) =>
      Container(
        key: controller.questionKeys[question.id], // Attach key here
        child: IntrinsicHeight(
            child: Row(
          crossAxisAlignment:
              CrossAxisAlignment.stretch, // Ensures both sides match height

          children: [
            Visibility(
              visible: controller.isMarkedQuestion(question.id),
              child: Container(
                width: 4.w,
                height: double.infinity,
                color: controller.isMarkedQuestion(question.id)
                    ? const Color(0xFFFF8143)
                    : Colors.black,
              ),
            ),
            SizedBox(
              width: 20.w,
            ),
            Container(
              child: Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Text(
                    //   "${index + 1}) ${question.title}",
                    //   style: GoogleFonts.notoSansBengali(
                    //       textStyle:
                    //           TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w600)),
                    // ),
                    HtmlWidget(
                      "${index + 1}) ${question.title.replaceAll('<p>', '')}",
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    Row(
                      children: [
                        Icon(Icons.flag,
                            color: controller.isMarkedQuestion(question.id)
                                ? const Color(0xFFFF8143)
                                : Colors.black),
                        SizedBox(
                          width: 5.w,
                        ),
                        GestureDetector(
                          onTap: () {
                            controller.markUnmarkQuestion(question.id);
                            debugPrint("qid-----> ${question.id}");
                          },
                          child: Text('Mark this Question',
                              style: GoogleFonts.inter(
                                  textStyle: TextStyle(
                                      fontSize: 15.sp,
                                      fontWeight: FontWeight.w400,
                                      color: controller
                                              .isMarkedQuestion(question.id)
                                          ? const Color(0xFFFF8143)
                                          : Colors.black))),
                        ),
                        // SizedBox(
                        //   height: 10.h,
                        // ),
                      ],
                    ),

                    question.isGrid == true
                        ? _buildGridOptions(question)
                        : _buildListOptions(question),
                  ],
                ),
              ),
            ),
          ],
        )),
      );

  Widget _buildGridOptions(Question question) {
    if (question.options.isEmpty) {
      return const Text("No options");
    }

    return controller.questionLoadingStatus[question.id] == true
        ? const Center(
            child: CupertinoActivityIndicator(
            color: AppColors.primary,
          ))
        : Wrap(
            spacing: 12.w, // Horizontal space between items
            runSpacing: 16.h, // Vertical space between rows
            children: question.options.map((option) {
              return SizedBox(
                width: (MediaQuery.of(Get.context!).size.width - 48.w) /
                    2, // 2 items per row
                child: GestureDetector(
                  onTap: () async {
                    controller.selectOption(question.id, option.order);
                    bool isDone = await controller.submitAnswer(
                        question.id,
                        controller.contestDetails.value?.contest.id ?? '',
                        controller.getOptionAns(
                            question.options.indexOf(option) + 1));
                    if (!isDone) {
                      // 3️⃣ If failed, revert selection

                      controller.selectedAnswers.remove(
                          question.id); // ❌ Deselect if submission fails
                    }
                    debugPrint(
                        " Selecetd optioon: ${controller.isOptionSelected(question.id, option.order)}");
                    debugPrint(" Selecetd optioon order: ${option.order}");
                  },
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50.r),
                          border: Border.all(color: Colors.black, width: 1),
                          color: Colors.transparent,
                        ),
                        child: controller.isOptionSelected(
                                question.id, option.order)
                            ? Container(
                                height: 20,
                                width: 20,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50.r),
                                  color: AppColors.primary,
                                ),
                              )
                            : SizedBox(
                                height: 20,
                                width: 20,
                              ),
                      ),
                      SizedBox(width: 8.w),
                      Expanded(child: HtmlWidget(option.title)),
                      SizedBox(
                        height: 16.h,
                      )
                    ],
                  ),
                ),
              );
            }).toList(),
          );
  }

  Widget _buildListOptions(Question question) {
    if (question.options.isEmpty) {
      return const Text("No options");
    }

    return controller.questionLoadingStatus[question.id] == true
        ? const Center(
            child: CupertinoActivityIndicator(
            color: AppColors.primary,
          ))
        : Column(
            children: [
              for (int i = 0; i < question.options.length; i++) ...[
                GestureDetector(
                  onTap: () async {
                    controller.selectOption(
                        question.id, question.options[i].order);
                    bool isDone = await controller.submitAnswer(
                        question.id,
                        controller.contestDetails.value?.contest.id ?? '',
                        controller.getOptionAns(i + 1));
                    if (!isDone) {
                      // 3️⃣ If failed, revert selection

                      controller.selectedAnswers.remove(
                          question.id); // ❌ Deselect if submission fails
                    }
                  },
                  child: Row(
                    children: [
                      Flexible(
                          flex: 1,
                          child: Container(
                            padding: const EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50.r),
                              border: Border.all(color: Colors.black, width: 1),
                              color: Colors.transparent,
                            ),
                            child: controller.isOptionSelected(
                                    question.id, question.options[i].order)
                                ? Container(
                                    height: 20,
                                    width: 20,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(50.r),
                                      color: AppColors.primary,
                                    ),
                                  )
                                : SizedBox(
                                    height: 20,
                                    width: 20,
                                  ),
                          )),
                      SizedBox(width: 12.w),
                      Flexible(
                          flex: 9,
                          child: HtmlWidget(question.options[i].title)),
                    ],
                  ),
                ),
                if (i <
                    question.options.length -
                        1) // Add SizedBox after each row except the last
                  SizedBox(height: 16.h),
              ],
            ],
          );
  }

  Widget _alreadyRunning() => SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            Text(
              "Already Running",
              style: GoogleFonts.inter(
                  textStyle: TextStyle(
                fontSize: 12.sp,
                color: AppColors.textPrimaryColor,
                fontWeight: FontWeight.w500,
              )),
            ),
            SizedBox(
              width: 22.w,
            ),
            Container(
              padding:
                  const EdgeInsets.symmetric(vertical: 13.5, horizontal: 16.5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(55.13.r),
                border: Border.all(color: AppColors.primary),
              ),
              child: SingleChildScrollView(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset('assets/countdown.png'),
                    SizedBox(width: 9.w),
                    CountdownTimer(
                      startContest: controller
                              .contestDetails.value?.contest.startContest ??
                          DateTime.now(),
                      endContest:
                          controller.contestDetails.value?.contest.endContest ??
                              DateTime.now(),
                      fontSize: 12.sp,
                    ),
                    // Text(
                    //   "Time Left: 23: 55 : 20 ",
                    //   style: GoogleFonts.inter(
                    //       textStyle: TextStyle(
                    //     fontSize: 15.sp,
                    //     color: AppColors.primary,
                    //     fontWeight: FontWeight.w600,
                    //   )),
                    // ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
  Widget _contestCountdown() => Container(
        padding: const EdgeInsets.symmetric(vertical: 13.5, horizontal: 16.5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(55.13.r),
          border: Border.all(color: AppColors.primary),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset('assets/countdown.png'),
            SizedBox(width: 9.w),
            CountdownTimer(
              startContest:
                  controller.contestDetails.value?.contest.startContest ??
                      DateTime.now(),
              endContest: controller.contestDetails.value?.contest.endContest ??
                  DateTime.now(),
              fontSize: 18.sp,
            ),
            // Text(
            //   "23: 55 : 20 ",
            //   style: GoogleFonts.inter(
            //       textStyle: TextStyle(
            //     fontSize: 18.sp,
            //     color: AppColors.primary,
            //     fontWeight: FontWeight.w600,
            //   )),
            // ),
          ],
        ),
      );
  Widget buildLeftColumnRow({required String img, required String title}) =>
      Container(
        padding: EdgeInsets.symmetric(vertical: 11.h),
        child: Row(
          children: [
            Image.asset(img),
            SizedBox(
              width: 12.53.w,
            ),
            Text(title,
                style: GoogleFonts.notoSansBengali(
                    textStyle: TextStyle(
                        fontSize: 16.sp,
                        color: AppColors.textPrimaryColor,
                        fontWeight: FontWeight.w400))),
          ],
        ),
      );

  Widget buildRightColumnRow({
    required String value,
  }) =>
      Container(
        padding: EdgeInsets.symmetric(vertical: 11.h),
        child: Text(value,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.notoSansBengali(
                textStyle: TextStyle(
                    fontSize: 16.sp,
                    color: AppColors.textPrimaryColor,
                    fontWeight: FontWeight.w600))),
      );
  Widget buildDetailsWidget() => Container(
        child: Column(
          children: [
            Row(
              children: [
                SizedBox(
                  width: Get.width / 3,
                  child: Column(
                    children: [
                      buildLeftColumnRow(
                        title: "বিষয়",
                        img: 'assets/subject.png',
                      ),
                      buildLeftColumnRow(
                        title: "সর্বমান",
                        img: 'assets/total-marks.png',
                      ),
                      buildLeftColumnRow(
                        title: "সময়",
                        img: 'assets/total-time.png',
                      ),
                      buildLeftColumnRow(
                        title: "প্রতিযোগী",
                        img: 'assets/participiants.png',
                      ),
                      buildLeftColumnRow(
                        title: "তারিখ",
                        img: 'assets/contest-start.png',
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      buildRightColumnRow(
                          value:
                              "${controller.contestDetails.value?.contest.stringTopics}"),
                      buildRightColumnRow(
                          value:
                              "${controller.contestDetails.value?.contest.totalMarks} মার্কস"),
                      buildRightColumnRow(
                          value:
                              "${controller.contestDetails.value?.contest.totalTime} মিনিট"),
                      buildRightColumnRow(
                          value:
                              "${controller.contestDetails.value?.contest.registeredCount} জন"),
                      buildRightColumnRow(
                          value: Utils.formatDateToBangla(controller
                                  .contestDetails.value?.contest.endContest ??
                              DateTime.now())),
                    ],
                  ),
                )
              ],
            )
          ],
        ),
      );
}
