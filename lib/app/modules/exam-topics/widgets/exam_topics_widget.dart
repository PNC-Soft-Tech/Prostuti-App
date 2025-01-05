import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'exam_topic_widget.dart';


class ExamTopicsWidget extends GetWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            const Text("Exam Topics"),
          ],
        ),
        SizedBox(
          height: 15.h,
        ),
        SingleChildScrollView(
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
