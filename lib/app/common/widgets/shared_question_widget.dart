import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:flutter_math_fork/flutter_math.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import '../controllers/base_question_controller.dart';
import '../../constant/app_color.dart';
import '../../modules/questions/models/question_model.dart';

class SharedQuestionWidget extends StatelessWidget {
  final Question question;
  final String contestId;
  final bool showFlagButton;
  final BaseQuestionController? controller;
  final int index;

  SharedQuestionWidget({
    Key? key,
    required this.question,
    required this.contestId,
    required this.index,
    this.showFlagButton = true,
    this.controller,
  }) : super(key: key);

  final loadingOptionIndex = RxnInt();

  @override
  Widget build(BuildContext context) {
    final BaseQuestionController ctrl;
    if (controller != null) {
      ctrl = controller!;
    } else if (Get.isRegistered<BaseQuestionController>()) {
      ctrl = Get.find<BaseQuestionController>();
    } else {
      throw Exception('No question controller found');
    }

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.r),
        boxShadow: [
          BoxShadow(
            offset: const Offset(0, 1),
            blurRadius: 4,
            color: Colors.black.withOpacity(0.1),
          ),
        ],
      ),
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ctrl.isMarkedQuestion(question.id)
                ? Visibility(
                    visible: ctrl.isMarkedQuestion(question.id),
                    child: Container(
                      width: 4.w,
                      height: double.infinity,
                      color: ctrl.isMarkedQuestion(question.id)
                          ? const Color(0xFFFF8143)
                          : Colors.black,
                    ),
                  )
                : const SizedBox.shrink(),
            // Question Number Container
            // Container(
            //   width: 40.w,
            //   decoration: BoxDecoration(
            //     color: AppColors.primary,
            //     borderRadius: BorderRadius.only(
            //       topLeft: Radius.circular(8.r),
            //       bottomLeft: Radius.circular(8.r),
            //     ),
            //   ),
            //   child: Center(
            //     child: Text(
            //       '${index + 1}',
            //       style: TextStyle(
            //         color: Colors.white,
            //         fontSize: 18.sp,
            //         fontWeight: FontWeight.bold,
            //       ),
            //     ),
            //   ),
            // ),

            Expanded(
              child: Padding(
                padding: EdgeInsets.all(16.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Question Title
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

                    SizedBox(height: 16.h),
                    // Mark Question Button
                    Row(
                      children: [
                        Icon(Icons.flag,
                            color: ctrl.isMarkedQuestion(question.id)
                                ? const Color(0xFFFF8143)
                                : Colors.black),
                        SizedBox(
                          width: 5.w,
                        ),
                        GestureDetector(
                          onTap: () {
                            ctrl.markUnmarkQuestion(question.id);
                            debugPrint("qid-----> ${question.id}");
                          },
                          child: Text('Mark this Question',
                              style: GoogleFonts.inter(
                                  textStyle: TextStyle(
                                      fontSize: 15.sp,
                                      fontWeight: FontWeight.w400,
                                      color: ctrl.isMarkedQuestion(question.id)
                                          ? const Color(0xFFFF8143)
                                          : Colors.black))),
                        ),
                        SizedBox(
                          height: 10.h,
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    // Options
                    if (question.options != null &&
                        question.options!.isNotEmpty)
                      _buildOptions(ctrl)
                    else
                      const Text('No options available'),

                    SizedBox(height: 16.h),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOptions(BaseQuestionController ctrl) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: Obx(() {
        return Column(
          children: List.generate(question.options!.length, (optionIndex) {
            final option = question.options![optionIndex];
            final isSelected = ctrl.isOptionSelected(question.id, option.order);
            final isLoading = loadingOptionIndex.value == optionIndex;

            return GestureDetector(
              onTap: () async {
                loadingOptionIndex.value = optionIndex;
                ctrl.selectOption(question.id, option.order);
                bool isDone = await ctrl.submitAnswer(
                  question.id,
                  contestId,
                  ctrl.getOptionAns(optionIndex + 1),
                );
                loadingOptionIndex.value = null;
                if (!isDone) {
                  // Optionally handle failed submission
                }
              },
              child: Container(
                padding: EdgeInsets.only(bottom: 8.h),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50.r),
                        border: Border.all(color: Colors.black, width: 1),
                        color: Colors.transparent,
                      ),
                      child: isSelected
                          ? Container(
                              height: 20,
                              width: 20,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50.r),
                                color: AppColors.primary,
                              ),
                            )
                          : const SizedBox(height: 20, width: 20),
                    ),
                    SizedBox(width: 8.w),
                    Expanded(
                      child: isLoading
                          ? Center(
                              child: CupertinoActivityIndicator(
                                  color: AppColors.primary))
                          : HtmlWidget(option.title),
                    ),
                  ],
                ),
              ),
            );
          }),
        );
      }),
    );
  }
}
