import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:prostuti/app/common/custom_styles.dart';
import 'package:prostuti/app/constant/app_color.dart';
import 'package:prostuti/app/modules/profile/widgets/circular_progress.dart';

class SettingsItem extends StatelessWidget {
  final String title;
  final String svgIcon;
  final Function onTap;
  final bool isProfileCompletionPercentageVisible;
  final bool isPackageInfoVisible;
  final bool isNavigationable;
  final bool isLogout;

  const SettingsItem({
    super.key,
    required this.title,
    required this.svgIcon,
    required this.onTap,
    this.isProfileCompletionPercentageVisible = false,
    this.isPackageInfoVisible = false,
    this.isNavigationable = true,
    this.isLogout = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onTap(),
      child: Container(
        padding: EdgeInsets.symmetric(
            horizontal: 20.w, vertical: isNavigationable ? 20.h : 22.h),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(
              color: isLogout
                  ? AppColors.vividOrange.withOpacity(0.6)
                  : AppColors.blueGray.withOpacity(0.3)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment
              .spaceBetween, // Space between the text and the icon
          children: [
            Row(
              children: [
                SvgPicture.asset(
                  svgIcon,
                  width: 20.w,
                  height: 20.w,
                ),
                SizedBox(width: 15.w), // Space between the icon and the text
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
            Row(
              children: [
                if (isProfileCompletionPercentageVisible)
                  CurvedCircularProgress(
                    color: AppColors.vividOrange,
                    progress: 0.4,
                    strokeWidth: 5.w,
                  ),
                if (isPackageInfoVisible)
                  Row(
                    children: [
                      Text(
                        'Starter Plan',
                        style: CustomStyles.textStyle.copyWith(fontSize: 14.sp),
                      ),
                      SizedBox(
                        width: 2.w,
                      ),
                      Text(
                        '(1 Month)',
                        style: CustomStyles.textStyle.copyWith(
                            fontSize: 14.sp, fontWeight: FontWeight.w400),
                      ),
                    ],
                  ),
                if (isNavigationable)
                  Row(
                    children: [
                      SizedBox(width: 15.w),
                      SvgPicture.asset(
                        'assets/profile/right-arrow.svg',
                        width: 25.w,
                        height: 25.w,
                      ),
                    ],
                  )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
