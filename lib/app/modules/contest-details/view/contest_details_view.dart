import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:prostuti/app/common/custom_buttons.dart';
import 'package:prostuti/app/constant/app_color.dart';

import '../../../common/custom_simple_appbar.dart';
import '../../contests/controller/contest_controller.dart';
import '../controller/contest_details_controller.dart';

class ContestDetailsView extends GetView<ContestDetailsController> {
  const ContestDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomSimpleAppBar.appBar(title: "Contest Details"),
      // CustomAppBar.appBar(
      //     title: "Contest Details",
      //     leadingWidth: 80,
      //     titleColor: AppColors.textPrimaryColor,
      //     backgroundColor: Colors.white,
      //     actions: [],
      //     centerTitle: true,
      //     leadingWidget: Container(
      //         decoration: ShapeDecoration(
      //             shape: CircleBorder(
      //                 side: BorderSide(width: 1, color: AppColors.primary))),
      //         child: Icon(
      //           Icons.arrow_back,
      //           color: AppColors.primary,
      //         ))),
      body: Stack(
        children: [
          Obx(() {
            if (controller.isLoading.value) {
              return const Center(child: CircularProgressIndicator());
            } else {
              return Container(
                padding: EdgeInsets.symmetric(vertical: 18.h, horizontal: 18.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        controller.contestDetails.value?.contest.imageUrl !=
                                    null &&
                                controller
                                    .contestDetails.value!.contest.imageUrl!
                                    .contains('http')
                            ? Image.network(
                                controller.contestDetails.value?.contest
                                        .imageUrl ??
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
                        Text(
                          "${controller.contestDetails.value?.contest.name ?? "বিসিএস কনটেস্ট-০১3"}",
                          style: GoogleFonts.notoSansBengali(
                              textStyle: TextStyle(
                            fontSize: 20.sp,
                            color: AppColors.textPrimaryColor,
                            fontWeight: FontWeight.w600,
                          )),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 19.h,
                    ),
                    Text(
                      " ${controller.contestDetails.value?.contest.stringTopics ?? 'গনিত - জ্যামিতি'}",
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
                    Obx(() => DateTime.now().isBefore(controller
                            .contestDetails.value!.contest.startContest)
                        ? _alreadyRunning()
                        : _contestCountdown()),
                    SizedBox(
                      height: 22.h,
                    ),
                    Text(
                      "${controller.contestDetails.value?.contest.description}",
                      style: GoogleFonts.notoSansBengali(
                          textStyle: TextStyle(
                              fontSize: 15.sp,
                              color: AppColors.textPrimaryColor,
                              fontWeight: FontWeight.w400,
                              height: 26.h / 15.sp)),
                    ),
                    // Text(
                    //   "বাংলাদেশ সিভিল সার্ভিসে নিয়োগ পরীক্ষা গ্রহণের জন্য প্রণীত বিসিএস (বয়স, যোগ্যতা ও সরাসরি নিয়োগের জন্য পরীক্ষা) বিধিমালা-২০১৪ অনুযায়ী বিসিএস-এর নিম্নোক্ত ২৬টি ক্যাডারে উপযুক্ত প্রার্থী নিয়োগের উদ্দেশ্যে কমিশন কর্তৃক ৩ স্তরবিশিষ্ট পরীক্ষা গ্রহণ করা হয়।",
                    //   style: GoogleFonts.notoSansBengali(
                    //       textStyle: TextStyle(
                    //           fontSize: 15.sp,
                    //           color: AppColors.textPrimaryColor,
                    //           fontWeight: FontWeight.w400,
                    //           height: 26.h / 15.sp)),
                    // ),
                    SizedBox(
                      height: 28.h,
                    ),
                    buildDetailsWidget(),
                  ],
                ),
              );
            }
          }),
          Obx(() => Positioned.fill(
              child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20.r),
                      color: Colors.grey.withOpacity(.1),
                    ),
                    padding:
                        EdgeInsets.symmetric(vertical: 24.h, horizontal: 19.w),
                    child: CustomButton.button(
                        mainAxisSize: MainAxisSize.max,
                        text:
                            // controller.isContestRunning.value
                            DateTime.now().isBefore(controller
                                    .contestDetails.value!.contest.startContest)
                                ? "Enter Now"
                                : "Register Now",
                        onPressed: () => Get.find<ContestController>()
                            .registerForContest(
                                controller.contestDetails.value!.contest.id)),
                  )))),
        ],
      ),
    );
  }

  Widget _alreadyRunning() => Row(
        children: [
          Text(
            "Already Running",
            style: GoogleFonts.inter(
                textStyle: TextStyle(
              fontSize: 15.sp,
              color: AppColors.textPrimaryColor,
              fontWeight: FontWeight.w500,
            )),
          ),
          SizedBox(
            width: 22.w,
          ),
          Container(
            padding:
                const EdgeInsets.symmetric(vertical: 13.5, horizontal: 16.5),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(55.13.r),
              border: Border.all(color: AppColors.primary),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset('assets/countdown.png'),
                SizedBox(width: 9.w),
                Text(
                  "Time Left: 23: 55 : 20 ",
                  style: GoogleFonts.inter(
                      textStyle: TextStyle(
                    fontSize: 15.sp,
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                  )),
                ),
              ],
            ),
          ),
        ],
      );
  Widget _contestCountdown() => Container(
        padding: const EdgeInsets.symmetric(vertical: 13.5, horizontal: 16.5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(55.13.r),
          border: Border.all(color: AppColors.primary),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset('assets/countdown.png'),
            SizedBox(width: 9.w),
            Text(
              "23: 55 : 20 ",
              style: GoogleFonts.inter(
                  textStyle: TextStyle(
                fontSize: 18.sp,
                color: AppColors.primary,
                fontWeight: FontWeight.w600,
              )),
            ),
          ],
        ),
      );
  Widget buildLeftColumnRow({required String img, required String title}) =>
      Container(
        padding: EdgeInsets.symmetric(vertical: 11.h),
        child: Row(
          children: [
            Image.asset(img),
            SizedBox(
              width: 12.53.w,
            ),
            Text(title,
                style: GoogleFonts.notoSansBengali(
                    textStyle: TextStyle(
                        fontSize: 16.sp,
                        color: AppColors.textPrimaryColor,
                        fontWeight: FontWeight.w400))),
          ],
        ),
      );

  Widget buildRightColumnRow({
    required String value,
  }) =>
      Container(
        padding: EdgeInsets.symmetric(vertical: 11.h),
        child: Text(value,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.notoSansBengali(
                textStyle: TextStyle(
                    fontSize: 16.sp,
                    color: AppColors.textPrimaryColor,
                    fontWeight: FontWeight.w600))),
      );
  Widget buildDetailsWidget() => Container(
        child: Column(
          children: [
            Row(
              children: [
                SizedBox(
                  width: Get.width / 3,
                  child: Column(
                    children: [
                      buildLeftColumnRow(
                        title: "বিষয়",
                        img: 'assets/subject.png',
                      ),
                      buildLeftColumnRow(
                        title: "সর্বমান",
                        img: 'assets/total-marks.png',
                      ),
                      buildLeftColumnRow(
                        title: "সময়",
                        img: 'assets/total-time.png',
                      ),
                      buildLeftColumnRow(
                        title: "প্রতিযোগী",
                        img: 'assets/participiants.png',
                      ),
                      buildLeftColumnRow(
                        title: "তারিখ",
                        img: 'assets/contest-start.png',
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      buildRightColumnRow(
                          value:
                              "${controller.contestDetails.value?.contest.stringTopics}"),
                      buildRightColumnRow(
                          value:
                              "${controller.contestDetails.value?.contest.totalMarks} মার্কস"),
                      buildRightColumnRow(
                          value:
                              "${controller.contestDetails.value?.contest.totalTime} মিনিট"),
                      buildRightColumnRow(
                          value:
                              "${controller.contestDetails.value?.contest.registeredCount} জন"),
                      buildRightColumnRow(
                          value: "সোমবার, ২২ ডিসেম্বর, ২৪  10:00 AM"),
                    ],
                  ),
                )
              ],
            )
          ],
        ),
      );
}
