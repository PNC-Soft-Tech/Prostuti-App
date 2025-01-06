import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../contests/widgets/contest_card_home_page_widget.dart';
import '../../custom-exam/widgets/custom_exam_home_card_widget.dart';
import '../../exam-topics/widgets/exam_topics_widget.dart';
import '../../exam-types/widgets/exam-categories-widget.dart';
import '../../job-circulars/widgets/job_circular_home_widget.dart';
import '../../model_tests/widgets/model_test_home_widget.dart';

class HomeMainWidget extends GetWidget {
   HomeMainWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return  Container(
      padding: EdgeInsets.symmetric(horizontal: 19.w),
      margin: EdgeInsets.symmetric(vertical: 10.h),
      child: Column(
        children: [
          ContestHomeCardWidget(),
          SizedBox(height: 23.h),
          ExamCategoriesWidget(),
               SizedBox(height: 23.h),
          ExamTopicsWidget(),
               SizedBox(height: 23.h),
          ModelTestHomeWidget(),
               SizedBox(height: 23.h),
          CustomExamHomeCardWidget(),
               SizedBox(height: 23.h),
          JobCircularHomeWidget(),
        ],
      ),
    );
  } 


}