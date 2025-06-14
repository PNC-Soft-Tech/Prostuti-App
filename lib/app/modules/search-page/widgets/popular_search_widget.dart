import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../constant/app_color.dart';

class PopularSearchWidget extends StatelessWidget {
  const PopularSearchWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          // Title text with no left padding/margin
          Row(
            children: [
              Text(
                'Popular Search',
                textAlign: TextAlign.left,
                style: GoogleFonts.inter(
                    textStyle: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w400,
                        color: Colors.black)),
              )
            ],
          ),
          SizedBox(height: 11.h),
          // Wrap to allow for flexible use of available space
          Wrap(
            spacing: 8.0,
            children: [
              popularSearchItem(text: "BCS Preliminary"),
              popularSearchItem(text: "PSEMHG Bangla"),
              popularSearchItem(text: "Mathematics"),
              popularSearchItem(text: "Global Science"),
              popularSearchItem(text: "DPDC English"),
            ],
          ),
        ],
      ),
    );
  }

  Widget popularSearchItem({required String text}) => Chip(
        backgroundColor: AppColors.primaryOpacity,
        shadowColor: AppColors.primaryOpacity,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50.0),
          side: const BorderSide(color: AppColors.primaryOpacity),
        ),
        label: Container(
          padding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 8.w),
          child: Text(
            text,
            style: GoogleFonts.inter(
                textStyle: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w500,
                    color: Colors.black)),
          ),
        ),
      );
}
