import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../constant/app_color.dart';
import '../controller/contest_controller.dart';
import '../widgets/contest_widget.dart';

class ContestView extends GetView<ContestController> {
  const ContestView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        scrolledUnderElevation: 0,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_rounded,
            color: AppColors.textPrimaryColor,
            size: 22.sp,
          ),
          onPressed: () => Get.back(),
        ),
        title: Text(
          'Contests',
          style: GoogleFonts.inter(
            fontSize: 18.sp,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimaryColor,
            letterSpacing: -0.3,
          ),
        ),
        centerTitle: true,
      ),
      body: Obx(() {
        if (controller.isLoadingUpcomingContest.value) {
          return const Center(
            child: CupertinoActivityIndicator(color: AppColors.primary),
          );
        }

        final contests = controller.upcomingContests;

        return RefreshIndicator(
          color: AppColors.primary,
          onRefresh: controller.displayRecentContests,
          child: contests.isEmpty
              ? const _EmptyState()
              : ListView.builder(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 24.h),
                  itemCount: contests.length,
                  itemBuilder: (context, index) =>
                      ContestWidget(contests[index]),
                ),
        );
      }),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    // ListView so RefreshIndicator can be triggered by pulling down even when
    // there are no contests.
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      children: [
        SizedBox(height: 80.h),
        Center(
          child: Container(
            width: 80.w,
            height: 80.w,
            decoration: const BoxDecoration(
              color: AppColors.primaryOpacity,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.emoji_events_outlined,
              size: 38.sp,
              color: AppColors.primary,
            ),
          ),
        ),
        SizedBox(height: 18.h),
        Center(
          child: Text(
            'No contests right now',
            style: GoogleFonts.inter(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimaryColor,
            ),
          ),
        ),
        SizedBox(height: 6.h),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 32.w),
          child: Text(
            'Check back later for upcoming and running contests. Pull down to refresh.',
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              fontSize: 13.sp,
              fontWeight: FontWeight.w400,
              color: AppColors.gray,
              height: 1.45,
            ),
          ),
        ),
      ],
    );
  }
}
