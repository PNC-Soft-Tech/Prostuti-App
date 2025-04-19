import 'package:flutter/material.dart';
import 'package:get/get.dart';
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

          return ListTile(
            title: Text(option.toString()),
            leading: Radio<String>(
              value: optionOrder,
              groupValue: controller.selectedAnswers[questionId],
              onChanged: isLoading ? null : (String? value) async {
                if (value != null) {
                  controller.selectOption(questionId, value);
                  
                  // Submit the answer immediately after selection
                  debugPrint('Calling submitAnswer with:'
                      '\nquestionId: $questionId'
                      '\ncontestId: $contestId'
                      '\nvalue: $value');
                      
                  final success = await controller.submitAnswer(
                    questionId,
                    contestId,
                    value,
                  );
                  
                  debugPrint('Submit answer result: $success');
                }
              },
            ),
            trailing: isLoading ? const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(strokeWidth: 2),
            ) : null,
          );
        });
      }).toList(),
    );
  }
}
