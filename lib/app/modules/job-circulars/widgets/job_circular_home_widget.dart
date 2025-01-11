import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:prostuti/app/common/utils/prostuti_utils.dart';
import 'package:prostuti/app/constant/app_color.dart';

import '../controllers/job-circulars-controller.dart';
import '../models/job-circulars-model.dart';
import 'job_circular_card_home_widget.dart';

class JobCircularHomeWidget extends GetWidget<JobCircularController> {
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
          Obx(() => SizedBox(
            height: 235.h,
            child: ListView.builder(
                  reverse: false,
                  scrollDirection: Axis.horizontal,
                  itemCount: controller.jobCirculars.length,
                  itemBuilder: (context, index) {
                    JobCircular jobCircular = controller.jobCirculars[index];
                    return JobCircularHomeCard(
                      title: jobCircular.title,
                      type: "Government",
                      image: jobCircular.image,
                      loation: jobCircular.address,
                      eduationalQualification:
                          jobCircular.educationalQualification,
                      experience: jobCircular.experience,
                      deadline: Utils.formatDateToBangla(jobCircular.deadline),
                    );
                  },
                ),
          ))
        ],
      ),
    );
  }
}
