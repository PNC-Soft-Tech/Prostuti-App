// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
// import 'package:get/get.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:prostuti/app/common/utils/prostuti_utils.dart';

// import '../../../common/custom_buttons.dart';
// import '../../../common/widgets/countdown_timer.dart';
// import '../../../routes/app_pages.dart';
// import '../controller/contest_controller.dart';
// import '../models/contest_model.dart';

// class ContestCardHome extends GetWidget<ContestController> {
//   final Contest contest;
//   const ContestCardHome({super.key, required this.contest});

//   @override
//   Widget build(BuildContext context) {
//     var isScheduled =
//         Utils.getContestStatus(contest.startContest, contest.endContest)
//             .isScheduled;
//     var isRunning =
//         Utils.getContestStatus(contest.startContest, contest.endContest)
//             .isRunning;
//     // var isDone =
//     //     Utils.getContestStatus(contest.startContest, contest.endContest).isDone;
//     return GestureDetector(
//       onTap: () => Get.toNamed(Routes.contestDetails,
//           arguments: {"contestId": contest.id}),
//       child: InkWell(
//         onTap: () => Get.toNamed(Routes.contestDetails,
//             arguments: {"contestId": contest.id}),
//         child: Column(
//           children: [
//             InkWell(
//               onTap: () => Get.toNamed(Routes.contestDetails,
//                   arguments: {"contestId": contest.id}),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.start,
//                 children: [
//                   contest.imageUrl != null && contest.imageUrl!.contains('http')
//                       ? Image.network(
//                           contest.imageUrl ?? '',
//                           height: 28.h,
//                           width: 28.h,
//                           fit: BoxFit.cover,
//                         )
//                       : Image.asset(
//                           'assets/govt-bd.png',
//                           height: 28.h,
//                           width: 28.w,
//                         ),
//                   SizedBox(
//                     width: 9.w,
//                   ),
//                   // Text(contest.name ?? '',
//                   //     style: GoogleFonts.notoSansBengali(
//                   //         textStyle: const TextStyle(
//                   //             fontSize: 16, fontWeight: FontWeight.w600)))
//                   HtmlWidget(contest.name!)
//                 ],
//               ),
//             ),
//             SizedBox(
//               height: 11.h,
//             ),
//             Row(
//               children: [
//                 Expanded(
//                     child: Text(contest.stringTopics ?? "গনিত - জ্যামিতি",
//                         style: GoogleFonts.notoSansBengali(
//                             textStyle: const TextStyle(
//                                 fontSize: 16, fontWeight: FontWeight.w600))))
//               ],
//             ),
//             isScheduled
//                 ? _scheduleContest()
//                 : isRunning
//                     ? _runningContest()
//                     : const Text('Completed'),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _scheduleContest() => Row(
//         children: [
//           Expanded(
//               child: Row(
//             children: [
//               Image.asset('assets/countdown.png'),
//               SizedBox(
//                 width: 6.w,
//               ),
//               CountdownTimer(
//                 startContest: contest.startContest,
//                 endContest: contest.endContest,
//                 fontSize: 14.sp,
//               ),
//               // Text(
//               //   "20: 30: 43",
//               //   style: GoogleFonts.inter(
//               //       textStyle: TextStyle(
//               //           color: AppColors.primary,
//               //           fontSize: 16.sp,
//               //           fontWeight: FontWeight.w600)),
//               // )
//             ],
//           )),
//           CustomButton.button(
//               text: "Register Now",
//               fontSize: 13.sp,
//               fontWeight: FontWeight.w600,
//               onPressed: () => controller.registerForContest(contest.id),
//               borderRadius: 50.r,
//               isPrimary: true)
//         ],
//       );
//   Widget _runningContest() => Row(
//         children: [
//           Expanded(
//               child: Row(
//             children: [
//               Image.asset('assets/countdown.png'),
//               SizedBox(
//                 width: 6.w,
//               ),
//               CountdownTimer(
//                 startContest: contest.startContest,
//                 endContest: contest.endContest,
//                 fontSize: 12.sp,
//               ),
//               // Text(
//               //   "20: 30: 43",
//               //   style: GoogleFonts.inter(
//               //       textStyle: TextStyle(
//               //           color: AppColors.primary,
//               //           fontSize: 16.sp,
//               //           fontWeight: FontWeight.w600)),
//               // )
//             ],
//           )),
//           CustomButton.button(
//               text: "Enter Now",
//               fontSize: 13.sp,
//               fontWeight: FontWeight.w600,
//               // onPressed: () => controller.registerForContest(contest.id),
//               onPressed: () => {},
//               borderRadius: 50.r,
//               isPrimary: true)
//         ],
//       );
// }
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:prostuti/app/common/utils/prostuti_utils.dart';
import '../../../common/custom_buttons.dart';
import '../../../common/widgets/countdown_timer.dart';
import '../../../routes/app_pages.dart';
import '../controller/contest_controller.dart';
import '../models/contest_model.dart';
import '../models/contest_status.dart';

