import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/job-category-controller.dart';


class JobCategoryView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final controller = Get.find<JobCategoryController>();

    return Scaffold(
      appBar: AppBar(
        title: Text('Job Categories'),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        }
        if (controller.jobCategories.isEmpty) {
          return Center(child: Text('No categories found.'));
        }
        return ListView.builder(
          itemCount: controller.jobCategories.length,
          itemBuilder: (context, index) {
            final category = controller.jobCategories[index];
            return ListTile(
              title: Text(category.name),
              subtitle: Text('Slug: ${category.slug}'),
            );
          },
        );
      }),
    );
  }
}
