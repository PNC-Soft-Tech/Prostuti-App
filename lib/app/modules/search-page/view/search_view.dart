import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../constant/app_color.dart';
import '../../exam-topics/widgets/exam_topics_widget.dart';
import '../../exam-types/widgets/exam-categories-widget.dart';
import '../widgets/popular_search_widget.dart';
import '../widgets/search_input_widget.dart';

class SearchView extends StatelessWidget {
  const SearchView({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const ClampingScrollPhysics(),
      padding: EdgeInsets.fromLTRB(20.w, 4.h, 20.w, 24.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Discover',
            style: GoogleFonts.inter(
              fontSize: 22.sp,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimaryColor,
              letterSpacing: -0.4,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            'Find exams, topics and contests fast.',
            style: GoogleFonts.inter(
              fontSize: 13.sp,
              fontWeight: FontWeight.w400,
              color: AppColors.gray,
            ),
          ),
          SizedBox(height: 18.h),
          const SearchInputWidget(),
          SizedBox(height: 24.h),
          const PopularSearchWidget(),
          SizedBox(height: 28.h),
          const ExamCategoriesWidget(),
          SizedBox(height: 28.h),
          const ExamTopicsWidget(),
        ],
      ),
    );
  }
}
