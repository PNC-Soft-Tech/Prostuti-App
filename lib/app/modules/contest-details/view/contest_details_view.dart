import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:prostuti/app/common/custom_bottom_fixed_button.dart';
import 'package:prostuti/app/common/utils/prostuti_utils.dart';
import 'package:prostuti/app/constant/app_color.dart';
import 'package:prostuti/app/modules/questions/models/question_model.dart';

import '../../../common/custom_simple_appbar.dart';
import '../../../common/widgets/countdown_timer.dart';
import '../../contests/controller/contest_controller.dart';
import '../../questions/models/option_model.dart';
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
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (!controller.isQuestionOpened.value)
                        Column(
                          children: [
                            Row(
                              children: [
                                controller.contestDetails.value?.contest
                                                .imageUrl !=
                                            null &&
                                        controller.contestDetails.value!.contest
                                            .imageUrl!
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
                                  controller
                                          .contestDetails.value?.contest.name ??
                                      "বিসিএস কনটেস্ট-০১",
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
                            Obx(() {
                              final status = Utils.getContestStatus(
                                controller.contestDetails.value?.contest
                                        .startContest ??
                                    DateTime.now(),
                                controller.contestDetails.value?.contest
                                        .endContest ??
                                    DateTime.now(),
                              );

                              if (status.isRunning) {
                                return _alreadyRunning();
                              } else if (status.isScheduled) {
                                return _contestCountdown();
                              } else {
                                // return _contestEnded();
                                return Text(
                                    "Ended on: ${controller.contestDetails.value?.contest.endContest}");
                              }
                            }),
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
                      if (controller.isQuestionOpened.value)
                        for (int i = 0;
                            i <
                                controller.contestDetails.value!.contest
                                    .questions.length;
                            i++) ...[
                          buildQuestionWidget(
                              question: controller
                                  .contestDetails.value!.contest.questions[i],
                              index: i)
                        ],
                      SizedBox(
                        height: 80.h,
                      ),
                    ],
                  ),
                ),
              );
            }
          }),
          Obx(() {
            // controller.isContestRunning.value
            final status = Utils.getContestStatus(
              controller.contestDetails.value?.contest.startContest ??
                  DateTime.now(),
              controller.contestDetails.value?.contest.endContest ??
                  DateTime.now(),
            );
            return CustomBottomFixedButton(
                buttonText: status.isRunning
                    ? "Enter Now"
                    : status.isScheduled
                        ? "Register Now"
                        : "Completed",
                onPressed: () => Get.find<ContestController>()
                    .registerForContest(
                        controller.contestDetails.value!.contest.id));
          }),
        ],
      ),
    );
  }

  Widget buildQuestionWidget(
          {required Question question, required int index}) =>
      Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "${index + 1}) ${question.title}",
              style: GoogleFonts.notoSansBengali(
                  textStyle:
                      TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w400)),
            ),
            SizedBox(
              height: 10.h,
            ),
            Row(
              children: [
                Icon(Icons.flag),
                SizedBox(
                  width: 5.w,
                ),
                Text('Mark this Question',
                    style: GoogleFonts.inter(
                        textStyle: TextStyle(
                            fontSize: 15.sp, fontWeight: FontWeight.w400))),
                SizedBox(
                  height: 10.h,
                ),
              ],
            ),
            SizedBox(
              height: 15.h,
            ),
            for (Option option in question.options) ...[
              Row(
                children: [
                  Flexible(
                      flex: 1,
                      child: Container(
                        padding: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50.r),
                          border: Border.all(color: Colors.black, width: 1),
                          color: Colors.transparent,
                        ),
                        child: Container(
                          height: 20,
                          width: 20,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50.r),
                            // border: Border.all(color: Colors.black, width: 1),
                            color: AppColors.primary,
                          ),
                        ),
                      )
                      // child: CircleAvatar(
                      //   backgroundColor: Colors.grey,
                      //   radius: 10.r,
                      // ),
                      ),
                  SizedBox(
                    width: 12.w,
                  ),
                  Flexible(flex: 9, child: Text("${option.title}")),
                ],
              ),
              SizedBox(
                height: 16.h,
              )
            ]
          ],
        ),
      );
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
            child: SingleChildScrollView(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset('assets/countdown.png'),
                  SizedBox(width: 9.w),
                  CountdownTimer(
                    startContest:
                        controller.contestDetails.value?.contest.startContest ??
                            DateTime.now(),
                    endContest:
                        controller.contestDetails.value?.contest.endContest ??
                            DateTime.now(),
                    fontSize: 12.sp,
                  ),
                  // Text(
                  //   "Time Left: 23: 55 : 20 ",
                  //   style: GoogleFonts.inter(
                  //       textStyle: TextStyle(
                  //     fontSize: 15.sp,
                  //     color: AppColors.primary,
                  //     fontWeight: FontWeight.w600,
                  //   )),
                  // ),
                ],
              ),
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
            CountdownTimer(
              startContest:
                  controller.contestDetails.value?.contest.startContest ??
                      DateTime.now(),
              endContest: controller.contestDetails.value?.contest.endContest ??
                  DateTime.now(),
              fontSize: 18.sp,
            ),
            // Text(
            //   "23: 55 : 20 ",
            //   style: GoogleFonts.inter(
            //       textStyle: TextStyle(
            //     fontSize: 18.sp,
            //     color: AppColors.primary,
            //     fontWeight: FontWeight.w600,
            //   )),
            // ),
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
                          value: Utils.formatDateToBangla(controller
                              .contestDetails.value!.contest.endContest)),
                    ],
                  ),
                )
              ],
            )
          ],
        ),
      );
}
