import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:prostuti/app/common/custom_appbar.dart';
import 'package:prostuti/app/common/custom_styles.dart';
import 'package:prostuti/app/common/widgets/bottom_nav_bar_widget.dart';
import 'package:prostuti/app/constant/app_color.dart';
import 'package:prostuti/app/modules/home/widgets/home_bottom_nav_more_bottom_sheet.dart';
import 'package:prostuti/app/routes/app_pages.dart';
import '../controllers/profile_controller.dart';

class ProfileView extends GetView<ProfileController> {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar.appBar(
          title: '',
          backgroundColor: Colors.white,
          // leadingWidth: 100,

          name: "Rahat"),
      body: Container(
          color: Colors.white,
          padding: EdgeInsets.symmetric(horizontal: 19.w, vertical: 10.h),
          child: SingleChildScrollView(
              child: Column(children: [
            const BorderedCircleAvatar(),
            SizedBox(
              height: 10.h,
            ),
            const ProgressCircle(
              progress: 0.4,
            ),
            SizedBox(
              height: 25.h,
            ),
            SettingsItem(
              title: 'Edit Profile',
              svgIcon: 'assets/profile/profile.svg',
              isProfileCompletionPercentageVisible: true,
              onTap: () {
                Get.toNamed(Routes.profileEdit);
              },
            ),
            SizedBox(
              height: 15.h,
            ),
            SettingsItem(
              title: 'Package',
              svgIcon: 'assets/profile/package.svg',
              isPackageInfoVisible: true,
              onTap: () {},
            ),
            SizedBox(
              height: 15.h,
            ),
            SettingsItem(
              title: 'App Settings',
              svgIcon: 'assets/profile/settings.svg',
              onTap: () {},
            ),
            SizedBox(
              height: 15.h,
            ),
            SettingsItem(
              title: 'Terms & Privacy',
              svgIcon: 'assets/profile/lock.svg',
              onTap: () {},
            ),
            SizedBox(
              height: 15.h,
            ),
            SettingsItem(
              title: 'Contact Us',
              svgIcon: 'assets/profile/headphone.svg',
              onTap: () {},
            ),
            SizedBox(
              height: 15.h,
            ),
            SettingsItem(
              title: 'Logout',
              svgIcon: 'assets/profile/logout.svg',
              isNavigationable: false,
              isLogout: true,
              onTap: () {},
            )
          ]))),
      bottomNavigationBar: Obx(() => CustomBottomNavBar(
            currentIndex: controller.currentIndex.value,
            onTap: (value) {
              if (value == 4) {
                Get.bottomSheet(
                  const HomeBottomNavMoreBottomSheet(),
                  isScrollControlled:
                      false, // Optional, to allow for full-screen or scrollable content
                  backgroundColor: Colors
                      .white, // Optional, background color for the bottom sheet
                  ignoreSafeArea: false,
                  isDismissible: true,
                );
              } else {
                controller.currentIndex.value = value;
              }
            },
          )),
    );
  }
}

class BorderedCircleAvatar extends StatelessWidget {
  const BorderedCircleAvatar({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: AppColors.primary,
            width: 3.w,
          ),
        ),
        child: CircleAvatar(
          radius: 50.w,
          backgroundColor: Colors.transparent,
          child: SvgPicture.asset(
            "assets/default-male.svg",
            width: 70.w,
            height: 70.h,
          ),
        ),
      ),
    );
  }
}

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

class CurvedCircularProgress extends StatelessWidget {
  final double progress;
  final double strokeWidth;
  final Color color;
  final double textSize;

  const CurvedCircularProgress({
    super.key,
    required this.progress,
    required this.strokeWidth,
    required this.color,
    this.textSize = 12,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(30.w, 30.w),
      painter: _ProgressPainter(
        progress: progress,
        strokeWidth: strokeWidth,
        color: color,
        textSize: textSize,
      ),
    );
  }
}

class _ProgressPainter extends CustomPainter {
  final double progress;
  final double strokeWidth;
  final Color color;
  final double textSize;

  _ProgressPainter({
    required this.progress,
    required this.strokeWidth,
    required this.color,
    required this.textSize,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Paint backgroundPaint = Paint()
      ..color = Colors.grey[200]!
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    final Paint progressPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = strokeWidth;

    // Circle bounds
    final Rect rect = Rect.fromCircle(
        center: Offset(size.width / 2, size.height / 2),
        radius: size.width / 2);

    // Draw the background circle
    canvas.drawCircle(Offset(size.width / 2, size.height / 2), size.width / 2,
        backgroundPaint);

    // Draw the progress arc
    final double sweepAngle = 2 * 3.141592653589793 * progress;
    canvas.drawArc(
        rect, -3.141592653589793 / 2, sweepAngle, false, progressPaint);

    // Add the percentage text inside the circle
    final textPainter = TextPainter(
      text: TextSpan(
        text: '${(progress * 100).toInt()}%',
        style: TextStyle(
          fontSize: textSize.sp,
          fontWeight: FontWeight.bold,
          color: color,
        ),
      ),
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    )..layout(minWidth: 0, maxWidth: size.width);

    final textOffset = Offset(
      (size.width - textPainter.width) / 2,
      (size.height - textPainter.height) / 2,
    );
    textPainter.paint(canvas, textOffset);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false; // No need to repaint if the progress is static
  }
}

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
