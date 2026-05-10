import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../constant/app_color.dart';
import '../../contests/controller/contest_controller.dart';
import '../../contests/widgets/contest_cards_home_page_widget.dart';
import '../../custom-exam/widgets/custom_exam_home_card_widget.dart';
import '../../exam-topics/widgets/exam_topics_widget.dart';
import '../../exam-types/widgets/exam-categories-widget.dart';
import '../../job-circulars/widgets/job_circular_home_widget.dart';
import '../../model-tests/widgets/model_test_home_widget.dart';
import '../controller/home_controller.dart';
import 'home_greeting_header.dart';

const double _kHorizontalGutter = 20;
const double _kSectionGap = 28;

class HomeMainWidget extends GetWidget<HomeController> {
  const HomeMainWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.only(bottom: 24.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(
                _kHorizontalGutter.w, 4.h, _kHorizontalGutter.w, 16.h),
            child: const HomeGreetingLine(),
          ),
          Padding(
            padding:
                EdgeInsets.symmetric(horizontal: _kHorizontalGutter.w),
            child: _SearchPill(
              onTap: () => controller.navigateToTab(1),
            ),
          ),
          SizedBox(height: _kSectionGap.h),

          // Sections that need horizontal padding
          Obx(() {
            final contestCtrl = Get.find<ContestController>();
            final hide = !contestCtrl.isLoadingUpcomingContest.value &&
                contestCtrl.upcomingContests.isEmpty;
            if (hide) return const SizedBox.shrink();
            return Padding(
              padding: EdgeInsets.fromLTRB(_kHorizontalGutter.w, 0,
                  _kHorizontalGutter.w, _kSectionGap.h),
              child: const ContestHomeCardsWrapperWidget(),
            );
          }),

          Padding(
            padding:
                EdgeInsets.symmetric(horizontal: _kHorizontalGutter.w),
            child: const ExamCategoriesWidget(),
          ),
          SizedBox(height: _kSectionGap.h),

          Padding(
            padding:
                EdgeInsets.symmetric(horizontal: _kHorizontalGutter.w),
            child: const ExamTopicsWidget(),
          ),
          SizedBox(height: _kSectionGap.h),

          Padding(
            padding:
                EdgeInsets.symmetric(horizontal: _kHorizontalGutter.w),
            child: const ModelTestHomeWidget(),
          ),
          SizedBox(height: _kSectionGap.h),

          // Edge-to-edge job alerts band — designed to be full width.
          const JobCircularHomeWidget(),
          SizedBox(height: _kSectionGap.h),

          Padding(
            padding:
                EdgeInsets.symmetric(horizontal: _kHorizontalGutter.w),
            child: const CustomExamHomeCardWidget(),
          ),
        ],
      ),
    );
  }
}

class _SearchPill extends StatelessWidget {
  final VoidCallback onTap;

  const _SearchPill({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14.r),
        child: Container(
          height: 50.h,
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          decoration: BoxDecoration(
            color: const Color(0xFFF4F6F9),
            borderRadius: BorderRadius.circular(14.r),
            border: Border.all(
              color: AppColors.lightGray.withValues(alpha: 0.3),
              width: 1,
            ),
          ),
          child: Row(
            children: [
              SvgPicture.asset(
                'assets/navigation/search.svg',
                width: 18.w,
                height: 18.w,
                colorFilter: const ColorFilter.mode(
                  AppColors.gray,
                  BlendMode.srcIn,
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Text(
                  'Search exams, topics, contests…',
                  style: GoogleFonts.inter(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w400,
                    color: AppColors.gray,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
