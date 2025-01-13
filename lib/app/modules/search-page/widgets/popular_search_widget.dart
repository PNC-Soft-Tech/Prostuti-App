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
          GridView.builder(
            gridDelegate:
                SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
            itemCount: 4,
            itemBuilder: (context, index) {
              return popularSearchItem(text: "BCS Preliminary");
            },
          )
        ],
      ),
    );
  }

  Widget popularSearchItem({required String text}) => Container(
        margin: EdgeInsets.fromLTRB(0, 0, 8.h, 8.h),
        padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 15.w),
        decoration: BoxDecoration(
            color: AppColors.primaryOpacity,
            borderRadius: BorderRadius.circular(50.r)),
        child: Text(
          "${text}",
          style: GoogleFonts.inter(
              textStyle: TextStyle(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w400,
                  color: Colors.black)),
        ),
      );
}
