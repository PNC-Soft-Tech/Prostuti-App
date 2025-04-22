// lib/common/widgets/shared_question_widget.dart

import 'package:blur/blur.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:flutter_math_fork/flutter_math.dart';
import 'package:get/get.dart';
import '../../constant/app_color.dart';
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
    Key? key,
    required this.question,
    required this.contestId,
    required this.index,
    required this.controller,
    this.showExplanation = false,
    this.showCorrectAns = false,
  }) : super(key: key);

  final loadingOptionIndex = RxnInt();

  @override
  Widget build(BuildContext context) {
    bool isCorrectAns =
        controller.selectedAnswers[question.id]?.toLowerCase() ==
            question.rightAnswer?.toLowerCase();
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
            if (controller.isMarkedQuestion(question.id))
              Container(
                width: 4.w,
                decoration: const BoxDecoration(
                  color: Color(0xFFFF8143),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(12),
                    bottomLeft: Radius.circular(12),
                  ),
                ),
              ),

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
                    SizedBox(height: 8.h),
                    // Question description
                    if (showCorrectAns)
                      //show if correct ans

                      Text(isCorrectAns ? "Correct" : "Incorrect",
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: isCorrectAns
                                ? Colors.black54
                                : Colors.red.shade300,
                          )),

                    SizedBox(height: 16.h),

                    // Mark question button
                    GestureDetector(
                      onTap: () => controller.markUnmarkQuestion(question.id),
                      child: Row(
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
                              color: controller.isMarkedQuestion(question.id)
                                  ? const Color(0xFFFF8143)
                                  : Colors.black54,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 16.h),

                    // Options
                    if (question.options != null &&
                        question.options!.isNotEmpty)
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

  // Widget _buildOptions() {
  //   return Obx(() {
  //     return Column(
  //       children: List.generate(question.options!.length, (optionIndex) {
  //         final option = question.options![optionIndex];
  //         final isSelected =
  //             controller.isOptionSelected(question.id, option.order);
  //         final isLoading = loadingOptionIndex.value == optionIndex;

  //         return GestureDetector(
  //           onTap: () async {
  //             loadingOptionIndex.value = optionIndex;
  //             controller.selectOption(question.id, option.order);

  //             bool success = await controller.submitAnswer(
  //               question.id,
  //               contestId,
  //               controller.getOptionAns(optionIndex + 1),
  //             );
  //             if (!success) {
  //               controller.resetSelectOption(question.id);
  //             }

  //             loadingOptionIndex.value = null;
  //           },
  //           child: Container(
  //             margin: EdgeInsets.only(bottom: 12.h),
  //             child: Row(
  //               crossAxisAlignment: CrossAxisAlignment.start,
  //               children: [
  //                 // Option selector
  //                 Container(
  //                   width: 26.w,
  //                   height: 26.w,
  //                   margin: EdgeInsets.only(top: 4.h),
  //                   decoration: BoxDecoration(
  //                     shape: BoxShape.circle,
  //                     border: Border.all(
  //                       color: isSelected ? AppColors.primary : Colors.black54,
  //                       width: 1.5,
  //                     ),
  //                     color:
  //                         isSelected ? AppColors.primary : Colors.transparent,
  //                   ),
  //                   child: isSelected
  //                       ? Icon(
  //                           Icons.check,
  //                           color: Colors.white,
  //                           size: 16.sp,
  //                         )
  //                       : null,
  //                 ),

  //                 SizedBox(width: 12.w),

  //                 // Option content
  //                 Expanded(
  //                   child: isLoading
  //                       ? Center(
  //                           child: CupertinoActivityIndicator(radius: 12.r),
  //                         )
  //                       : HtmlWidget(
  //                           option.title,
  //                           textStyle: TextStyle(
  //                             fontSize: 16.sp,
  //                             color: Colors.black87,
  //                           ),
  //                         ),
  //                 ),
  //               ],
  //             ),
  //           ),
  //         );
  //       }),
  //     );
  //   });
  // }
  Widget _buildOptions() {
    return Obx(() {
      if (question.isGrid == true) {
        // GRID LAYOUT - 2 options per row
        // Calculate the number of rows needed (ceiling division)
        final int rowCount = (question.options!.length + 1) ~/ 2;

        return Column(
          children: List.generate(rowCount, (rowIndex) {
            // Create a row with up to 2 options
            return Row(
              children: List.generate(2, (colIndex) {
                final optionIndex = rowIndex * 2 + colIndex;

                // Check if this option exists (handle odd number of options)
                if (optionIndex >= question.options!.length) {
                  return Expanded(child: Container());
                }

                final option = question.options![optionIndex];
                final isSelected =
                    controller.isOptionSelected(question.id, option.order);
                final isLoading = loadingOptionIndex.value == optionIndex;
                final isCorrectAns = question.rightAnswer?.toLowerCase() ==
                    controller
                        .getOptionAns(int.tryParse(option.order) ?? 0)
                        .toLowerCase();

                final isAnswered = controller.isAnswered(question.id,
                    question.options!.map((e) => e.order).toList());

                return Expanded(
                  child: GestureDetector(
                    onTap: () async {
                      if (isAnswered || showCorrectAns)
                        return; // Prevent selection if already answered
                      loadingOptionIndex.value = optionIndex;
                      controller.selectOption(question.id, option.order);

                      bool success = await controller.submitAnswer(
                        question.id,
                        contestId,
                        controller.getOptionAns(optionIndex + 1),
                      );
                      if (!success) {
                        controller.resetSelectOption(question.id);
                      }

                      loadingOptionIndex.value = null;
                    },
                    child: Container(
                      margin: EdgeInsets.only(
                          bottom: 12.h,
                          right: colIndex == 0 ? 8.w : 0,
                          left: colIndex == 1 ? 8.w : 0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Option selector
                          SharedQuestionCircleWidget(
                            isCorrectAns: isCorrectAns,
                            isSelected: isSelected,
                            showCorrectAns: showCorrectAns,
                          ),
                          // Container(
                          //   width: 26.w,
                          //   height: 26.w,
                          //   margin: EdgeInsets.only(top: 4.h),
                          //   decoration: BoxDecoration(
                          //     shape: BoxShape.circle,
                          //     border: Border.all(
                          //       color: isCorrectAns
                          //           ? Colors.green
                          //           : Colors.black45,
                          //       width: 1.5,
                          //     ),
                          //     color: isCorrectAns
                          //         ? Colors.green
                          //         : Colors.transparent,
                          //   ),
                          //   child: isCorrectAns
                          //       ? Icon(
                          //           Icons.check,
                          //           color: Colors.white,
                          //           size: 16.sp,
                          //         )
                          //       : isSelected && !isCorrectAns
                          //           ? Icon(
                          //               Icons.close,
                          //               color: Colors.red,
                          //               size: 16.sp,
                          //             )
                          //           : null,
                          // ),

                          SizedBox(width: 8.w),

                          // Option content
                          Expanded(
                            child: isLoading
                                ? Center(
                                    child: CupertinoActivityIndicator(
                                        radius: 12.r),
                                  )
                                : HtmlWidget(
                                    option.title +
                                        "-" +
                                        isCorrectAns.toString() +
                                        "-selected-" +
                                        isSelected.toString() +
                                        "-right=" +
                                        question.rightAnswer.toString() +
                                        "=order=" +
                                        controller
                                            .getOptionAns(
                                                int.tryParse(option.order) ?? 0)
                                            .toString(),
                                    textStyle: TextStyle(
                                      fontSize: 14
                                          .sp, // Slightly smaller font for grid layout
                                      color: Colors.black87,
                                    ),
                                  ),
                            // HtmlWidget(
                            //     option.title ,
                            //     textStyle: TextStyle(
                            //       fontSize: 14
                            //           .sp, // Slightly smaller font for grid layout
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
          }),
        );
      } else {
        // SINGLE COLUMN LAYOUT - Original implementation
        return Column(
          children: List.generate(question.options!.length, (optionIndex) {
            final option = question.options![optionIndex];
            final isSelected =
                controller.isOptionSelected(question.id, option.order);
            final isLoading = loadingOptionIndex.value == optionIndex;
            List<String> optionOrderList =
                question.options!.map((e) => e.order).toList();
            final isCorrectAns = question.rightAnswer?.toLowerCase() ==
                controller
                    .getOptionAns(int.tryParse(option.order) ?? 0)
                    .toLowerCase();
            final isAnswered = controller.isAnswered(
                question.id, question.options!.map((e) => e.order).toList());
            return GestureDetector(
              onTap: () async {
                if (isAnswered || showCorrectAns) return; // Prevent selection if already answered
                loadingOptionIndex.value = optionIndex;
                controller.selectOption(question.id, option.order);

                bool success = await controller.submitAnswer(
                  question.id,
                  contestId,
                  controller.getOptionAns(optionIndex + 1),
                );
                if (!success) {
                  controller.resetSelectOption(question.id);
                }

                loadingOptionIndex.value = null;
              },
              child: Container(
                margin: EdgeInsets.only(bottom: 12.h),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Option selector
                    SharedQuestionCircleWidget(
                      isCorrectAns: isCorrectAns,
                      isSelected: isSelected,
                      showCorrectAns: showCorrectAns,
                    ),

                    // Container(
                    //   width: 26.w,
                    //   height: 26.w,
                    //   margin: EdgeInsets.only(top: 4.h),
                    //   decoration: BoxDecoration(
                    //     shape: BoxShape.circle,
                    //     border: Border.all(
                    //       color: isCorrectAns ? Colors.green : Colors.black45,
                    //       width: 1.5,
                    //     ),
                    //     color: isCorrectAns ? Colors.green : Colors.transparent,
                    //   ),
                    //   child: isCorrectAns
                    //       ? Icon(
                    //           Icons.check,
                    //           color: Colors.white,
                    //           size: 16.sp,
                    //         )
                    //       : isSelected && !isCorrectAns
                    //           ? Icon(
                    //               Icons.close,
                    //               color: Colors.red,
                    //               size: 16.sp,
                    //             )
                    //           : null,
                    // ),

                    SizedBox(width: 12.w),

                    // Option content
                    Expanded(
                      child: isLoading
                          ? Center(
                              child: CupertinoActivityIndicator(radius: 12.r),
                            )
                          : HtmlWidget(
                              option.title +
                                  "-" +
                                  isCorrectAns.toString() +
                                  "-selected-" +
                                  isSelected.toString() +
                                  "-right=" +
                                  question.rightAnswer.toString() +
                                  "=order=" +
                                  controller
                                      .getOptionAns(
                                          int.tryParse(option.order) ?? 0)
                                      .toString(),
                              textStyle: TextStyle(
                                fontSize: 14
                                    .sp, // Slightly smaller font for grid layout
                                color: Colors.black87,
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
      child: Obx(() => Container(
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
                          ''.replaceAll('<pre>', '').replaceAll('</pre>', ''),
                      customWidgetBuilder: (element) {
                        print('explanation Element classes: ${question.title}');

                        if (element.classes.contains('latex') ||
                            element.classes.contains('ql-syntax')) {
                          // Render LaTeX content
                          return Math.tex(
                            element.text,
                            textStyle: TextStyle(fontSize: 20),
                          );
                        }
                        return null; // Fallback to default rendering
                      },
                    ),
                  ),
                ),
                // HtmlWidget(
                //   question.explanation ?? '',
                //   textStyle: TextStyle(
                //     fontSize: 14.sp,
                //     color: Colors.black87,
                //   ),
                // ),
              ],
            ),
          )),
    );
  }
}
