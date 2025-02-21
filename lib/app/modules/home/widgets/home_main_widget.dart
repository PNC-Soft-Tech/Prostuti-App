import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../contests/widgets/contest_cards_home_page_widget.dart';
import '../../custom-exam/widgets/custom_exam_home_card_widget.dart';
import '../../exam-topics/widgets/exam_topics_widget.dart';
import '../../exam-types/widgets/exam-categories-widget.dart';
import '../../job-circulars/widgets/job_circular_home_widget.dart';
import '../../model_tests/widgets/model_test_home_widget.dart';
import '../controller/home_controller.dart';

class HomeMainWidget extends GetWidget<HomeController> {
  const HomeMainWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      // padding: EdgeInsets.symmetric(horizontal: 19.w),
      margin: EdgeInsets.symmetric(vertical: 10.h),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Obx(() => Text(
                  'Hi  ${jsonDecode(jsonEncode(controller.userId.value))}',
                  style: TextStyle(fontSize: 16.sp),
                )),
            // CustomButton.button(
            //     text: "Logout",
            //     onPressed: () {
            //       Utils.logoutUser();
            //     }),
            // SizedBox(
            //   height: 10.h,
            // ),
            // CustomButton.button(
            //     text: "Dialog",
            //     onPressed: () {
            // Show a success modal with two buttons
// PostutiDialog.success(
//   "Operation completed successfully!",
//   isBottomButton: true,
//   noOfButtons: 2,
//   buttonLabels: ["OK", "Cancel"],
//   buttonActions: [
//     () => print("OK pressed"),
//     () => Get.back(),
//   ],
// );

// Show a warning modal with centered text and three buttons
            //   PostutiDialog.warning(
            //     "Are you sure you want to proceed?",
            //     isBottomButton: true,
            //     noOfButtons: 3,
            //     buttonLabels: ["Yes", "No", "Cancel"],
            //     buttonActions: [
            //       () => print("Yes pressed"),
            //       () => print("No pressed"),
            //       () => Get.back(),
            //     ],
            //   );
            // }),
            const ContestHomeCardsWrapperWidget(),
            SizedBox(height: 23.h),
            const ExamCategoriesWidget(),
            SizedBox(height: 23.h),
            const ExamTopicsWidget(),
            SizedBox(height: 23.h),
            const ModelTestHomeWidget(),
            SizedBox(height: 23.h),
            const JobCircularHomeWidget(),
            SizedBox(height: 23.h),
            const CustomExamHomeCardWidget()
          ],
        ),
      ),
    );
  }
}
