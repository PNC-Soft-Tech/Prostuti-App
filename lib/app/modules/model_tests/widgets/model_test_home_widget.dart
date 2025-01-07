import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:prostuti/app/constant/app_color.dart';

import 'model_test_home_card.dart';

class ModelTestHomeWidget extends GetWidget {
  const ModelTestHomeWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 23.w, vertical: 18.h),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(color: const Color(0xff212d404d), width: 1)),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Model Tests",
                  style: GoogleFonts.inter(
                    textStyle:
                        TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w400),
                  )),
              Text("View All",
                  style: GoogleFonts.inter(
                    textStyle: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w400,
                        color: AppColors.primary),
                  )),
            ],
          ),
          SizedBox(
            height: 18.h,
          ),
          const SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  ModelTestHomeCard(
                    title: "NTRCA পরীক্ষা",
                    image: 'assets/ntrca.png',
                    marks: "৫০",
                    duration: "৩০ মিনিট",
                    topics: "বাংলা - শব্দতত্ব",
                  ),
                  ModelTestHomeCard(
                    title: "BRDP পরীক্ষা",
                    image: 'assets/brdp.png',
                    marks: "৫০",
                    duration: "৩০ মিনিট",
                    topics: "গনিত - জ্যামিতি",
                  ),
                ],
              ))
        ],
      ),
    );
  }
}
