import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:prostuti/app/common/custom_buttons.dart';

class CustomExamHomeCardWidget extends GetWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20.sp),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(color: Color(0xFF212D404D))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "আপনার দক্ষতা উন্নত করুন!",
                style: GoogleFonts.notoSansBengali(
                    textStyle: TextStyle(
                        fontSize: 16.sp,
                        color: Colors.black,
                        fontWeight: FontWeight.bold)),
              ),
            ],
          ),
          SizedBox(
            height: 10.h,
          ),
          Center(
            child: Text(
              "কাস্টম পরীক্ষা দিয়ে আপনার প্রস্তুতিকে এগিয়ে নিন। কাস্টম পরীক্ষার মাধ্যমে আপনি নির্দিষ্ট বিষয় ও টপিকের উপর আপনার জ্ঞান বাড়াতে পারবেন।",
              style: GoogleFonts.notoSansBengali(
                  textStyle: TextStyle(
                fontSize: 14.sp,
                color: Color(0xFF212D40),
              )),
            ),
          ),
          SizedBox(
            height: 14.h,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomButton.button(
             
                  text: "Give a custom exam now", onPressed: () {}),
            ],
          )
        ],
      ),
    );
  }
}
