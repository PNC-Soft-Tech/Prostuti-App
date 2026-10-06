import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../constant/app_color.dart';
import '../controllers/job-category-controller.dart';

class JobCategoryView extends StatelessWidget {
  const JobCategoryView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<JobCategoryController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Job Categories'),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CupertinoActivityIndicator(color: AppColors.primary ,));
        }
        if (controller.jobCategories.isEmpty) {
          return const Center(child: Text('No categories found.'));
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
