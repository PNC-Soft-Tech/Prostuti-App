import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:prostuti/app/modules/history/view/history_view.dart';
import 'package:prostuti/app/modules/ranking/views/ranking_view.dart';
import '../../../common/custom_appbar.dart';
import '../../../common/widgets/bottom_nav_bar_widget.dart';
import '../../search-page/view/search_view.dart';
import '../controller/home_controller.dart';
import '../widgets/home_bottom_nav_more_bottom_sheet.dart';
import '../widgets/home_main_widget.dart';

class HomeView extends GetView<HomeController> {
  HomeView({super.key});

  final List<Widget> _pages = [
    const HomeMainWidget(),
    const SearchView(),
    RankingView(),
    const HistoryView(),
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
      body: Obx(() => Container(
          padding: EdgeInsets.fromLTRB(19.w, 0, 19.w, 0),
          color: Colors.white,
          child: _pages[controller.currentIndex.value])),
      bottomNavigationBar: Obx(() => CustomBottomNavBar(
            currentIndex: controller.currentIndex.value,
            onTap: (value) {
              if (value == 4) {
                Get.bottomSheet(
                  const HomeBottomNavMoreBottomSheet(),
                  isScrollControlled:
                      false, // Optional, to allow for full-screen or scrollable content
                  backgroundColor: Colors
                      .white, // Optional, background color for the bottom sheet
                  ignoreSafeArea: false,
                  isDismissible: true,
                );
              } else if (value == controller.currentIndex.value) {
                // Already on this tab, no action needed
              } else {
                controller.navigateToTab(value);
              }
            },
          )),
    );
  }
}
