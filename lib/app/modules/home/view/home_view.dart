import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../common/custom_loading.dart';
import '../../contests/widgets/contest_card_home_page_widget.dart';
import '../controller/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Obx(() => Text(controller.title.value)),
      ),
      body: Column(children: [
        ContestHomeCardWidget(),
      ],)
    );
  }
}
