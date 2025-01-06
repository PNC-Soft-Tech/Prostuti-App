import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import 'exam_topic_widget.dart';

class ExamTopicsWidget extends GetWidget {
  const ExamTopicsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Text("Exam Topics",
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
              children: [
                ExamTopicWidget(
                  title: "Bangla",
                  image: 'assets/bangla.png',
                ),
                ExamTopicWidget(
                  title: "Math",
                  image: 'assets/math.png',
                ),
                ExamTopicWidget(
                  title: "English",
                  image: 'assets/english.png',
                ),
                ExamTopicWidget(
                  title: "Science",
                  image: 'assets/science.png',
                ),
                ExamTopicWidget(
                  title: "GK",
                  image: 'assets/gk.png',
                ),
              ],
            ))
      ],
    );
  }
}
