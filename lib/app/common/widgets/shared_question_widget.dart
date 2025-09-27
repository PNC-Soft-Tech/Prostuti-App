// lib/common/widgets/shared_question_widget.dart

import 'package:blur/blur.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_math_fork/flutter_math.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
// import 'package:flutter_math_fork/flutter_math.dart';  // Temporarily disabled
import 'package:get/get.dart';
import '../../common/controllers/base_question_controller.dart';
import '../../modules/questions/models/question_model.dart';
import '../modals/unlock_full_access_modal.dart';
import 'shared_question_circle_widget.dart';

class SharedQuestionWidget extends StatelessWidget {
  final Question question;
  final String contestId;
  final int index;
  final BaseQuestionController controller;
  final bool showExplanation;
  final bool showCorrectAns;
  SharedQuestionWidget({
    super.key,
    required this.question,
    required this.contestId,
    required this.index,
    required this.controller,
    this.showExplanation = false,
    this.showCorrectAns = false,
  });

  final loadingOptionIndex = RxnInt();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Marking indicator
            Obx(() => controller.isMarkedQuestion(question.id)
                ? Container(
                    width: 4.w,
                    decoration: const BoxDecoration(
                      color: Color(0xFFFF8143),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(12),
                        bottomLeft: Radius.circular(12),
                      ),
                    ),
                  )
                : SizedBox.shrink()),

            // Question content
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(16.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Question title
                    HtmlWidget(
                      '${index + 1}) ${question.title.replaceAll('<pre>', '').replaceAll('</pre>', '')}',
                      customWidgetBuilder: (element) {
                        if (element.classes.contains('latex') ||
                            element.classes.contains('ql-syntax')) {
                          return Text(
                            element.text,
                            style: TextStyle(fontSize: 16.sp),
                          );
                        }
                        return null;
                      },
                      textStyle: TextStyle(
                        fontSize: 16.sp,
                        color: Colors.black87,
                        height: 1.5,
                      ),
                    ),
                    SizedBox(height: 8.h), // Correct/Incorrect indicator
                    Obx(() {
                      final isAnswered = (controller
                              .selectedAnswers[question.id]?.isNotEmpty ??
                          false);
                      final isReadMode =
                          controller.selectedTestMode.value == 'read';
                      final isExamMode =
                          controller.selectedTestMode.value == 'exam';
                      final isSubmitted = controller.isModelTestSubmitted.value;
                      final isCustomExam = contestId.contains('custom') ||
                          Get.currentRoute.contains('custom-exam');
                      // Show correct answers after submission in exam mode, or in read mode for model test (not custom exam)
                      if ((isExamMode && isSubmitted) ||
                          (isAnswered && isReadMode && !isCustomExam)) {
                        List<String> correctAnswers = question.options
                            .where((option) => option.isCorrect == true)
                            .map((option) => option.id)
                            .toList();
                        List<String> userAnswers =
                            controller.selectedAnswers[question.id] ?? [];
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  'Correct Answer:',
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.green,
                                  ),
                                ),
                                SizedBox(width: 8.w),
                                ...correctAnswers.map((ansId) {
                                  final option = question.options
                                      .firstWhereOrNull((o) => o.id == ansId);
                                  return option != null
                                      ? Container(
                                          margin: EdgeInsets.only(right: 6.w),
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 8.w, vertical: 4.h),
                                          decoration: BoxDecoration(
                                            color:
                                                Colors.green.withOpacity(0.15),
                                            borderRadius:
                                                BorderRadius.circular(6.r),
                                          ),
                                          child: HtmlWidget(
                                            '${option.title.replaceAll('<pre>', '').replaceAll('</pre>', '')}',
                                            customWidgetBuilder: (element) {
                                              if (element.classes
                                                      .contains('latex') ||
                                                  element.classes
                                                      .contains('ql-syntax')) {
                                                return Math.tex(
                                                  element.text,
                                                  textStyle: TextStyle(
                                                      fontSize: 16.sp),
                                                );
                                              }
                                              return null;
                                            },
                                            textStyle: TextStyle(
                                              fontSize: 13.sp,
                                              color: Colors.green,
                                              height: 1.5,
                                            ),
                                          ),
                                          // HtmlWidget(option.title,
                                          //     textStyle: TextStyle(
                                          //         fontSize: 13.sp,
                                          //         color: Colors.green)),
                                        )
                                      : SizedBox.shrink();
                                }).toList(),
                              ],
                            ),
                            SizedBox(height: 4.h),
                            if (userAnswers.isNotEmpty)
                              Row(
                                children: [
                                  Text(
                                    'Your Answer:',
                                    style: TextStyle(
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.blue,
                                    ),
                                  ),
                                  SizedBox(width: 8.w),
                                  ...userAnswers.map((ansId) {
                                    final option = question.options
                                        .firstWhereOrNull((o) => o.id == ansId);
                                    final isCorrect =
                                        correctAnswers.contains(ansId);
                                    return option != null
                                        ? Container(
                                            margin: EdgeInsets.only(right: 6.w),
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 8.w, vertical: 4.h),
                                            decoration: BoxDecoration(
                                              color: isCorrect
                                                  ? Colors.green
                                                      .withOpacity(0.15)
                                                  : Colors.red
                                                      .withOpacity(0.15),
                                              borderRadius:
                                                  BorderRadius.circular(6.r),
                                            ),
                                            child: HtmlWidget(
                                              '${option.title.replaceAll('<pre>', '').replaceAll('</pre>', '')}',
                                              customWidgetBuilder: (element) {
                                                if (element.classes
                                                        .contains('latex') ||
                                                    element.classes.contains(
                                                        'ql-syntax')) {
                                                  return Math.tex(
                                                    element.text,
                                                    textStyle: TextStyle(
                                                        fontSize: 13.sp),
                                                  );
                                                }
                                                return null;
                                              },
                                              textStyle: TextStyle(
                                                fontSize: 13.sp,
                                                color: isCorrect
                                                    ? Colors.green
                                                    : Colors.red,
                                                height: 1.5,
                                              ),
                                            ),
                                            // HtmlWidget(option.title,
                                            //     textStyle: TextStyle(fontSize: 13.sp, color: isCorrect ? Colors.green : Colors.red)),
                                          )
                                        : SizedBox.shrink();
                                  }).toList(),
                                ],
                              ),
                          ],
                        );
                      }
                      return SizedBox.shrink();
                    }),

                    SizedBox(height: 16.h),

                    // Mark question button
                    GestureDetector(
                      onTap: () => controller.markUnmarkQuestion(question.id),
                      child: Obx(() => Row(
                            children: [
                              Icon(
                                Icons.flag,
                                color: controller.isMarkedQuestion(question.id)
                                    ? const Color(0xFFFF8143)
                                    : Colors.black54,
                                size: 20.sp,
                              ),
                              SizedBox(width: 8.w),
                              Text(
                                'Mark this Question',
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  color:
                                      controller.isMarkedQuestion(question.id)
                                          ? const Color(0xFFFF8143)
                                          : Colors.black54,
                                ),
                              ),
                            ],
                          )),
                    ),
                    SizedBox(height: 16.h), // Options
                    if (question.options.isNotEmpty)
                      _buildOptions()
                    else
                      Text(
                        'No options available',
                        style: TextStyle(
                          color: Colors.red.shade300,
                          fontSize: 14.sp,
                        ),
                      ),

                    // Explanation (if available and enabled)
                    if (showExplanation &&
                        question.explanation != null &&
                        question.explanation!.isNotEmpty)
                      _buildExplanation(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOptions() {
    return Obx(() {
      // Determine if answers can be selected based on mode
      final bool isExamMode = controller.selectedTestMode.value == 'exam';
      final bool isReadMode = controller.selectedTestMode.value == 'read';
      final bool isSubmitted = controller.isModelTestSubmitted.value;

      // Allow selection in custom exams
      final bool isCustomExam = contestId.contains('custom') ||
          Get.currentRoute.contains('custom-exam');
      final bool canSelectAnswers = showExplanation ||
          isCustomExam || // Always allow selection in custom exams
          (isExamMode && !isSubmitted) ||
          (!isExamMode); // Can select in read mode and in exam mode before submission

      // Determine if correct answers should be shown
      final bool shouldShowCorrectAnswers =
          (isSubmitted && isExamMode) || // Only after submission in exam mode
              (isReadMode && !question.isAcceptMultipleAnswers ||
                  showCorrectAns); // Explicit parameter override

      // For custom exams, never show correct answers during the exam
      final bool finalShowCorrectAnswers =
          isCustomExam ? showCorrectAns : shouldShowCorrectAnswers;
      if (question.isGrid == true) {
        // GRID LAYOUT - 2 options per row
        final int rowCount = (question.options.length + 1) ~/ 2;

        return Column(
          children: List.generate(rowCount, (rowIndex) {
            // Create a row with up to 2 options
            return Row(
              children: List.generate(2, (colIndex) {
                final optionIndex = rowIndex * 2 + colIndex;

                // Check if this option exists (handle odd number of options)
                if (optionIndex >= question.options.length) {
                  return Expanded(child: Container());
                }

                final option = question.options[optionIndex];
                final isSelected =
                    controller.isOptionSelected(question.id, option.id);
                final isLoading = loadingOptionIndex.value == optionIndex;

                final correctAnsList = <String>[];
                question.options.forEach((o) {
                  if (o.isCorrect == true) {
                    correctAnsList.add(o.id);
                  }
                });
                final isAnswered =
                    controller.isAnswered(question.id, option.id);

                final singleAnswered = !question.isAcceptMultipleAnswers &&
                    (controller.selectedAnswers[question.id]?.isNotEmpty ??
                        false);
                final optionDisabled = singleAnswered && !isSelected;

                // For read mode, show tick for correct, cross for incorrect selected
                final isReadMode = controller.selectedTestMode.value == 'read';
                final showMarkLogic = isReadMode &&
                    (controller.selectedAnswers[question.id]?.isNotEmpty ??
                        false);
                bool showTick = false;
                bool showCross = false;
                if (showMarkLogic) {
                  if (option.isCorrect == true && isSelected) {
                    showTick = true;
                  } else if (option.isCorrect != true && isSelected) {
                    showCross = true;
                  }
                }

                // Prevent reselect/re-answer for multiple-answer questions after selection
                // Prevent re-selection for multiple-answer questions even if no option is correct
                // Always disable option after it is selected for multiple-answer questions
                final multiOptionDisabled = question.isAcceptMultipleAnswers &&
                    (controller.selectedAnswers[question.id]
                            ?.contains(option.id) ??
                        false);

                return Expanded(
                  child: GestureDetector(
                    onTap: (optionDisabled || multiOptionDisabled)
                        ? null
                        : () async {
                            // Prevent selection if not allowed
                            if (!canSelectAnswers) return;
                            // For single answer questions, prevent unselecting or changing after selection
                            if (!question.isAcceptMultipleAnswers && isAnswered)
                              return;
                            // For multiple answer questions, prevent reselecting already selected option
                            if (question.isAcceptMultipleAnswers &&
                                (controller.selectedAnswers[question.id]
                                        ?.contains(option.id) ??
                                    false)) return;

                            loadingOptionIndex.value = optionIndex;
                            controller.selectOption(question.id, option.id);

                            // Only submit answer via API in exam mode or for custom exams
                            bool success = true;
                            if (isExamMode ||
                                isCustomExam ||
                                question.isAcceptMultipleAnswers) {
                              success = await controller.submitAnswer(
                                question.id,
                                contestId,
                                controller.selectedAnswers[question.id] ?? [],
                              );
                              if (!success) {
                                controller.resetSelectOption(question.id);
                              }
                            }
                            // In read mode, we just store the selection locally without API call

                            loadingOptionIndex.value = null;
                          },
                    child: Opacity(
                      opacity:
                          (optionDisabled || multiOptionDisabled) ? 0.5 : 1.0,
                      child: Container(
                        margin: EdgeInsets.only(
                            bottom: 12.h,
                            right: colIndex == 0 ? 8.w : 0,
                            left: colIndex == 1 ? 8.w : 0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Option selector
                            Stack(
                              alignment: Alignment.center,
                              children: [
                                SharedQuestionCircleWidget(
                                  isCorrectAns: option.isCorrect == true,
                                  isSelected: isSelected,
                                  showCorrectAns: finalShowCorrectAnswers,
                                ),
                                if (showTick)
                                  Icon(Icons.check,
                                      color: Colors.green, size: 18.sp)
                                else if (showCross)
                                  Icon(Icons.close,
                                      color: Colors.red, size: 18.sp)
                              ],
                            ),

                            SizedBox(width: 8.w),

                            // Option content
                            Expanded(
                              child: isLoading
                                  ? Center(
                                      child: CupertinoActivityIndicator(
                                          radius: 12.r),
                                    )
                                  : HtmlWidget(
                                      option.title,
                                      textStyle: TextStyle(
                                        fontSize: 14
                                            .sp, // Slightly smaller font for grid layout
                                        color: Colors.black87,
                                      ),
                                    ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }),
            );
          }),
        );
      } else {
        // SINGLE COLUMN LAYOUT - Original implementation
        return Column(
          children: List.generate(question.options.length, (optionIndex) {
            final option = question.options[optionIndex];
            final isSelected =
                controller.isOptionSelected(question.id, option.id);
            final isLoading = loadingOptionIndex.value == optionIndex;
            final isCorrectAns = option.isCorrect == true;
            final isAnswered = controller.isAnswered(question.id, option.id);

            final singleAnswered = !question.isAcceptMultipleAnswers &&
                (controller.selectedAnswers[question.id]?.isNotEmpty ?? false);
            final optionDisabled = singleAnswered && !isSelected;
            final multiOptionDisabled = question.isAcceptMultipleAnswers &&
                (controller.selectedAnswers[question.id]?.contains(option.id) ??
                    false);
            return GestureDetector(
              onTap: (optionDisabled || multiOptionDisabled)
                  ? null
                  : () async {
                      // Prevent selection if not allowed
                      if (!canSelectAnswers) return;
                      // For single answer questions, prevent unselecting or changing after selection
                      if (!question.isAcceptMultipleAnswers && isAnswered)
                        return;
                      // For multiple answer questions, prevent reselecting already selected option
                      if (question.isAcceptMultipleAnswers &&
                          (controller.selectedAnswers[question.id]
                                  ?.contains(option.id) ??
                              false)) return;

                      loadingOptionIndex.value = optionIndex;
                      controller.selectOption(question.id, option.id);

                      // Only submit answer via API in exam mode or for custom exams
                      bool success = true;
                      if (isExamMode ||
                          isCustomExam ||
                          question.isAcceptMultipleAnswers) {
                        success = await controller.submitAnswer(
                          question.id,
                          contestId,
                          controller.selectedAnswers[question.id] ?? [],
                        );
                        if (!success) {
                          controller.resetSelectOption(question.id);
                        }
                      }
                      // In read mode, we just store the selection locally without API call

                      loadingOptionIndex.value = null;
                    },
              child: Opacity(
                opacity: (optionDisabled || multiOptionDisabled) ? 0.5 : 1.0,
                child: Container(
                  margin: EdgeInsets.only(bottom: 12.h),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Option selector
                      SharedQuestionCircleWidget(
                        isCorrectAns: isCorrectAns,
                        isSelected: isSelected,
                        showCorrectAns: finalShowCorrectAnswers,
                      ),

                      SizedBox(width: 12.w),

                      // Option content
                      Expanded(
                        child: isLoading
                            ? Center(
                                child: CupertinoActivityIndicator(radius: 12.r),
                              )
                            : HtmlWidget(
                                '${option.title.replaceAll('<pre>', '').replaceAll('</pre>', '')}',
                                customWidgetBuilder: (element) {
                                  if (element.classes.contains('latex') ||
                                      element.classes.contains('ql-syntax')) {
                                    return Math.tex(
                                      element.text,
                                      textStyle: TextStyle(fontSize: 16.sp),
                                    );
                                  }
                                  return null;
                                },
                                textStyle: TextStyle(
                                  fontSize: 16.sp,
                                  color: Colors.black87,
                                  height: 1.5,
                                ),
                              ),
                        // HtmlWidget(
                        //     option.title,
                        //     textStyle: TextStyle(
                        //       fontSize: 16.sp,
                        //       color: Colors.black87,
                        //     ),
                        //   ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
        );
      }
    });
  }

  Widget _buildExplanation() {
    return GestureDetector(
      onTap: () {
        UnlockFullAccessDialog.show();
      },
      child: Container(
        width: Get.width,
        margin: EdgeInsets.only(top: 16.h),
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          color: Colors.grey.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8.r),
          border: Border.all(
            color: Colors.grey.withOpacity(0.3),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'ব্যাখ্যা',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16.sp,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 6.h),
            Blur(
              blur: 2.5,
              borderRadius: BorderRadius.circular(10.r),
              blurColor: Colors.blueGrey.shade50,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: HtmlWidget(
                  question.explanation
                          ?.replaceAll('<pre>', '')
                          .replaceAll('</pre>', '') ??
                      '',
                  customWidgetBuilder: (element) {
                    if (element.classes.contains('latex') ||
                        element.classes.contains('ql-syntax')) {
                      // Render LaTeX content (temporarily using Text widget)
                      return Text(
                        element.text,
                        style: TextStyle(fontSize: 20),
                      );
                    }
                    return null; // Fallback to default rendering
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
