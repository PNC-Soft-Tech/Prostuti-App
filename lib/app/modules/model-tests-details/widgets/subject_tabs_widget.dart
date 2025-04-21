// lib/modules/model_tests/widgets/subject_tabs_widget.dart

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../constant/app_color.dart';

class SubjectTabsWidget extends StatelessWidget {
  final List<String> subjects;
  final String selectedSubject;
  final bool isQuestionOpened;
  final Function(String subject) onSubjectSelected;
  
  const SubjectTabsWidget({
    Key? key,
    required this.subjects,
    required this.selectedSubject,
    required this.onSubjectSelected,
    this.isQuestionOpened = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (subjects.isEmpty) {
      return const SizedBox.shrink();
    }

    if (!isQuestionOpened) {
      return const SizedBox.shrink();
    }

    return Container(
      color: Colors.white,
      width: Get.width,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 12.h),
        child: Row(
          children: [
            // "All" Chip
            _buildSubjectChip('All'),
            SizedBox(width: 8.w),
            // Subject-specific chips
            ...subjects.map((subject) => _buildSubjectChip(subject)),
          ],
        ),
      ),
    );
  }

  Widget _buildSubjectChip(String subject) {
    final isSelected = selectedSubject == subject;
    
    return GestureDetector(
      onTap: () => onSubjectSelected(subject),
      child: Container(
        margin: EdgeInsets.only(right: 8.w),
        child: Chip(
          label: Text(
            subject,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.black,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          backgroundColor: isSelected 
              ? AppColors.primary 
              : const Color(0x2650AFFF),
          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50.r),
            side: BorderSide(
              color: isSelected 
                  ? AppColors.primary 
                  : const Color(0x2650AFFF),
              width: 1.5,
            ),
          ),
        ),
      ),
    );
  }
}