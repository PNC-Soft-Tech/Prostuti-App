import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../constant/app_color.dart';

class PopularSearchWidget extends StatelessWidget {
  const PopularSearchWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Text(
            'Popular Search',
            style: GoogleFonts.inter(
                textStyle: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w400,
                    color: Colors.black)),
          ),
          SizedBox(height: 11.h),
          Wrap(
            spacing: 8.0,
            runSpacing: 8.0,
            children: [
              popularSearchItem(text: "BCS Preliminary"),
              popularSearchItem(text: "PSEMHG Bangla"),
              popularSearchItem(text: "Mathematics"),
              popularSearchItem(text: "Global Science"),
              popularSearchItem(text: "DPDC English"),
            ],
          )
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
          padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 15.w),
          child: Text(
            text,
            style: GoogleFonts.inter(
                textStyle: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w400,
                    color: Colors.black)),
          ),
        ),
      );
}
