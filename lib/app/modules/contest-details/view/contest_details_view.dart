import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../common/widgets/shared_question_widget.dart';
import '../controller/contest_details_controller.dart';

class ContestDetailsView extends GetView<ContestDetailsController> {
  const ContestDetailsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Obx(() => Text(
              controller.contestDetails.value?.contest.name ?? 'Contest',
              style: const TextStyle(fontSize: 18),
            )),
        actions: [
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
            
            // Question Navigation
            Padding(
              padding: const EdgeInsets.all(8.0),
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
                    contestId: controller.contestId.value,
                    controller: controller, // Pass the controller instance
                  );
                },
              ),
            ),
          ],
        );
      }),
      
      // Submit Button
      bottomNavigationBar: Obx(() {
        if (controller.isSubmittingContest.value) {
          return const SizedBox(
            height: 60,
            child: Center(child: CircularProgressIndicator()),
          );
        }

        return SafeArea(
          child: Padding(
            padding: EdgeInsets.all(8.0.w),
            child: ElevatedButton(
              onPressed: () => controller.submitContest(controller.contestId.value),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 50.h),
              ),
              child: const Text('Submit Contest'),
            ),
          ),
        );
      }),
    );
  }
}
