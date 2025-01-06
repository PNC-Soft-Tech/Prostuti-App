import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:prostuti/app/modules/home/widgets/ranking_view.dart';
import '../../../common/custom_appbar.dart';
import '../../../common/widgets/bottom_nav_bar_widget.dart';
import '../controller/home_controller.dart';
import '../widgets/home_main_widget.dart';

class HomeView extends GetView<HomeController> {
  HomeView({super.key});

  final List<Widget> _pages = [
    HomeMainWidget(),
    const Center(child: Text('Search Page')),
    const RankingView(),
    const Center(child: Text('History Page')),
    const Center(child: Text('More Page')),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar.appBar(
          title: '',
          backgroundColor: Colors.white,
          // leadingWidth: 100,

          name: "Rahat"),
      body: Obx(() =>
          SingleChildScrollView(child: _pages[controller.currentIndex.value])),
      bottomNavigationBar: Obx(() => CustomBottomNavBar(
            currentIndex: controller.currentIndex.value,
            onTap: (value) {
              controller.currentIndex.value = value;
            },
          )),
    );
  }
}
