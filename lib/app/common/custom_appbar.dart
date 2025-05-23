import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:prostuti/app/constant/app_color.dart';
import 'package:prostuti/app/routes/app_pages.dart';

import '../storage/storage_helper.dart';

class CustomAppBar {
  // Static method to create a custom app bar
  static PreferredSizeWidget appBar({
    required String title,
    bool centerTitle = true,
    Color? backgroundColor,
    Color? titleColor,
    String? name,
    List<Widget>? actions,
    IconData? leadingIcon,
    Widget? leadingWidget,
    double? leadingWidth,
    String? profilePicture,
    VoidCallback? onLeadingPressed,
  }) {
    return AppBar(
      scrolledUnderElevation: 0,
      leadingWidth: leadingWidth ?? 180,
      title: Text(
        title,
        style: TextStyle(
          color: titleColor ?? Colors.white,
          fontSize: 20.0,
          fontWeight: FontWeight.bold,
        ),
      ),
      centerTitle: centerTitle,
      backgroundColor: backgroundColor ?? AppColors.primary,
      automaticallyImplyLeading: true,
      actions: actions ??
          [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                    decoration: const ShapeDecoration(
                        shape: CircleBorder(
                            side: BorderSide(
                      color: Colors.grey,
                    ))),
                    child: CircleAvatar(
                      radius: 25,
                      backgroundColor: Colors.transparent,
                      child: SvgPicture.asset("assets/notification.svg"),
                    )),
                GestureDetector(
                  onTap: () {
                    Get.offAllNamed(Routes.profile);
                  },
                  child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 20.w),
                      decoration: const ShapeDecoration(
                          shape: CircleBorder(
                              side: BorderSide(
                        color: Colors.grey,
                      ))),
                      child: CircleAvatar(
                        radius: 25,
                        backgroundColor: Colors.transparent,                        child: FutureBuilder<String?>(
                          future: StorageHelper.getUserData(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              // Show loading indicator
                              return const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                ),
                              );
                            }
                            
                            if (snapshot.hasData && snapshot.data != null) {
                              try {
                                final userData = jsonDecode(snapshot.data!);
                                final userProfilePic = userData['profilePic'] as String?;
                                
                                if (userProfilePic != null && 
                                    userProfilePic.isNotEmpty && 
                                    userProfilePic != 'https://picsum.photos/id/1/200/300') {
                                  return ClipOval(
                                    child: Image.network(
                                      userProfilePic,
                                      width: 50,
                                      height: 50,
                                      fit: BoxFit.cover,
                                      loadingBuilder: (context, child, loadingProgress) {
                                        if (loadingProgress == null) return child;
                                        return const SizedBox(
                                          width: 20,
                                          height: 20,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                          ),
                                        );
                                      },
                                      errorBuilder: (context, error, stackTrace) {
                                        return SvgPicture.asset("assets/default-male.svg");
                                      },
                                    ),
                                  );
                                }
                              } catch (e) {
                                print('Error parsing profile picture: $e');
                              }
                            }
                            
                            // Fallback to provided profilePicture parameter or default
                            if (profilePicture != null && profilePicture.isNotEmpty) {
                              return ClipOval(
                                child: Image.network(
                                  profilePicture,
                                  width: 50,
                                  height: 50,
                                  fit: BoxFit.cover,
                                  loadingBuilder: (context, child, loadingProgress) {
                                    if (loadingProgress == null) return child;
                                    return const SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                      ),
                                    );
                                  },
                                  errorBuilder: (context, error, stackTrace) {
                                    return SvgPicture.asset("assets/default-male.svg");
                                  },
                                ),
                              );
                            }
                            
                            return SvgPicture.asset("assets/default-male.svg");
                          },
                        ),
                      )),
                ),
              ],
            )
          ],
      leading: leadingWidget ??
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SvgPicture.asset(
                  'assets/header-logo.svg',
                  // height: 47.h,
                  // width: 113.w,
                ),
                SizedBox(
                  height: 5.h,
                ),     
                // Text(
                //         'Hi ${name ?? "User"}!',
                //         style: TextStyle(
                //           fontSize: 16.sp,
                //           color: Colors.white,
                //           fontWeight: FontWeight.w500,
                //         ),
                //       ),           
                FutureBuilder<String?>(
                  future: StorageHelper.getUserData(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      // Show loading state with fallback name
                      return Text(
                        'Hi ${name ?? "User"}!',
                        style: TextStyle(
                          fontSize: 16.sp,
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                        ),
                      );
                    }
                    
                    if (snapshot.hasData && snapshot.data != null) {
                      try {
                        final userData = jsonDecode(snapshot.data!);
                        final fullName = userData['fullName'] as String?;
                        
                        if (fullName != null && fullName.isNotEmpty) {
                          return Text(
                            'Hi $fullName!',
                            style: TextStyle(
                              fontSize: 16.sp,
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                            ),
                          );
                        }
                      } catch (e) {
                        print('Error parsing user data in appbar: $e');
                      }
                    }
                    
                    // Fallback to provided name parameter or default
                    return Text(
                      'Hi ${name ?? "User"}!',
                      style: TextStyle(
                        fontSize: 16.sp,
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
    );
  }
}
