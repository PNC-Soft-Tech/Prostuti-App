import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../common/widgets/countdown_timer.dart';
import '../../../constant/app_color.dart';
import '../controller/contest_details_controller.dart';

class ContestStatusWidget extends GetWidget<ContestDetailsController> {
  const ContestStatusWidget({super.key});

  /// ✅ Displays "Already Running" Status
  Widget _alreadyRunning() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          Text(
            "Already Running",
            style: TextStyle(
              fontSize: 12.sp,
              color: AppColors.textPrimaryColor,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(width: 22.w),
          Container(
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
                  startContest: controller.contestDetails.value?.contest.startContest ?? DateTime.now(),
                  endContest: controller.contestDetails.value?.contest.endContest ?? DateTime.now(),
                  fontSize: 12.sp,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// ✅ Displays Countdown Before Contest Starts
  Widget _contestCountdown() {
    return Container(
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
            startContest: controller.contestDetails.value?.contest.startContest ?? DateTime.now(),
            endContest: controller.contestDetails.value?.contest.endContest ?? DateTime.now(),
            fontSize: 18.sp,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final status = controller.contestStatus.value;
    if (status?.isRunning == true) {
      return _alreadyRunning();
    } else if (status?.isScheduled == true) {
      return _contestCountdown();
    } else {
      return const SizedBox(); // Hide when contest is over
    }
  }
}
