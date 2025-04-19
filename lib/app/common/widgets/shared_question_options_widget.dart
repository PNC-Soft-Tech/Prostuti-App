import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:get/get.dart';
import '../../constant/app_color.dart';
import '../../modules/contest-details/controller/contest_details_controller.dart';

class SharedQuestionOptionsWidget extends StatelessWidget {
  final String questionId;
  final List<dynamic> options;
  final String contestId;

  const SharedQuestionOptionsWidget({
    Key? key,
    required this.questionId,
    required this.options,
    required this.contestId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ContestDetailsController>();

    return Column(
      children: options.asMap().entries.map((entry) {
        final index = entry.key + 1;
        final option = entry.value;
        final optionOrder = controller.getOptionAns(index);

        return Obx(() {
          final isSelected = controller.isOptionSelected(questionId, optionOrder);
          final isLoading = controller.questionLoadingStatus[questionId] ?? false;

          return Container(
            padding: EdgeInsets.symmetric(vertical: 1.h),
            child: Column(
              children: options.map((option) {
                return GestureDetector(
                  onTap: () async {
                    controller.selectOption(questionId, option.order);
                    bool isDone = await controller.submitAnswer(
                      questionId,
                      controller.contestDetails.value?.contest.id ?? '',
                      controller
                          .getOptionAns(options.indexOf(option) + 1),
                    );
                    if (!isDone) {
                      controller.selectedAnswers.remove(
                          questionId); // ❌ Deselect if submission fails
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
                                  questionId, option.order)
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
          
          // ListTile(
          //   title: Text(option.toString()),
          //   leading: Radio<String>(
          //     value: optionOrder,
          //     groupValue: controller.selectedAnswers[questionId],
          //     onChanged: isLoading ? null : (String? value) async {
          //       if (value != null) {
          //         controller.selectOption(questionId, value);
                  
          //         // Submit the answer immediately after selection
          //         debugPrint('Calling submitAnswer with:'
          //             '\nquestionId: $questionId'
          //             '\ncontestId: $contestId'
          //             '\nvalue: $value');
                      
          //         final success = await controller.submitAnswer(
          //           questionId,
          //           contestId,
          //           value,
          //         );
                  
          //         debugPrint('Submit answer result: $success');
          //       }
          //     },
          //   ),
          //   trailing: isLoading ? const SizedBox(
          //     width: 20,
          //     height: 20,
          //     child: Center(
          //   child: CupertinoActivityIndicator(color: AppColors.primary)),
          //   ) : null,
          // );
        });
      }).toList(),
    );
  }
}
