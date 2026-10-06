import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:prostuti/app/constant/app_color.dart';

class CustomStyles {
  static TextStyle textStyle = const TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: AppColors.blueGray,
  );

  static TextStyle textStyleLg = const TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w500,
    color: AppColors.blueGray,
  );

  static ButtonStyle buttonStyle = ElevatedButton.styleFrom(
    backgroundColor: AppColors.primary,
    padding: EdgeInsets.symmetric(vertical: 20.h),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(30.r),
    ),
  );

  static InputDecoration inputDecoration(String labelText, String hintText) {
    return InputDecoration(
      labelText: labelText,
      hintText: hintText,
      contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      border: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(30)),
      ),
      enabledBorder: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(30)),
        borderSide: BorderSide(color: AppColors.blueGray, width: 1),
      ),
      focusedBorder: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(30)),
        borderSide: BorderSide(color: AppColors.primary, width: 2),
      ),
    );
  }

  static InputDecoration profileInputDecoration(String hintText) {
    return inputDecoration(hintText, hintText).copyWith(
      hintStyle: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.normal),
      labelStyle: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.normal),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      floatingLabelBehavior: FloatingLabelBehavior.never,
      enabledBorder: OutlineInputBorder(
        borderRadius: const BorderRadius.all(Radius.circular(30)),
        borderSide:
            BorderSide(color: AppColors.blueGray.withOpacity(0.4), width: 0.5),
      ),
      focusedBorder: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(30)),
        borderSide: BorderSide(color: AppColors.primary, width: 0.5), //
      ),
      isDense: true,
    );
  }
}
