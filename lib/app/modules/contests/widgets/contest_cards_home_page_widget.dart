import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../common/utils/prostuti_utils.dart';
import '../../../constant/app_color.dart';
import '../controller/contest_controller.dart';
import '../models/contest_model.dart';
import 'contest_card_home_page_widget.dart';

class ContestHomeCardsWrapperWidget extends GetWidget<ContestController> {
  const ContestHomeCardsWrapperWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // onTap: ()=> Get.toNamed(Routes.singleContest(contest.id)),
      child: Obx(() {
        if (controller.isLoadingUpcomingContest.value == true) {
          return const Center(
            child: CupertinoActivityIndicator(
              color: AppColors.primary,
            ),
          );
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
                height: 0.h,
              ),
              SizedBox(
                height: 136.h, // Height for horizontal scrolling
                child: controller.upcomingContests.isEmpty
                    ? Center(
                        child: Text(
                          "No running or upcoming contests available",
                          style: GoogleFonts.inter(
                            textStyle: TextStyle(
                              fontSize: 14.sp,
                              color: AppColors.textPrimaryColor,
                            ),
                          ),
                        ),
                      )
                    : ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: controller.upcomingContests.length,
                        itemBuilder: (context, index) {
                          Contest contest = controller.upcomingContests[index];
                          // Double check that the contest is not completed
                          final contestStatus = Utils.getContestStatus(
                              contest.startContest, contest.endContest);
                          if (contestStatus.isDone) {
                            return const SizedBox
                                .shrink(); // Don't display completed contests
                          }

                          double cardWidth =
                              MediaQuery.of(context).size.width - 80.w;
                          return SizedBox(
                            width: cardWidth, // Set a fixed width for each card
                            child: ContestCardHome(
                              contest: contest,
                            ),
                          );
                        },
                      ),
              )
            ],
          ),
        );
      }),
    );
  }
}
