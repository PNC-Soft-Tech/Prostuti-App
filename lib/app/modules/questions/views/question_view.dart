import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../constant/app_color.dart';
import '../controller/question_controller.dart';
import '../widgets/question_widgets.dart';

class QuestionView extends GetView<QuestionController> {
  const QuestionView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Questions'),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CupertinoActivityIndicator(color: AppColors.primary ,));
        }

        if (controller.questions.isEmpty) {
          return const Center(child: Text('No questions available'));
        }

        return ListView.builder(
          itemCount: controller.questions.length,
          itemBuilder: (context, index) {
            return QuestionWidgetOld(controller.questions[index]);
          },
        );
      }),
    );
  }
}
