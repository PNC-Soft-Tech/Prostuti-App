import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:prostuti/app/common/utils/prostuti_utils.dart';

import '../../../common/custom_buttons.dart';
import '../../../common/widgets/countdown_timer.dart';
import '../../../routes/app_pages.dart';
import '../controller/contest_controller.dart';
import '../models/contest_model.dart';

class ContestCardHome extends GetWidget<ContestController> {
  final Contest contest;
  const ContestCardHome({super.key, required this.contest});

  @override
  Widget build(BuildContext context) {
    var isScheduled =
        Utils.getContestStatus(contest.startContest, contest.endContest)
            .isScheduled;
    var isRunning =
        Utils.getContestStatus(contest.startContest, contest.endContest)
            .isRunning;
    // var isDone =
    //     Utils.getContestStatus(contest.startContest, contest.endContest).isDone;
    return GestureDetector(
      onTap: () => Get.toNamed(Routes.contestDetails,
          arguments: {"contestId": contest.id}),
      child: InkWell(
        onTap: () => Get.toNamed(Routes.contestDetails,
            arguments: {"contestId": contest.id}),
        child: Column(
          children: [
            InkWell(
              onTap: () => Get.toNamed(Routes.contestDetails,
                  arguments: {"contestId": contest.id}),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  contest.imageUrl != null && contest.imageUrl!.contains('http')
                      ? Image.network(
                          contest.imageUrl ?? '',
                          height: 28.h,
                          width: 28.h,
                          fit: BoxFit.cover,
                        )
                      : Image.asset(
                          'assets/govt-bd.png',
                          height: 28.h,
                          width: 28.w,
                        ),
                  SizedBox(
                    width: 9.w,
                  ),
                  Text(contest.name ?? '',
                      style: GoogleFonts.notoSansBengali(
                          textStyle: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w600)))
                ],
              ),
            ),
            SizedBox(
              height: 11.h,
            ),
            Row(
              children: [
                Expanded(
                    child: Text(contest.stringTopics ?? "গনিত - জ্যামিতি",
                        style: GoogleFonts.notoSansBengali(
                            textStyle: const TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w600))))
              ],
            ),
            isScheduled
                ? _scheduleContest()
                : isRunning
                    ? _runningContest()
                    : const Text('Completed'),
          ],
        ),
      ),
    );
  }

  Widget _scheduleContest() => Row(
        children: [
          Expanded(
              child: Row(
            children: [
              Image.asset('assets/countdown.png'),
              SizedBox(
                width: 6.w,
              ),
              CountdownTimer(
                startContest: contest.startContest,
                endContest: contest.endContest,
                fontSize: 14.sp,
              ),
              // Text(
              //   "20: 30: 43",
              //   style: GoogleFonts.inter(
              //       textStyle: TextStyle(
              //           color: AppColors.primary,
              //           fontSize: 16.sp,
              //           fontWeight: FontWeight.w600)),
              // )
            ],
          )),
          CustomButton.button(
              text: "Register Now",
              fontSize: 13.sp,
              fontWeight: FontWeight.w600,
              onPressed: () => controller.registerForContest(contest.id),
              borderRadius: 50.r,
              isPrimary: true)
        ],
      );
  Widget _runningContest() => Row(
        children: [
          Expanded(
              child: Row(
            children: [
              Image.asset('assets/countdown.png'),
              SizedBox(
                width: 6.w,
              ),
              CountdownTimer(
                startContest: contest.startContest,
                endContest: contest.endContest,
                fontSize: 12.sp,
              ),
              // Text(
              //   "20: 30: 43",
              //   style: GoogleFonts.inter(
              //       textStyle: TextStyle(
              //           color: AppColors.primary,
              //           fontSize: 16.sp,
              //           fontWeight: FontWeight.w600)),
              // )
            ],
          )),
          CustomButton.button(
              text: "Enter Now",
              fontSize: 13.sp,
              fontWeight: FontWeight.w600,
              // onPressed: () => controller.registerForContest(contest.id),
              onPressed: () => {},
              borderRadius: 50.r,
              isPrimary: true)
        ],
      );
}
