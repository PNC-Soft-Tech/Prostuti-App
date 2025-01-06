import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:prostuti/app/constant/app_color.dart';

import 'job_circular_card_home_widget.dart';

class JobCircularHomeWidget extends GetWidget {
  const JobCircularHomeWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width, // Full width
      margin: EdgeInsets.zero,
      padding: EdgeInsets.fromLTRB(20.w, 15.h, 20.w, 28.h),
      color: AppColors.primaryOpacity,
      // decoration: BoxDecoration(
      //   color: AppColors.primaryOpacity,
      //     // borderRadius: BorderRadius.circular(20.r),
      //     border: Border.alFl(color: Color(0xFF212D404D), width: 1)),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Job Alerts",
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
                  JobCircularHomeCard(
                    title: "Assistant Accounts Officer",
                    type: "Government",
                    image: 'assets/govt-bd.png',
                    loation: "Barishal",
                    eduationalQualification:
                        "B.Com (Preferable - M.Com/MBA) with m...",
                    experience: "At least 5 year(s)",
                    deadline: "6 Jan, 2025",
                  ),
                  JobCircularHomeCard(
                    title: "Assistant Accounts Officer",
                    type: "Government",
                    image: 'assets/govt-bd.png',
                    loation: "Barishal",
                    eduationalQualification:
                        "B.Com (Preferable - M.Com/MBA) with m...",
                    experience: "At least 5 year(s)",
                    deadline: "6 Jan, 2025",
                  ),
                ],
              ))
        ],
      ),
    );
  }
}