class ContestCardHome extends StatelessWidget {
  final Contest contest;
  const ContestCardHome({super.key, required this.contest});

  ContestController get controller => Get.find<ContestController>();

  @override
  Widget build(BuildContext context) {
    final contestStatus =
        Utils.getContestStatus(contest.startContest, contest.endContest);

    return GestureDetector(
      onTap: () => _navigateToDetails(),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 12.w),
        // decoration: BoxDecoration(
        //   // color: Colors.white,
        //   borderRadius: BorderRadius.circular(12.r),
        //   boxShadow: [
        //     BoxShadow(
        //       color: Colors.black.withOpacity(0.05),
        //       blurRadius: 6.r,
        //       offset: Offset(0, 3),
        //     )
        //   ],
        // ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            SizedBox(height: 11.h),
            Text(
              contest.stringTopics ?? "গনিত - জ্যামিতি",
              style: GoogleFonts.notoSansBengali(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 8.h),
            _buildActionRow(contestStatus),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        _buildContestImage(),
        SizedBox(width: 9.w),
        Expanded(
          child: HtmlWidget(contest.name ?? "No Name"),
        ),
      ],
    );
  }

  Widget _buildContestImage() {
    if (contest.imageUrl != null && contest.imageUrl!.contains('http')) {
      return Image.network(
        contest.imageUrl!,
        height: 28.h,
        width: 28.h,
        fit: BoxFit.cover,
      );
    } else {
      return Image.asset(
        'assets/govt-bd.png',
        height: 28.h,
        width: 28.h,
      );
    }
  }

  Widget _buildActionRow(ContestStatus status) {
    return Obx(() {
      final isRegistered = controller.registeredContests[contest.id] ?? false;

      if (status.isDone) {
        return Text(
          'Completed',
          style: GoogleFonts.notoSansBengali(
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
            color: Colors.grey,
          ),
        );
      } else if (status.isRunning && isRegistered) {
        return _buildCountdownRow("Enter Now", () => _navigateToDetails());
      } else {
        return _buildCountdownRow(
            "Register Now", () => controller.registerForContest(contest.id));
      }
    });
  }

  Widget _buildCountdownRow(String buttonText, VoidCallback onPressed) {
    return Row(
      children: [
        Image.asset('assets/countdown.png', height: 18.h, width: 18.h),
        SizedBox(width: 6.w),
        Expanded(
          child: CountdownTimer(
            startContest: contest.startContest,
            endContest: contest.endContest,
            fontSize: 12.sp,
          ),
        ),
        const Spacer(),
        CustomButton.button(
          text: buttonText,
          fontSize: 13.sp,
          fontWeight: FontWeight.w600,
          onPressed: onPressed,
          borderRadius: 50.r,
          isPrimary: true,
        ),
      ],
    );
  }

  void _navigateToDetails() {
    Get.toNamed(Routes.contestDetails, arguments: {"contestId": contest.id});
  }

  void _registerForContest() async {
    await controller.registerForContest(contest.id);
    contest.isRegistered =
        true; // 👈 After successful registration, update the contest itself
    controller.upcomingContests
        .refresh(); // 👈 Ensure list updates with new isRegistered state
  }
}
