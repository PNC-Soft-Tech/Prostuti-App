import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../constant/app_color.dart';
import '../controller/search_controller.dart';

class PopularSearchWidget extends StatelessWidget {
  const PopularSearchWidget({super.key});

  static const _items = <String>[
    'BCS Preliminary',
    'PSEMHG Bangla',
    'Mathematics',
    'Global Science',
    'DPDC English',
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              Icons.trending_up_rounded,
              size: 18.sp,
              color: AppColors.primary,
            ),
            SizedBox(width: 6.w),
            Text(
              'Popular searches',
              style: GoogleFonts.inter(
                fontSize: 15.sp,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimaryColor,
                letterSpacing: -0.2,
              ),
            ),
          ],
        ),
        SizedBox(height: 12.h),
        Wrap(
          spacing: 8.w,
          runSpacing: 8.h,
          children: [
            for (final term in _items) _PopularChip(label: term),
          ],
        ),
      ],
    );
  }
}

class _PopularChip extends StatelessWidget {
  final String label;

  const _PopularChip({required this.label});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.primaryOpacity,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(50.r),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(50.r),
        onTap: () {
          final controller = Get.find<SearchPageController>();
          controller.searchController.text = label;
          controller.searchController.selection = TextSelection.fromPosition(
            TextPosition(offset: label.length),
          );
        },
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
          child: Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 13.sp,
              fontWeight: FontWeight.w500,
              color: AppColors.primary,
              letterSpacing: -0.1,
            ),
          ),
        ),
      ),
    );
  }
}
