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
    // Ensure controller is initialized
    final profileController = Get.find<ProfileController>();
    
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar.appBar(
          title: '',
          backgroundColor: Colors.white,
          name: "Rahat"),
      body: Container(
          color: Colors.white,
          padding: EdgeInsets.symmetric(horizontal: 19.w, vertical: 10.h),
          child: SingleChildScrollView(
              child: Column(children: [
            const BorderedCircleAvatar(),
            SizedBox(height: 10.h),
            const ProgressCircle(progress: 0.4),
            SizedBox(height: 25.h),
            SettingsItem(
              title: 'Edit Profile',
              svgIcon: 'assets/profile/profile.svg',
              isProfileCompletionPercentageVisible: true,
              onTap: () {
                Get.toNamed(Routes.profileEdit);
              },
            ),
            SizedBox(height: 15.h),
            SettingsItem(
              title: 'Package',
              svgIcon: 'assets/profile/package.svg',
              isPackageInfoVisible: true,
              onTap: () {
                Get.toNamed(Routes.packageDetails);
              },
            ),
            SizedBox(height: 15.h),
            SettingsItem(
              title: 'App Settings',
              svgIcon: 'assets/profile/settings.svg',
              onTap: () {},
            ),
            SizedBox(height: 15.h),
            SettingsItem(
              title: 'Terms & Privacy',
              svgIcon: 'assets/profile/lock.svg',
              onTap: () {},
            ),
            SizedBox(height: 15.h),
            SettingsItem(
              title: 'Contact Us',
              svgIcon: 'assets/profile/headphone.svg',
              onTap: () {},
            ),
            SizedBox(height: 15.h),
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
                  isScrollControlled: false,
                  backgroundColor: Colors.white,
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
    return Obx(() {
      // Debug log for profile image URL
      final profilePicUrl = controller.userProfile.value?.profilePic;
      print("DEBUG: Profile Image URL in BorderedCircleAvatar: $profilePicUrl");
      
      return Center(
        child: controller.isLoadingProfilePic.value == true
            ? CupertinoActivityIndicator(color: AppColors.primary)
            : controller.userProfile.value?.profilePic != null
                ? CircleAvatar(
                    radius: 50.w,
                    backgroundColor: Colors.transparent,
                    child: ClipOval(
                      child: Builder(
                        builder: (context) {
                          final imageUrl = controller.userProfile.value!.profilePic;
                          print("DEBUG: Attempting to load image from URL: '$imageUrl'");
                          
                          // Validate URL before attempting to load
                          bool isValidUrl = true;
                          String errorMessage = "";
                          
                          try {
                            final uri = Uri.parse(imageUrl);
                            if (!uri.isAbsolute || (!uri.scheme.startsWith('http') && !uri.scheme.startsWith('https'))) {
                              isValidUrl = false;
                              errorMessage = "Invalid URI scheme: ${uri.scheme}";
                            }
                          } catch (e) {
                            isValidUrl = false;
                            errorMessage = "Invalid URL format: $e";
                          }
                          
                          if (!isValidUrl) {
                            print("DEBUG: Invalid image URL: '$imageUrl' - $errorMessage");
                            return SvgPicture.asset(
                              "assets/default-male.svg",
                              width: 70.w,
                              height: 70.h,
                            );
                          }
                          
                          // Add a cache key and timestamp to force refresh
                          final cacheKey = "$imageUrl?timestamp=${DateTime.now().millisecondsSinceEpoch}";
                          print("DEBUG: Using cache key: '$cacheKey'");
                          
                          return Image.network(
                            cacheKey,
                            width: 100.w,
                            height: 100.w,
                            fit: BoxFit.cover,
                            
                            // Set explicit caching options
                            cacheWidth: 300, // Cache at reasonable resolution
                            cacheHeight: 300,
                            
                            // Add HTTP headers to avoid caching issues
                            headers: {
                              "Cache-Control": "no-cache",
                              "Pragma": "no-cache",
                              "Expires": "0",
                            },
                            
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) {
                                print("DEBUG: Profile image loaded successfully from: '$imageUrl'");
                                return child;
                              }
                              print("DEBUG: Profile image loading from '$imageUrl': ${loadingProgress.cumulativeBytesLoaded}/${loadingProgress.expectedTotalBytes ?? 'unknown total'}");
                              return Center(
                                child: CircularProgressIndicator(
                                  color: AppColors.primary,
                                  value: loadingProgress.expectedTotalBytes != null
                                      ? loadingProgress.cumulativeBytesLoaded / 
                                        loadingProgress.expectedTotalBytes!
                                      : null,
                                ),
                              );
                            },
                            errorBuilder: (context, error, stackTrace) {
                              print("ERROR: Loading profile image from '$imageUrl' failed: $error");
                              print("ERROR: Stack trace: $stackTrace");
                              
                              // Try once more with direct URL without cache busting
                              if (cacheKey != imageUrl) {
                                print("DEBUG: Retrying with direct URL: '$imageUrl'");
                                return Image.network(
                                  imageUrl,
                                  width: 100.w,
                                  height: 100.w,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    print("ERROR: Second attempt failed: $error");
                                    return SvgPicture.asset(
                                      "assets/default-male.svg",
                                      width: 70.w,
                                      height: 70.h,
                                    );
                                  },
                                );
                              }
                              
                              return SvgPicture.asset(
                                "assets/default-male.svg",
                                width: 70.w,
                                height: 70.h,
                              );
                            },
                          );
                        },
                      ),
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
      );
    });
  }
}
