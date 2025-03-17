import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:prostuti/app/constant/app_color.dart';

class ModelTestHomeCard extends GetWidget {
  final String? title;
  final String? image;
  final String? topics;
  final String? duration;
  final String? marks;
  const ModelTestHomeCard(
      {super.key,
      this.title,
      this.image,
      this.marks,
      this.duration,
      this.topics});
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 200.w,
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 13.h),
          margin: EdgeInsets.only(right: 8.w),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.r),
              color: AppColors.primaryOpacity,
              border: Border.all(color: Colors.white, width: 1)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Image.asset(image ?? ''),
                  SizedBox(
                    width: 8.w,
                  ),
                  Text(
                    title ?? 'NTRCA Exam',
                    style: GoogleFonts.notoSansBengali(
                        textStyle: TextStyle(
                            fontSize: 15.sp, fontWeight: FontWeight.w400)),
                  )
                ],
              ),
              SizedBox(
                height: 15.h,
              ),
              Text(
                topics ?? '',
                style: GoogleFonts.notoSansBengali(
                    textStyle: TextStyle(
                        fontSize: 15.sp, fontWeight: FontWeight.w600)),
              ),
              SizedBox(
                height: 10.h,
              ),
              Text(
                "${marks ?? ''} মার্কস",
                style: GoogleFonts.notoSansBengali(
                    textStyle: TextStyle(
                        fontSize: 16.sp, fontWeight: FontWeight.w600)),
              ),
              SizedBox(
                height: 10.h,
              ),
              Row(
                children: [
                  Image.asset('assets/countdown-black.png'),
                  SizedBox(
                    width: 6.w,
                  ),
                  Text(
                    '$duration',
                    style: GoogleFonts.notoSansBengali(
                        textStyle: TextStyle(
                            fontSize: 13.sp, fontWeight: FontWeight.w400)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
