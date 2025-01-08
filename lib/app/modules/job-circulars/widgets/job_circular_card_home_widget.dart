import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class JobCircularHomeCard extends GetWidget {
  final String? title;
  final String? type;
  final String? loation;
  final String? eduationalQualification;
  final String? experience;
  final String? image;
  final String? deadline;

  const JobCircularHomeCard(
      {super.key,
      this.title,
      this.image,
      this.loation,
      this.type,
      this.eduationalQualification,
      this.experience,
      this.deadline});
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 315.w,
          padding: EdgeInsets.all(20.r),
          margin: EdgeInsets.only(right: 8.w),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.r),
              color: Colors.white,
              border: Border.all(color: Colors.white, width: 1)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Image.asset(
                    image ?? '',
                    width: 28.w,
                    height: 28.w,
                  ),
                  SizedBox(
                    width: 8.w,
                  ),
                  Text(
                    title ?? 'Assistant Accounts Officer',
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.notoSansBengali(
                        textStyle: TextStyle(
                            fontSize: 15.sp, fontWeight: FontWeight.w500)),
                  )
                ],
              ),
              SizedBox(
                height: 10.h,
              ),
              Text(
                type ?? '',
                style: GoogleFonts.notoSansBengali(
                    textStyle: TextStyle(
                        fontSize: 14.sp, fontWeight: FontWeight.w400)),
              ),
              SizedBox(
                height: 10.h,
              ),
              Row(
                children: [
                  Image.asset("assets/location.png"),
                  SizedBox(
                    width: 6.w,
                  ),
                  Text(
                    loation ?? 'Barishal',
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.notoSansBengali(
                        textStyle: TextStyle(
                            fontSize: 13.sp, fontWeight: FontWeight.w400)),
                  ),
                ],
              ),
              SizedBox(
                height: 10.h,
              ),
              Row(
                children: [
                  Image.asset('assets/eduQualification.png'),
                  SizedBox(
                    width: 6.w,
                  ),
                  Expanded(
                    child: Text(
                      '$eduationalQualification',
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.notoSansBengali(
                          textStyle: TextStyle(
                              fontSize: 13.sp, fontWeight: FontWeight.w400)),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 10.h,
              ),
              Row(
                children: [
                  Image.asset('assets/experience.png'),
                  SizedBox(
                    width: 6.w,
                  ),
                  Text(
                    '$experience',
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.notoSansBengali(
                        textStyle: TextStyle(
                            fontSize: 13.sp, fontWeight: FontWeight.w400)),
                  ),
                ],
              ),
              SizedBox(
                height: 10.h,
              ),
              Row(
                children: [
                  Image.asset('assets/deadline.png'),
                  SizedBox(
                    width: 6.w,
                  ),
                  Text(
                    'Deadline: $deadline',
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.notoSansBengali(
                        textStyle: TextStyle(
                            fontSize: 13.sp, fontWeight: FontWeight.w400)),
                  ),
                ],
              ),
              SizedBox(
                height: 10.h,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
