import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../common/utils/prostuti_utils.dart';
import '../../../constant/app_color.dart';
import '../controller/contest_details_controller.dart';
import 'contest_details_widget.dart';
import 'contest_status_widget.dart';

class ContestPreviewWidget extends GetWidget<ContestDetailsController> {
  const ContestPreviewWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (!controller.isQuestionOpened.value)
          Container(
            padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    controller.contestDetails.value?.contest.imageUrl != null &&
                            controller.contestDetails.value!.contest.imageUrl!
                                .contains('http')
                        ? Image.network(
                            controller.contestDetails.value?.contest.imageUrl ??
                                '',
                            height: 34.r,
                            width: 34.r,
                          )
                        : Image.asset(
                            'assets/govt-bd.png',
                            height: 34.r,
                            width: 34.r,
                          ),
                    SizedBox(
                      width: 12.w,
                    ),
                    // Text("Mode: ${controller.currentQuestionIndex}"),
                    // HtmlWidget(
                    //     controller.contestDetails.value?.contest.name ??
                    //         "Model Test -০১")
                    Flexible(
                      child: Text(
                        Utils.stripHtmlTags(
                            controller.contestDetails.value?.contest.name ??
                                "বিসিএস কনটেস্ট-০১"),
                        style: GoogleFonts.notoSansBengali(
                            textStyle: TextStyle(
                          fontSize: 20.sp,
                          color: AppColors.textPrimaryColor,
                          fontWeight: FontWeight.w600,
                        )),
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: 19.h,
                ),
                Text(
                  Utils.stripHtmlTags(
                      " ${controller.contestDetails.value?.contest.stringTopics ?? 'গনিত - জ্যামিতি'}"),
                  style: GoogleFonts.notoSansBengali(
                      textStyle: TextStyle(
                    fontSize: 16.sp,
                    color: AppColors.textPrimaryColor,
                    fontWeight: FontWeight.w500,
                  )),
                ),
                SizedBox(
                  height: 16.h,
                ),

                const ContestStatusWidget(), // ✅ Displays running or countdown UI
                SizedBox(
                  height: 21.h,
                ),
                Text(
                  Utils.stripHtmlTags(
                      controller.contestDetails.value?.contest.description ??
                          "বিসিএস কনটেস্ট-০১ desc"),
                  style: GoogleFonts.notoSansBengali(
                      textStyle: TextStyle(
                    fontSize: 15.sp,
                    color: AppColors.textPrimaryColor,
                    fontWeight: FontWeight.w400,
                  )),
                ),
                SizedBox(
                  height: 27.h,
                ),
                const ContestDetailsWidget(),
              ],
            ),
          ),
        if (controller.contestDetails.value?.contest.isSubmitted == true &&
            !controller.isQuestionOpened.value)
          Container(
            padding: EdgeInsets.all(16.w),
            margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8.r),
              border: Border.all(color: AppColors.primary.withOpacity(0.3)),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.check_circle,
                  color: AppColors.primary,
                  size: 24.r,
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Contest Submitted Successfully!',
                        style: GoogleFonts.notoSansBengali(
                          textStyle: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        'You have already submitted this contest. Check the leaderboard for your position.',
                        style: GoogleFonts.notoSansBengali(
                          textStyle: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w400,
                            color: AppColors.textPrimaryColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
