import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:prostuti/app/constant/app_color.dart';

import '../../../common/custom_buttons.dart';
import '../../../routes/app_pages.dart';

class HomeBottomNavMoreBottomSheet extends StatelessWidget {
  const HomeBottomNavMoreBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 25.w, vertical: 25.h),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _item(name: "All Contests", image: "assets/all-contests.png"),
                _item(name: "Model Tests", image: "assets/model-tests.png"),
                _item(name: "Job Alerts", image: "assets/job-alerts.png"),
                _item(name: "Question Bank", image: "assets/question-banks.png"),
              ],
            ),
          ),
          SizedBox(
            height: 26.h,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomButton.button(
                  image: 'assets/give-custom-exam-button.svg',
                  isSvgImage: true,
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w500,
                  text: "Give A Custom Exam Now",
                  onPressed: () => Get.toNamed(Routes.customExam)),
            ],
          ), SizedBox(height: 30.h,),
        ],
      ),
    );
  }

  Widget _item(
          {required String name,
          required String image,
          VoidCallbackAction? onClick}) =>
      Container(
        margin: EdgeInsets.symmetric(horizontal: 17.5.w),
        child: GestureDetector(
          onTap: () => onClick,
          child: Column(
            children: [
              Image.asset(
                image,
                width: 28.w,
                height: 28.h,
              ),
              SizedBox(
                height: 8.h,
              ),
              Text(
                name,
                style: GoogleFonts.inter(
                    textStyle: TextStyle(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w400,
                  color: AppColors.textPrimaryColor
                )),
              )
            ],
          ),
        ),
      );
}
