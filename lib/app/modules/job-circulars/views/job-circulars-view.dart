import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../constant/app_color.dart';
import '../controllers/job-circulars-controller.dart';

class JobCircularView extends StatelessWidget {
  final JobCircularController controller = Get.put(JobCircularController());

  JobCircularView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Job Circulars"),
      ),
      body: Obx(
        () => controller.isLoading.value
            ? const Center(child: CupertinoActivityIndicator(color: AppColors.primary,))
            : ListView.builder(
                itemCount: controller.jobCirculars.length,
                itemBuilder: (context, index) {
                  final job = controller.jobCirculars[index];
                  return Card(
                    child: ListTile(
                      title: Text(job.title),
                      subtitle: Text(job.company),
                      trailing: Text(
                          "Deadline: ${job.deadline.toLocal().toString().split(' ')[0]}"),
                      onTap: () {
                        Get.snackbar("Job Link", job.link,
                            snackPosition: SnackPosition.BOTTOM);
                      },
                    ),
                  );
                },
              ),
      ),
    );
  }
}
