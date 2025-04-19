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
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Flagged Question Indicator
            Obx(() => Visibility(
              visible: ctrl.isMarkedQuestion(question.id),
              child: Container(
                width: 4.w,
                height: double.infinity,
                color: const Color(0xFFFF8143),
              ),
            )),
            SizedBox(width: 20.w),

            // Main Question Content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Question Title with LaTeX Support
                  HtmlWidget(
                    '${index + 1}) ${question.title}',
                    customWidgetBuilder: (element) {
                      if (element.classes.contains('latex') ||
                          element.classes.contains('ql-syntax')) {
                        return Math.tex(
                          element.text,
                          textStyle: const TextStyle(fontSize: 20),
                        );
                      }
                      return null;
                    },
                  ),

                  // Mark Question Row
                  Row(
                    children: [
                      Obx(() => Icon(
                        Icons.flag,
                        color: ctrl.isMarkedQuestion(question.id) 
                            ? const Color(0xFFFF8143) 
                            : Colors.black,
                      )),
                      SizedBox(width: 5.w),
                      GestureDetector(
                        onTap: () => ctrl.markUnmarkQuestion(question.id),
                        child: Obx(() => Text(
                          'Mark this Question',
                          style: GoogleFonts.inter(
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w400,
                            color: ctrl.isMarkedQuestion(question.id)
                                ? const Color(0xFFFF8143)
                                : Colors.black,
                          ),
                        )),
                      ),
                    ],
                  ),
                  SizedBox(height: 15.h),

                  // Options
                  if (question.options != null && question.options!.isNotEmpty)
                    _buildOptionsGrid(ctrl)
                  else
                    const Text('No options available'),

                  SizedBox(height: 15.h),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionsGrid(BaseQuestionController ctrl) {
    return Wrap(
      spacing: 12.w,
      runSpacing: 16.h,
      children: question.options!.asMap().entries.map((entry) {
        final index = entry.key;
        final option = entry.value;
        
        return SizedBox(
          width: (Get.width - 48.w) / 2,
          child: Obx(() {
            final isSelected = ctrl.isOptionSelected(question.id, option.order);
            final isLoading = loadingOptionIndex.value == index;

            return GestureDetector(
              onTap: isLoading ? null : () async {
                try {
                  loadingOptionIndex.value = index;
                  await ctrl.submitAnswer(
                    question.id,
                    contestId,
                    ctrl.getOptionAns(index + 1),
                  );
                } finally {
                  loadingOptionIndex.value = null;
                }
              },
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50.r),
                      border: Border.all(color: Colors.black, width: 1),
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
                        ? const CircularProgressIndicator()
                        : HtmlWidget(option.title),
                  ),
                ],
              ),
            );
          }),
        );
      }).toList(),
    );
  }
}
