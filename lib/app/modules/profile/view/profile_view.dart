import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:prostuti/app/common/custom_appbar.dart';
import 'package:prostuti/app/common/widgets/bottom_nav_bar_widget.dart';
import 'package:prostuti/app/modules/home/widgets/home_bottom_nav_more_bottom_sheet.dart';
import '../controllers/profile_controller.dart';

class ProfileView extends GetView<ProfileController> {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar.appBar(
          title: '',
          backgroundColor: Colors.white,
          // leadingWidth: 100,

          name: "Rahat"),
      body: Container(
          color: Colors.white,
          padding: EdgeInsets.symmetric(horizontal: 19.w, vertical: 10.h),
          child: const SingleChildScrollView(
              child: Column(children: [Text('Hello Profile')]))),
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
              } else {
                controller.currentIndex.value = value;
              }
            },
          )),
    );
  }
}
