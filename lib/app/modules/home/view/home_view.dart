import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../common/custom_loading.dart';
import '../controller/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Obx(() => Text(controller.title.value)),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            showLoadingDialog();
            Future.delayed(const Duration(seconds: 2), () {
              Get.back(); // Close the loading dialog
              Get.snackbar('Success', 'Loading Complete!');
            });
          },
          child: const Text('Show Loading Dialog'),
        ),
      ),
    );
  }
}
