import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../common/custom_appbar.dart';
import '../controller/single_contest_controller.dart';


class SingleContestView extends GetView<SingleContestController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar.appBar(title: "Contest Details", leadingIcon: Icons.backpack),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final contest = controller.contest.value;
        if (contest == null) {
          return const Center(child: Text('Contest not found'));
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(contest.name, style: const TextStyle(fontSize: 24)),
              const SizedBox(height: 8),
              Text(contest.description),
              const SizedBox(height: 16),
              Text('Total Marks: ${contest.totalMarks}'),
              Text('Total Time: ${contest.totalTime} minutes'),
              const SizedBox(height: 16),
              ...contest.questions.map((question) {
                return ListTile(
                  title: Text(question.title),
                  subtitle: Text('Answer: ${question.rightAnswer}'),
                );
              }).toList(),
            ],
          ),
        );
      }),
    );
  }
}
