import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../contests/widgets/contest_card_home_page_widget.dart';
import '../../exam-types/widgets/exam-categories-widget.dart';
import '../controller/home_controller.dart';

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
          Expanded(child: ExamCategoriesWidget()),
        ],
      ),
    );
  } 


}