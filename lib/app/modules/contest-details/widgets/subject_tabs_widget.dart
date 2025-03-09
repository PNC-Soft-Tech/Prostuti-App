import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../constant/app_color.dart';
import '../controller/contest_details_controller.dart';

class SubjectTabsWidget extends GetWidget<ContestDetailsController> {
  const SubjectTabsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.subjectLists.isEmpty) {
        return const Text('No subjects available');
      }

      return controller.isQuestionOpened == true
          ? SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  // "All" Chip - Selects all questions
                  GestureDetector(
                    onTap: () => controller.selectSubject('All'),
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 5.w, vertical: 15.h),
                      child: Chip(
                        label: Text(
                          "All",
                          style: TextStyle(
                              color: controller.selectedSubject.value == 'All'
                                  ? Colors.white
                                  : Colors.black),
                        ),
                        backgroundColor:
                            controller.selectedSubject.value == 'All'
                                ? AppColors.primary
                                : Color(0x2650AFFF),
                        padding: EdgeInsets.symmetric(
                            horizontal: 5.w, vertical: 15.h),
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(50.r), // Set border radius
                          side: BorderSide(
                            color: controller.selectedSubject.value == 'All'
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
                  ...controller.subjectLists.map((subject) {
                    return GestureDetector(
                      onTap: () => controller
                          .selectSubject(subject), // Set selected subject
                      child: Padding(
                        padding: EdgeInsets.only(right: 8.w),
                        child: Chip(
                          backgroundColor:
                              controller.selectedSubject.value == subject
                                  ? AppColors.primary
                                  : Color(0x2650AFFF), // Correct opacity
                          shadowColor: Color(0x2650AFFF),
                          label: Text(
                            subject,
                            style: TextStyle(
                                color:
                                    controller.selectedSubject.value == subject
                                        ? Colors.white
                                        : Colors.black),
                          ),

                          padding: EdgeInsets.symmetric(
                              horizontal: 5.w, vertical: 15.h),

                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                                50.r), // Set border radius
                            side: BorderSide(
                              color: controller.selectedSubject.value == subject
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
