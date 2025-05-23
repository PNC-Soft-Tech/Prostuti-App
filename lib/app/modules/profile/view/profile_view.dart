import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:prostuti/app/common/custom_appbar.dart';
import 'package:prostuti/app/common/widgets/bottom_nav_bar_widget.dart';
import 'package:prostuti/app/constant/app_color.dart';
import 'package:prostuti/app/modules/home/widgets/home_bottom_nav_more_bottom_sheet.dart';
import 'package:prostuti/app/modules/profile/widgets/profile_settings_item.dart';
import 'package:prostuti/app/modules/profile/widgets/progress_circle.dart';
import 'package:prostuti/app/routes/app_pages.dart';
import '../../../common/utils/prostuti_utils.dart';
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
          child: SingleChildScrollView(
              child: Column(children: [
            const BorderedCircleAvatar(),
            SizedBox(
              height: 10.h,
            ),
            const ProgressCircle(
              progress: 0.4,
            ),
            // Text( controller.userProfile.value?.profilePic??'--'),
            SizedBox(
              height: 25.h,
            ),
            SettingsItem(
              title: 'Edit Profile',
              svgIcon: 'assets/profile/profile.svg',
              isProfileCompletionPercentageVisible: true,
              onTap: () {
                Get.toNamed(Routes.profileEdit);
              },
            ),
            SizedBox(
              height: 15.h,
            ),
            SettingsItem(
              title: 'Package',
              svgIcon: 'assets/profile/package.svg',
              isPackageInfoVisible: true,
              onTap: () {
                Get.toNamed(Routes.packageDetails);
              },
            ),
            SizedBox(
              height: 15.h,
            ),
            SettingsItem(
              title: 'App Settings',
              svgIcon: 'assets/profile/settings.svg',
              onTap: () {},
            ),
            SizedBox(
              height: 15.h,
            ),
            SettingsItem(
              title: 'Terms & Privacy',
              svgIcon: 'assets/profile/lock.svg',
              onTap: () {},
            ),
            SizedBox(
              height: 15.h,
            ),
            SettingsItem(
              title: 'Contact Us',
              svgIcon: 'assets/profile/headphone.svg',
              onTap: () {},
            ),
            SizedBox(
              height: 15.h,
            ),
            SettingsItem(
              title: 'Logout',
              svgIcon: 'assets/profile/logout.svg',
              isNavigationable: false,
              isLogout: true,
              onTap: () {
                Utils.logoutUser();
              },
            )
          ]))),
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
                controller.navigateToIndex(value);
              }
            },
          )),
    );
  }
}

class BorderedCircleAvatar extends GetView<ProfileController> {
  const BorderedCircleAvatar({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() => Center(
          child: controller.isLoadingProfilePic.value == true
              ? CupertinoActivityIndicator(color: AppColors.primary ,)
              : controller.userProfile.value?.profilePic != null
                  ? CircleAvatar(
                      radius: 50.w,
                      backgroundColor: Colors.transparent,
                      backgroundImage: NetworkImage(
                        controller.userProfile.value!.profilePic,
                      ),
                    )
                  : Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppColors.primary,
                          width: 3.w,
                        ),
                      ),
                      child: CircleAvatar(
                        radius: 50.w,
                        backgroundColor: Colors.transparent,
                        child: SvgPicture.asset(
                          "assets/default-male.svg",
                          width: 70.w,
                          height: 70.h,
                        ),
                      ),
                    ),
        ));
  }
}
