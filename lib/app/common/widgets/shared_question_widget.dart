import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/base_question_controller.dart';
import '../../modules/questions/models/question_model.dart';

class SharedQuestionWidget extends StatelessWidget {
  final Question question;
  final String contestId;
  final bool showFlagButton;
  final BaseQuestionController? controller;

  SharedQuestionWidget({
    Key? key,
    required this.question,
    required this.contestId,
    this.showFlagButton = true,
    this.controller,
  }) : super(key: key);

  final loadingOptionIndex = RxnInt();

  @override
  Widget build(BuildContext context) {
    final ctrl = controller != null
        ? controller!
        : Get.isRegistered<BaseQuestionController>()
            ? Get.find<BaseQuestionController>()
            : throw Exception('No question controller found');

    return Card(
      margin: const EdgeInsets.all(8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    question.title ?? 'No question text',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                if (showFlagButton) ...[
                  const SizedBox(width: 8),
                  Obx(() {
                    final isMarked = ctrl.isMarkedQuestion(question.id);
                    return IconButton(
                      icon: Icon(
                        isMarked ? Icons.flag : Icons.flag_outlined,
                        color: isMarked ? Colors.red : Colors.grey,
                      ),
                      onPressed: () {
                        ctrl.markUnmarkQuestion(question.id);
                        debugPrint('Question ${question.id} marked: $isMarked');
                      },
                    );
                  }),
                ],
              ],
            ),
            const SizedBox(height: 16),
            if (question.options != null && question.options!.isNotEmpty)
              Column(
                children: List.generate(
                  question.options!.length,
                  (index) => Obx(() {
                    final isSelected = ctrl.isOptionSelected(
                      question.id,
                      question.options![index].order,
                    );

                    return ListTile(
                      title: loadingOptionIndex.value == index
                          ? const CupertinoActivityIndicator()
                          : Text(question.options![index].title),
                      tileColor: isSelected ? Colors.blue.withOpacity(0.1) : null,
                      onTap: loadingOptionIndex.value != null
                          ? null
                          : () async {
                              try {
                                loadingOptionIndex.value = index;
                                await ctrl.submitAnswer(
                                  question.id,
                                  contestId,
                                  ctrl.getOptionAns(index + 1),
                                );
                              } catch (e) {
                                Get.snackbar(
                                  'Error',
                                  'Failed to submit answer',
                                  snackPosition: SnackPosition.BOTTOM,
                                );
                              } finally {
                                loadingOptionIndex.value = null;
                              }
                            },
                    );
                  }),
                ),
              )
            else
              const Text('No options available'),
            const SizedBox(height: 8),
            if (question.topic?.subject != null) ...[
              const Divider(),
              Text(
                'Subject: ${question.topic?.subject?.name ?? "Unknown"}',
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
