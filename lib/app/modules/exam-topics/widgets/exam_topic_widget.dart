import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class ExamTopicWidget extends GetWidget {
  final String? title;
  final String? image;
  const ExamTopicWidget({super.key, this.title, this.image});
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
            margin: EdgeInsets.symmetric(horizontal: 8.w),
            decoration: const ShapeDecoration(
                shape: CircleBorder(
                    side: BorderSide(color: Colors.grey, width: 1))),
            child: Container(
                padding: EdgeInsets.all(16.r),
                child: Image.asset(
                  image ?? "assets/govt-bd.png",
                  width: 38.w,
                  height: 38.h,
                ))),
        SizedBox(
          height: 6.h,
        ),
        Text(
          title ?? "BCS",
          style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500),
        ),
      ],
    );
  }
}
