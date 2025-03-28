import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:prostuti/app/constant/app_color.dart';

import '../../../routes/app_pages.dart';
import '../../contests/models/contest_model.dart';
import '../controller/model_test_controller.dart';
import '../models/model_test_model.dart';
import 'model_test_home_card.dart';

class ModelTestHomeWidget extends GetWidget<ModelTestController> {
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
          // Text("model length: ${controller.model_tests.length}"),
          Obx(() => SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: controller.model_tests.map((modelTest) {
                    return GestureDetector(
                      onTap: () {
                     
                        Get.toNamed(Routes.modelTestDetails, arguments: {"modelTestId": modelTest.id});
                      },
                      child: Padding(
                        padding: EdgeInsets.only(right: 12.w),
                        child: ModelTestHomeCard(
                          title: modelTest.name ?? "NTRCA পরীক্ষা",
                          image: modelTest.imageUrl ?? 'assets/ntrca.png',
                          marks: modelTest.totalMarks?.toString() ?? "৫০",
                          duration: "${modelTest.totalTime} মিনিট",
                          topics: modelTest.stringTopics ?? "বাংলা - শব্দতত্ব",
                        ),
                      ),
                    );
                  }).toList(),
                ),
              )),
        ],
      ),
    );
  }
}
