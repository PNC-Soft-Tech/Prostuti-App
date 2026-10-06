import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:prostuti/app/constant/app_color.dart';
import 'package:prostuti/app/modules/profile/widgets/circular_progress.dart';

class ProgressCircle extends StatelessWidget {
  final double progress;

  const ProgressCircle({
    super.key,
    required this.progress,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            CurvedCircularProgress(
              color: AppColors.vividOrange,
              progress: progress,
              strokeWidth: 5.w,
            ),
          ],
        ),
        SizedBox(width: 10.w),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Completed!',
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.bold,
                color: AppColors.vividOrange,
              ),
            ),
            SizedBox(width: 5.w),
            Text(
              'Share all details for the best experience',
              style: TextStyle(
                  fontSize: 14.sp,
                  color: AppColors.vividOrange,
                  decoration: TextDecoration.underline,
                  decorationColor: AppColors.vividOrange,
                  decorationStyle: TextDecorationStyle.solid),
            ),
          ],
        ),
      ],
    );
  }
}
