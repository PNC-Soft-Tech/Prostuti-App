import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:prostuti/app/modules/history/view/history_view.dart';
import 'package:prostuti/app/modules/ranking/views/ranking_view.dart';

import '../../../common/widgets/bottom_nav_bar_widget.dart';
import '../../search-page/view/search_view.dart';
import '../controller/home_controller.dart';
import '../widgets/home_bottom_nav_more_bottom_sheet.dart';
import '../widgets/home_greeting_header.dart';
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
      backgroundColor: Colors.white,
      body: SafeArea(
        bottom: false,
        child: Obx(
          () {
            final isHome = controller.currentIndex.value == 0;
            return Column(
              children: [
                if (isHome) const HomeGreetingHeader(),
                Expanded(child: _pages[controller.currentIndex.value]),
              ],
            );
          },
        ),
      ),
      bottomNavigationBar: Obx(
        () => CustomBottomNavBar(
          currentIndex: controller.currentIndex.value,
          onTap: (value) {
            if (value == 4) {
              Get.bottomSheet(
                const HomeBottomNavMoreBottomSheet(),
                isScrollControlled: false,
                backgroundColor: Colors.white,
                ignoreSafeArea: false,
                isDismissible: true,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(24),
                  ),
                ),
              );
            } else if (value != controller.currentIndex.value) {
              controller.navigateToTab(value);
            }
          },
        ),
      ),
    );
  }
}
