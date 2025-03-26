import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../constant/app_color.dart';

class SubjectTabsWidget extends StatelessWidget {
  List<String> subjects;
  String selectedSubject;
  bool isQuestionOpened;
  Function(String subject) onSubjectSelected;
  SubjectTabsWidget({
    super.key,
    required this.subjects,
    required this.selectedSubject,
    required this.onSubjectSelected,
    this.isQuestionOpened=false,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (subjects.isEmpty) {
        return const Text('No subjects available');
      }

      return isQuestionOpened == false
          ? SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  // "All" Chip - Selects all questions
                  GestureDetector(
                    onTap: () => onSubjectSelected('All'),
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 5.w, vertical: 15.h),
                      child: Chip(
                        label: Text(
                          "All",
                          style: TextStyle(
                              color: selectedSubject == 'All'
                                  ? Colors.white
                                  : Colors.black),
                        ),
                        backgroundColor: selectedSubject == 'All'
                            ? AppColors.primary
                            : Color(0x2650AFFF),
                        padding: EdgeInsets.symmetric(
                            horizontal: 5.w, vertical: 15.h),
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(50.r), // Set border radius
                          side: BorderSide(
                            color: selectedSubject == 'All'
                                ? AppColors
                                    .primary // Border color for selected chip
                                : Color(
                                    0x2650AFFF), // Border color for unselected chip

                            width: 1.5, // Border thickness
                          ),
                        ),
                        shadowColor: Color(0x2650AFFF),
                      ),
                    ),
                  ),

                  // Generate subject-specific Chips
                  ...subjects.map((subject) {
                    return GestureDetector(
                      onTap: () =>
                          onSubjectSelected(subject), // Set selected subject
                      child: Padding(
                        padding: EdgeInsets.only(right: 8.w),
                        child: Chip(
                          backgroundColor: selectedSubject == subject
                              ? AppColors.primary
                              : Color(0x2650AFFF), // Correct opacity
                          shadowColor: Color(0x2650AFFF),
                          label: Text(
                            subject,
                            style: TextStyle(
                                color: selectedSubject == subject
                                    ? Colors.white
                                    : Colors.black),
                          ),

                          padding: EdgeInsets.symmetric(
                              horizontal: 5.w, vertical: 15.h),

                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                50.r), // Set border radius
                            side: BorderSide(
                              color: selectedSubject == subject
                                  ? AppColors
                                      .primary // Border color for selected chip
                                  : Colors
                                      .white, // Border color for unselected chip
                              width: 1.5, // Border thickness
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ],
              ),
            )
          : SizedBox.shrink();
    });
  }
}
