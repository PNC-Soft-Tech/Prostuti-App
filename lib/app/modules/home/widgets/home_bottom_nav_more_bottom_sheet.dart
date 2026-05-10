import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../common/custom_buttons.dart';
import '../../../constant/app_color.dart';
import '../../../routes/app_pages.dart';

class HomeBottomNavMoreBottomSheet extends StatelessWidget {
  const HomeBottomNavMoreBottomSheet({super.key});

  static const _items = <_MoreItem>[
    _MoreItem(name: 'All Contests', image: 'assets/all-contests.png'),
    _MoreItem(name: 'Model Tests', image: 'assets/model-tests.png'),
    _MoreItem(name: 'Job Alerts', image: 'assets/job-alerts.png'),
    _MoreItem(name: 'Question Bank', image: 'assets/question-banks.png'),
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 24.h),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
            child: Container(
              width: 44.w,
              height: 4.h,
              decoration: BoxDecoration(
                color: AppColors.lightGray.withValues(alpha: 0.6),
                borderRadius: BorderRadius.circular(4.r),
              ),
            ),
          ),
          SizedBox(height: 18.h),
          Text(
            'More',
            style: GoogleFonts.inter(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimaryColor,
            ),
          ),
          SizedBox(height: 16.h),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 4,
            mainAxisSpacing: 12.h,
            crossAxisSpacing: 12.w,
            childAspectRatio: 0.85,
            children: [
              for (final item in _items) _MoreTile(item: item),
            ],
          ),
          SizedBox(height: 20.h),
          CustomButton.button(
            image: 'assets/give-custom-exam-button.svg',
            isSvgImage: true,
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
            text: 'Give A Custom Exam Now',
            mainAxisSize: MainAxisSize.max,
            onPressed: () {
              Get.back();
              Get.toNamed(Routes.customExam);
            },
          ),
        ],
      ),
    );
  }
}

class _MoreItem {
  final String name;
  final String image;
  const _MoreItem({required this.name, required this.image});
}

class _MoreTile extends StatelessWidget {
  final _MoreItem item;

  const _MoreTile({required this.item});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {},
        borderRadius: BorderRadius.circular(14.r),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 8.w),
          decoration: BoxDecoration(
            color: AppColors.primaryOpacity,
            borderRadius: BorderRadius.circular(14.r),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                item.image,
                width: 32.w,
                height: 32.w,
              ),
              SizedBox(height: 8.h),
              Text(
                item.name,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.inter(
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textPrimaryColor,
                  height: 1.2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
