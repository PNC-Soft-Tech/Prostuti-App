import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/job-circulars-controller.dart';

class JobCircularView extends StatelessWidget {
  final JobCircularController controller = Get.put(JobCircularController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Job Circulars"),
      ),
      body: Obx(
        () => controller.isLoading.value
            ? Center(child: CircularProgressIndicator())
            : ListView.builder(
                itemCount: controller.jobCirculars.length,
                itemBuilder: (context, index) {
                  final job = controller.jobCirculars[index];
                  return Card(
                    child: ListTile(
                      title: Text(job.title),
                      subtitle: Text(job.company),
                      trailing: Text("Deadline: ${job.deadline.toLocal().toString().split(' ')[0]}"),
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
