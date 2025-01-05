import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../controllers/exam-type-controller.dart';
import 'exam-category-widget.dart';

class ExamCategoriesWidget extends GetWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            const Text("Exam Categories"),
          ],
        ),
        SizedBox(
          height: 15.h,
        ),
        SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                ExamCategoryWidget(
                  title: "BCS",
                  image: 'assets/govt-bd.png',
                ),
                ExamCategoryWidget(
                  title: "NTRCA",
                  image: 'assets/ntrca.png',
                ),
                ExamCategoryWidget(
                  title: "PSEMHG",
                  image: 'assets/primary.png',
                ),
                ExamCategoryWidget(
                  title: "DPDC",
                  image: 'assets/dpdc.png',
                ),
              ],
            ))
      ],
    );
  }
}
