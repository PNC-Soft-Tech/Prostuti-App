import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'exam-category-widget.dart';

class ExamCategoriesWidget extends GetWidget {
  const ExamCategoriesWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Text("Exam Categories",
                style: GoogleFonts.inter(
                  textStyle:
                      TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w400),
                )),
          ],
        ),
        SizedBox(
          height: 15.h,
        ),
        const SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
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
                ExamCategoryWidget(
                  title: "DPDC",
                  image: 'assets/dpdc.png',
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
