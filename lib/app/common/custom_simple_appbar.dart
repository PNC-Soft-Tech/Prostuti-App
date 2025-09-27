import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:prostuti/app/constant/app_color.dart';

class CustomSimpleAppBar {
  // Static method to create a custom app bar
  static PreferredSizeWidget appBar({
    String? title,
    Widget? titleWidget, // ✅ Add this
    bool centerTitle = true,
    Color? backgroundColor,
    Color? titleColor,
    List<Widget>? actions,
    IconData? leadingIcon,
    Widget? leadingWidget,
    double? leadingWidth,
    VoidCallback? onLeadingPressed,
  }) {
    return AppBar(
        // leadingWidth: leadingWidth ?? 180,
        foregroundColor: Colors.white,
        title: centerTitle
            ? Center(
                child: titleWidget,
              )
            : titleWidget ?? // ✅ Use reactive title if provided
                Text(
                  title ?? "",
                  style: GoogleFonts.inter(
                    textStyle: TextStyle(
                      color: titleColor ?? AppColors.textPrimaryColor,
                      fontSize: 14.0.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
        centerTitle: centerTitle,
        backgroundColor: backgroundColor ?? Colors.white,
        automaticallyImplyLeading: true,
        actions: actions ?? [],
        leading: GestureDetector(
          onTap: () {
            Get.back();
          },
          child: Container(
              margin: EdgeInsets.symmetric(horizontal: 10.w),
              decoration: const ShapeDecoration(
                  shape: CircleBorder(
                      side: BorderSide(width: 1, color: AppColors.primary))),
              child: const Icon(
                Icons.arrow_back,
                color: AppColors.primary,
              )),
        ));
  }
}
