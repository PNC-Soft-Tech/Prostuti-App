// lib/modules/model_tests/widgets/model_test_access_bottom_sheet.dart

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../constant/app_color.dart';
import '../../../routes/app_pages.dart';

class ModelTestAccessBottomSheet extends StatelessWidget {
  final String modelTestId;

  const ModelTestAccessBottomSheet({
    Key? key,
    required this.modelTestId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20.r),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 0,
            offset: const Offset(0, -1),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Title
          Text(
            'Choose Access Mode',
            style: TextStyle(
              fontSize: 20.sp,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 30.h),
          
          // Mode Cards
          Row(
            children: [
              // Read Mode Card
              Expanded(
                child: _buildModeCard(
                  icon: Icons.menu_book_rounded,
                  title: 'Read Mode',
                  description: 'Detailed learning experience with solutions',
                  color: AppColors.primary,
                  onTap: () => _navigateToModelTest('read'),
                ),
              ),
              SizedBox(width: 16.w),
              // Exam Mode Card
              Expanded(
                child: _buildModeCard(
                  icon: Icons.quiz_rounded,
                  title: 'Exam Mode',
                  description: 'Timed practice test experience',
                  color: AppColors.primary,
                  onTap: () => _navigateToModelTest('exam'),
                ),
              ),
            ],
          ),
          SizedBox(height: 20.h),
        ],
      ),
    );
  }

  Widget _buildModeCard({
    required IconData icon,
    required String title,
    required String description,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(
            color: color.withOpacity(0.5),
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              spreadRadius: 0,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(
                  icon,
                  color: color,
                  size: 36.sp,
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  color: color,
                  size: 18.sp,
                ),
              ],
            ),
            SizedBox(height: 16.h),
            Text(
              title,
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              description,
              style: TextStyle(
                fontSize: 14.sp,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToModelTest(String mode) {
    Get.back(); // Close the bottom sheet
    Get.toNamed(
      Routes.modelTestDetails,
      arguments: {
        'modelTestId': modelTestId,
        'mode': mode,
      },
    );
  }
}