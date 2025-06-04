import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:prostuti/app/constant/app_color.dart';

import '../../../routes/app_pages.dart';
import '../../model-tests-details/widgets/model_test_access_mode_bottomsheet.dart';
import '../controller/model_test_controller.dart';
import 'model_test_home_card.dart';

class ModelTestHomeWidget extends GetWidget<ModelTestController> {
  const ModelTestHomeWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 0.w, vertical: 16.w),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(color: const Color(0xff212d404d), width: 1)),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Model Tests",
                    style: GoogleFonts.inter(
                      textStyle: TextStyle(
                          fontSize: 14.sp, fontWeight: FontWeight.w400),
                    )),
                GestureDetector(
                  onTap: () {
                    Get.toNamed(Routes.modelTestsList);
                  },
                  child: Text("View All",
                      style: GoogleFonts.inter(
                        textStyle: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w400,
                            color: AppColors.primary),
                      )),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 10.h,
          ),
          // Text("model length: ${controller.model_tests.length}"),
          Obx(() => SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: controller.model_tests.asMap().entries.map((entry) {
                    int index = entry.key; // Access index here
                    var modelTest = entry.value; // Access modelTest object here
                    return GestureDetector(
                      onTap: () async {
                        // Access the index here if needed
                        print("Clicked on item at index: $index");

                        await Get.bottomSheet(
                          ModelTestAccessBottomSheet(
                            modelTestId: modelTest.id,
                          ),
                          backgroundColor: Colors.transparent,
                          isDismissible: true,
                        );
                      },
                      child: Padding(
                        padding: index == 0
                            ? EdgeInsets.only(left: 16.w, right: 8.w)
                            : index == controller.model_tests.length - 1
                                ? EdgeInsets.only(left: 8.w, right: 16.w)
                                : EdgeInsets.symmetric(horizontal: 8.w),
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
