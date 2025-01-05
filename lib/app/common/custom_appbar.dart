import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:prostuti/app/constant/app_color.dart';

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
            Container(
          
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                      decoration: ShapeDecoration(
                          shape: CircleBorder(
                              side: BorderSide(
                        color: Colors.grey,
                      ))),
                      child: CircleAvatar(
                        radius: 50,
                        backgroundColor: Colors.transparent,
                        child: SvgPicture.asset("assets/notification.svg"),
                      )),
                  Container(
                      decoration: ShapeDecoration(
                          shape: CircleBorder(
                              side: BorderSide(
                        color: Colors.grey,
                      ))),
                      child: CircleAvatar(
                        radius: 50,
                        backgroundColor: Colors.transparent,
                        child: profilePicture != null
                            ? Image.network(profilePicture)
                            : SvgPicture.asset("assets/default-male.svg"),
                      )),
                ],
              ),
            )
          ],
      leading: leadingWidget != null
          ? leadingWidget
          : Container(
              padding: EdgeInsets.symmetric(horizontal: 10.w),
              child: Column(
                children: [
                  SvgPicture.asset(
                    'assets/header-logo.svg',
                    // height: 47.h,
                    // width: 113.w,
                  ),
                  // SizedBox(
                  //   height: 10.h,
                  // ),
                  Text(
                    'Hi ${name ?? "Rahat"}!',
                    style: TextStyle(fontSize: 16.sp),
                  )
                ],
              ),
            ),
    );
  }
}
