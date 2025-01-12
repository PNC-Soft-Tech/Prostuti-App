import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
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
            child: CircularProgressIndicator(),
          );
        }
        return Container(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
          // margin:  EdgeInsets.symmetric(horizontal: 19.w),
          decoration: BoxDecoration(
              color: const Color(0xFFE9F5FF),
              border: Border.all(width: 1, color: const Color(0xFFE9F5FF)),
              borderRadius: BorderRadius.circular(20.r)),
          child: Column(
            children: [
              Row(
                children: [
                  Text(
                    "Upcomming Contest",
                    style: GoogleFonts.inter(
                        textStyle: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                    )),
                  ),
                ],
              ),
              SizedBox(
                height: 10.h,
              ),
              SizedBox(
                height: 150.h, // Height for horizontal scrolling
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: controller.upcomingContests.length,
                  itemBuilder: (context, index) {
                    Contest contest = controller.upcomingContests[index];
                    return Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: 8.w), // Spacing between cards

                      child: SizedBox(
                        width: 340.w, // Set a fixed width for each card
                        child: ContestCardHome(
                          contest: contest,
                        ),
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
