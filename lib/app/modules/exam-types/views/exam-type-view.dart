import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/exam-type-controller.dart';


class ExamTypeView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ExamTypeController>();

    return Scaffold(
      appBar: AppBar(
        title: Text('Exam Types'),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        }
        if (controller.examTypes.isEmpty) {
          return Center(child: Text('No exam types found.'));
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
