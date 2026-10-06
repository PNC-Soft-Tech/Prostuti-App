import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../constant/app_color.dart';
import '../controller/search_controller.dart';

class SearchInputWidget extends GetWidget<SearchPageController> {
  const SearchInputWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF4F6F9),
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(
          color: AppColors.lightGray.withValues(alpha: 0.35),
          width: 1,
        ),
      ),
      child: TextField(
        controller: controller.searchController,
        style: GoogleFonts.inter(
          fontSize: 14.sp,
          fontWeight: FontWeight.w500,
          color: AppColors.textPrimaryColor,
        ),
        cursorColor: AppColors.primary,
        textInputAction: TextInputAction.search,
        decoration: InputDecoration(
          hintText: 'Search exams, topics, contests…',
          hintStyle: GoogleFonts.inter(
            fontSize: 14.sp,
            fontWeight: FontWeight.w400,
            color: AppColors.gray,
          ),
          isDense: true,
          contentPadding:
              EdgeInsets.symmetric(horizontal: 14.w, vertical: 16.h),
          prefixIcon: Padding(
            padding: EdgeInsets.only(left: 14.w, right: 10.w),
            child: Icon(
              Icons.search_rounded,
              color: AppColors.gray,
              size: 20.sp,
            ),
          ),
          prefixIconConstraints:
              const BoxConstraints(minWidth: 0, minHeight: 0),
          suffixIcon: ValueListenableBuilder<TextEditingValue>(
            valueListenable: controller.searchController,
            builder: (context, value, _) {
              if (value.text.isEmpty) return const SizedBox.shrink();
              return IconButton(
                splashRadius: 18,
                tooltip: 'Clear',
                icon: Icon(
                  Icons.close_rounded,
                  color: AppColors.gray,
                  size: 18.sp,
                ),
                onPressed: () => controller.searchController.clear(),
              );
            },
          ),
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
        ),
      ),
    );
  }
}
