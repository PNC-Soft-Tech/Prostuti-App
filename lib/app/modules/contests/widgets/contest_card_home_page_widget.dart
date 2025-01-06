import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:prostuti/app/common/custom_buttons.dart';
import 'package:prostuti/app/constant/app_color.dart';

class ContestHomeCardWidget extends GetWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        // onTap: ()=> Get.toNamed(Routes.singleContest(contest.id)),
        child: Container(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
      // margin:  EdgeInsets.symmetric(horizontal: 19.w),
      decoration: BoxDecoration(
          color: Color(0xFFE9F5FF),
          border: Border.all(width: 1, color: Color(0xFFE9F5FF)),
          borderRadius: BorderRadius.circular(20.r)),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                "Upcomming Contest",
                style: GoogleFonts.inter(
                    textStyle: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w400,
                )),
              ),
            ],
          ),
          SizedBox(
            height: 10.h,
          ),
          Container(
            // color: Colors.green,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Image.asset(
                  'assets/govt-bd.png',
                  height: 28,
                  width: 28,
                ),
                SizedBox(
                  width: 9.w,
                ),
                Expanded(
                    child: Text("বিসিএস কনটেস্ট-০১",
                        style: GoogleFonts.notoSansBengali(
                            textStyle: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w600))))
              ],
            ),
          ),
          SizedBox(
            height: 11.h,
          ),
          Row(
            children: [
              Expanded(
                  child: Text("গনিত - জ্যামিতি",
                      style: GoogleFonts.notoSansBengali(
                          textStyle: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w600))))
            ],
          ),
          Row(
            children: [
              Expanded(
                  child: Row(
                children: [
                 Image.asset('assets/countdown.png'),
                  SizedBox(
                    width: 6.w,
                  ),
                  Text(
                    "20: 30: 43",
                    style: GoogleFonts.inter(textStyle: TextStyle(
                        color: AppColors.primary,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600)),
                  )
                ],
              )),
              CustomButton.button(
                  text: "Register Now",
                      fontSize: 13.sp,
                  fontWeight: FontWeight.w600,
                  onPressed: () {},
                  borderRadius: 50.r,
                  isPrimary: true)
            ],
          ),
        ],
      ),
    ));
  }
}
