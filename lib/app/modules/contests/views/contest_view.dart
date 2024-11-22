import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/contest_controller.dart';
import '../widgets/contest_widget.dart';


class ContestView extends GetView<ContestController> {
  @override
  Widget build(BuildContext context) {
  

    return Scaffold(
      appBar: AppBar(
        title: const Text('Contests'),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.contests.isEmpty) {
          return const Center(child: Text('No contests available'));
        }

        return ListView.builder(
          itemCount: controller.contests.length,
          itemBuilder: (context, index) {
            return ContestWidget(controller.contests[index]);
          },
        );
      }),
    );
  }
}
