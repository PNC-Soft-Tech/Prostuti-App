import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../constant/app_color.dart';

class ModelTestsLoadingCard extends StatelessWidget {
  const ModelTestsLoadingCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.primary.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title placeholder
          Container(
            height: 20.h,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(4.r),
            ),
          ),
          SizedBox(height: 8.h),
          
          // Date placeholder
          Container(
            height: 14.h,
            width: 100.w,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(4.r),
            ),
          ),
          SizedBox(height: 12.h),
          
          // Description placeholder
          Container(
            height: 14.h,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(4.r),
            ),
          ),
          SizedBox(height: 4.h),
          Container(
            height: 14.h,
            width: 200.w,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(4.r),
            ),
          ),
          SizedBox(height: 12.h),
          
          // Stats placeholders
          Row(
            children: [
              Container(
                height: 24.h,
                width: 80.w,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(12.r),
                ),
              ),
              SizedBox(width: 8.w),
              Container(
                height: 24.h,
                width: 60.w,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(12.r),
                ),
              ),
              SizedBox(width: 8.w),
              Container(
                height: 24.h,
                width: 70.w,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(12.r),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
