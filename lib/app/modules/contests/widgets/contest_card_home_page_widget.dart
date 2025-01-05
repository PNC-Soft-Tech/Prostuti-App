import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:prostuti/app/common/custom_buttons.dart';
import 'package:prostuti/app/constant/app_color.dart';
import 'package:prostuti/app/routes/app_pages.dart';

import '../../../common/custom_card.dart';
import '../../../common/models/contest_model.dart';

class ContestHomeCardWidget extends GetWidget {
  // final Contest contest;

  // ContestHomeCardWidget(this.contest);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        // onTap: ()=> Get.toNamed(Routes.singleContest(contest.id)),
        child: Container(
          padding:  EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
          margin:  EdgeInsets.symmetric(horizontal: 19.w),
          decoration: BoxDecoration(color: Color(0xFFE9F5FF), border: Border.all(width: 1,color: Color(0xFFE9F5FF) ), borderRadius: BorderRadius.circular(20.r)),
          child: Column(
            children: [
              Row(
                children: [
                  Text("Upcomming Contest", style: TextStyle(fontSize: 13,fontWeight: FontWeight.w400, fontFamily: 'Inter' ),),
                ],
              ),
              SizedBox(height: 10.h,),
              Container(
                // color: Colors.green,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Image.asset(
                                            'assets/govt-bd.png',
                                            height: 28,
                                            width: 28,
                                          ),
                                          SizedBox(width: 9.w,),
                    Expanded(
                        child: Text("বিসিএস কনটেস্ট-০১",
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w600)))
                  ],
                ),
              ),
              SizedBox(height: 11.h,),
              const Row(
                children: [
                  Expanded(
                      child: Text("গনিত - জ্যামিতি",
                          style: TextStyle(
                              fontSize: 15, fontWeight: FontWeight.w500)))
                ],
              ),
               Row(
                children: [
                  Expanded(
                      child: Row(
                        children: [
                         Icon(Icons.alarm,color: AppColors.primary), 
                         SizedBox(width: 6.w,),
                         Text("20: 30: 43", style: TextStyle(color: AppColors.primary, fontSize: 16.sp, fontWeight: FontWeight.w600),)
                        ],
                      )), CustomButton.button(text: "Register Now", onPressed: (){}, borderRadius: 50.r, isPrimary: true)
                ],
              ),
            ],
          ),
        ));
  }
}
