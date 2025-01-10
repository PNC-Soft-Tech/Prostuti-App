import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../common/custom_buttons.dart';
import '../../../constant/app_color.dart';
import '../../../routes/app_pages.dart';
import '../controller/contest_controller.dart';
import '../models/register_contest_model.dart';

class ContestCardHome extends GetWidget<ContestController> {
  final RegisterContest contest;
  const ContestCardHome({super.key, required this.contest});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap:()=> Get.toNamed(Routes.contestDetails, arguments: {"contestId": contest.id}),
      child: Column(
        children: [
          Container(
            // color: Colors.green,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                contest.imageUrl != null && contest.imageUrl!.contains('http')
                    ? Image.network(
                        controller.upcomingContests.first.imageUrl ?? '')
                    : Image.asset(
                        'assets/govt-bd.png',
                        height: 28,
                        width: 28,
                      ),
                SizedBox(
                  width: 9.w,
                ),
                Text("${contest.name}",
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
                  child: Text(contest.topics ?? "গনিত - জ্যামিতি",
                      style: GoogleFonts.notoSansBengali(
                          textStyle: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w600))))
            ],
          ),
          Row(
            children: [
              Expanded(
                  child: Row(
                children: [
                  Image.asset('assets/countdown.png'),
                  SizedBox(
                    width: 6.w,
                  ),
                  Text(
                    "20: 30: 43",
                    style: GoogleFonts.inter(
                        textStyle: TextStyle(
                            color: AppColors.primary,
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w600)),
                  )
                ],
              )),
              CustomButton.button(
                  text: "Register Now",
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w600,
                  onPressed:()=>controller.registerForContest(contest.id),
                  borderRadius: 50.r,
                  isPrimary: true)
            ],
          ),
        ],
      ),
    );
  }
}
