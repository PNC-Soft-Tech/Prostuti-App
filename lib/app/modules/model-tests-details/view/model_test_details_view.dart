import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../common/widgets/shared_question_widget.dart';
import '../controllers/model_test_details_controller.dart';

class ModelTestDetailsView extends GetView<ModelTestDetailsController> {
  const ModelTestDetailsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Obx(() => Text(
              controller.modelDetails.value?.contest.name ?? 'Model Test',
              style: const TextStyle(fontSize: 18),
            )),
        actions: [
          // Navigation controls for flagged questions
          IconButton(
            icon: const Icon(Icons.navigate_before),
            onPressed: () {
              final currentQuestionId = controller.currentSelectedModelTestId.value;
              if (currentQuestionId != null) {
                final prevQuestion = controller.getPreviousVisibleQuestion(currentQuestionId);
                if (prevQuestion != null) {
                  controller.scrollToQuestion(prevQuestion);
                }
              }
            },
          ),
          IconButton(
            icon: const Icon(Icons.navigate_next),
            onPressed: () {
              final currentQuestionId = controller.currentSelectedModelTestId.value;
              if (currentQuestionId != null) {
                final nextQuestion = controller.getNextVisibleQuestion(currentQuestionId);
                if (nextQuestion != null) {
                  controller.scrollToQuestion(nextQuestion);
                }
              }
            },
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Obx(() => Text(
                    controller.formattedCountdownTime,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  )),
            ),
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final questions = controller.filteredQuestions;
        if (questions.isEmpty) {
          return const Center(child: Text('No questions available'));
        }

        return Column(
          children: [
            // Subject Filter
            if (controller.subjectLists.isNotEmpty) ...[
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: Row(
                  children: [
                    FilterChip(
                      label: const Text('All'),
                      selected: controller.selectedSubject.value == 'All',
                      onSelected: (_) => controller.selectSubject('All'),
                    ),
                    const SizedBox(width: 8),
                    ...controller.subjectLists.map((subject) => Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: FilterChip(
                            label: Text(subject),
                            selected: controller.selectedSubject.value == subject,
                            onSelected: (_) => controller.selectSubject(subject),
                          ),
                        )),
                  ],
                ),
              ),
            ],

            // Status Bar
            Container(
              padding: const EdgeInsets.all(8.0),
              color: Theme.of(context).cardColor,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Questions: ${questions.length}'),
                  Text('Marked: ${controller.markedQuestionIds.length}'),
                ],
              ),
            ),

            // Questions List
            Expanded(
              child: ListView.builder(
                controller: controller.scrollController,
                itemCount: questions.length,
                itemBuilder: (context, index) {
                  final question = questions[index];
                  return SharedQuestionWidget(
                    key: controller.questionKeys[question.id],
                    question: question,
                    contestId: controller.modelTestId.value,
                    index: index,
                  );
                },
              ),
            ),
          ],
        );
      }),
      bottomNavigationBar: Obx(() {
        if (controller.isSubmittingContest.value) {
          return const SizedBox(
            height: 60,
            child: Center(child: CircularProgressIndicator()),
          );
        }

        return SafeArea(
          child: Row(
            children: [
              // Show total marked questions
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Chip(
                  label: Text('Marked: ${controller.markedQuestionIds.length}'),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.all(8.0.w),
                  child: ElevatedButton(
                    onPressed: () => controller.submitContest(
                      controller.modelTestId.value,
                    ),
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(double.infinity, 50.h),
                    ),
                    child: const Text('Submit Test'),
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
