import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_math_fork/flutter_math.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:get/get.dart';
import '../../../common/utils/prostuti_utils.dart';
import '../../../constant/app_color.dart';
import '../../questions/models/question_model.dart';
import '../controller/contest_details_controller.dart';

class QuestionOptionsWidget extends GetWidget<ContestDetailsController> {
  final Question question;

  const QuestionOptionsWidget({super.key, required this.question});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return question.isGrid == true
          ? _buildGridOptions()
          : _buildListOptions();
    });
  }

  /// ✅ **Grid Layout Options**
  Widget _buildGridOptions() {
    if (question.options.isEmpty) {
      return const Text("No options");
    }

    return controller.questionLoadingStatus[question.id] == true
        ? const Center(
            child: CupertinoActivityIndicator(color: AppColors.primary))
        : Container(
            padding: EdgeInsets.symmetric(vertical: 1.h),
            child: Wrap(
              spacing: 12.w, // Horizontal space between items
              runSpacing: 16.h, // Vertical space between rows
              children: question.options.map((option) {
                String optionTitle = Utils.decodeHtmlEntities(option.title);
                return SizedBox(
                  width: (MediaQuery.of(Get.context!).size.width - 48.w) /
                      2, // 2 items per row
                  child: GestureDetector(
                    onTap: () async {
                      controller.selectOption(question.id, option.id);
                      debugPrint("optionId: ${option.id}");
                      bool isDone = await controller.submitAnswer(
                        question.id,
                        controller.contestDetails.value?.contest.id ?? '',
                        controller
                            .selectedAnswers[question.id] ?? [],
                      );
                      if (!isDone) {
                        controller.selectedAnswers.remove(
                            question.id); // ❌ Deselect if submission fails
                      }
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
                              : const SizedBox(height: 20, width: 20),
                        ),
                        SizedBox(width: 8.w),
                        Expanded(
                            child: HtmlWidget(
                          optionTitle,
                          customWidgetBuilder: (element) {
                            print('option Element classes: $optionTitle');

                            if (element.classes.contains('latex') ||
                                element.classes.contains('ql-syntax')) {
                              // Render LaTeX content
                              return Math.tex(
                                element.text,
                                textStyle: const TextStyle(fontSize: 20),
                              );
                            }
                            return null; // Fallback to default rendering
                          },
                        )),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          );
  }

  /// ✅ **List Layout Options**
  Widget _buildListOptions() {
    if (question.options.isEmpty) {
      return const Text("No options");
    }

    return controller.questionLoadingStatus[question.id] == true
        ? const Center(
            child: CupertinoActivityIndicator(color: AppColors.primary))
        : Container(
            padding: EdgeInsets.symmetric(vertical: 1.h),
            child: Column(
              children: question.options.map((option) {
                return GestureDetector(
                  onTap: () async {
                    controller.selectOption(question.id, option.id);
                  debugPrint("optionId: ${option.id}");
                    bool isDone = await controller.submitAnswer(
                      question.id,
                      controller.contestDetails.value?.contest.id ?? '',
                      controller.selectedAnswers[question.id]??[],
                    );
                    if (!isDone) {
                      controller.selectedAnswers.remove(
                          question.id); // ❌ Deselect if submission fails
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
                              : const SizedBox(height: 20, width: 20),
                        ),
                        SizedBox(width: 8.w),
                        Expanded(child: HtmlWidget(option.title)),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          );
  }
}
