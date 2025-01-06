import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/exam-type-controller.dart';

class ExamTypeView extends StatelessWidget {
  const ExamTypeView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ExamTypeController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Exam Types'),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        if (controller.examTypes.isEmpty) {
          return const Center(child: Text('No exam types found.'));
        }
        return ListView.builder(
          itemCount: controller.examTypes.length,
          itemBuilder: (context, index) {
            final type = controller.examTypes[index];
            return ListTile(
              title: Text(type.title),
              subtitle: Text('Slug: ${type.slug}'),
            );
          },
        );
      }),
    );
  }
}
