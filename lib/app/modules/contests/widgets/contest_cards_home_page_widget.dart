import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../constant/app_color.dart';
import '../controller/contest_controller.dart';
import '../models/contest_model.dart';
import 'contest_card_home_page_widget.dart';

class ContestHomeCardsWrapperWidget extends GetWidget<ContestController> {
  const ContestHomeCardsWrapperWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoadingUpcomingContest.value) {
        return const Center(
          child: CupertinoActivityIndicator(color: AppColors.primary),
        );
      }
      if (controller.upcomingContests.isEmpty) {
        return const SizedBox.shrink();
      }
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.w),
        margin: EdgeInsets.only(top: 10.w),
        decoration: BoxDecoration(
            color: AppColors.primaryOpacity,
            border: Border.all(width: 1, color: AppColors.primaryOpacity),
            borderRadius: BorderRadius.circular(16.r)),
        child: Column(
          children: [
            Row(
              children: [
                Text(
                  "Running & Upcoming Contests",
                  style: GoogleFonts.inter(
                      textStyle: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w500,
                          color: AppColors.blueGray)),
                ),
              ],
            ),
            SizedBox(
              height: 136.h,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: controller.upcomingContests.length,
                itemBuilder: (context, index) {
                  Contest contest = controller.upcomingContests[index];
                  double cardWidth =
                      MediaQuery.of(context).size.width - 80.w;
                  return SizedBox(
                    width: cardWidth,
                    child: ContestCardHome(contest: contest),
                  );
                },
              ),
            )
          ],
        ),
      );
    });
  }
}
