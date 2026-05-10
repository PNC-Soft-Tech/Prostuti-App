import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../constant/app_color.dart';
import '../../../routes/app_pages.dart';
import '../../../storage/storage_helper.dart';

class HomeGreetingHeader extends StatelessWidget {
  const HomeGreetingHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(20.w, 12.h, 16.w, 12.h),
      child: Row(
        children: [
          SvgPicture.asset(
            'assets/header-logo.svg',
            height: 36.h,
          ),
          const Spacer(),
          _IconButton(
            assetPath: 'assets/notification.svg',
            onTap: () {},
          ),
          SizedBox(width: 8.w),
          GestureDetector(
            onTap: () => Get.toNamed(Routes.profile),
            child: const _ProfileAvatar(),
          ),
        ],
      ),
    );
  }
}

class HomeGreetingLine extends StatelessWidget {
  const HomeGreetingLine({super.key});

  String get _timeOfDayGreeting {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good morning';
    if (hour < 17) return 'Good afternoon';
    return 'Good evening';
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String?>(
      future: StorageHelper.getUserData(),
      builder: (context, snapshot) {
        String? firstName;
        if (snapshot.hasData && snapshot.data != null) {
          try {
            final fullName =
                jsonDecode(snapshot.data!)['fullName'] as String? ?? '';
            firstName = fullName.split(' ').first;
          } catch (_) {}
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _timeOfDayGreeting,
              style: GoogleFonts.inter(
                fontSize: 13.sp,
                fontWeight: FontWeight.w400,
                color: AppColors.gray,
              ),
            ),
            SizedBox(height: 2.h),
            Text(
              firstName != null && firstName.isNotEmpty
                  ? 'Hi, $firstName 👋'
                  : 'Welcome back 👋',
              style: GoogleFonts.inter(
                fontSize: 22.sp,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimaryColor,
                letterSpacing: -0.4,
              ),
            ),
          ],
        );
      },
    );
  }
}

class _IconButton extends StatelessWidget {
  final String assetPath;
  final VoidCallback onTap;

  const _IconButton({required this.assetPath, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12.r),
        child: Container(
          width: 42.w,
          height: 42.w,
          decoration: BoxDecoration(
            color: const Color(0xFFF4F6F9),
            borderRadius: BorderRadius.circular(12.r),
          ),
          alignment: Alignment.center,
          child: SvgPicture.asset(
            assetPath,
            width: 18.w,
            height: 18.w,
            colorFilter: const ColorFilter.mode(
              AppColors.textPrimaryColor,
              BlendMode.srcIn,
            ),
          ),
        ),
      ),
    );
  }
}

class _ProfileAvatar extends StatelessWidget {
  const _ProfileAvatar();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 42.w,
      height: 42.w,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
            color: AppColors.primary.withValues(alpha: 0.4), width: 1.5),
      ),
      padding: EdgeInsets.all(2.w),
      child: ClipOval(
        child: FutureBuilder<String?>(
          future: StorageHelper.getUserData(),
          builder: (context, snapshot) {
            if (snapshot.hasData && snapshot.data != null) {
              try {
                final pic = jsonDecode(snapshot.data!)['profilePic'] as String?;
                if (pic != null &&
                    pic.isNotEmpty &&
                    pic != 'https://picsum.photos/id/1/200/300') {
                  return Image.network(
                    pic,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) =>
                        SvgPicture.asset('assets/default-male.svg'),
                  );
                }
              } catch (_) {}
            }
            return SvgPicture.asset('assets/default-male.svg');
          },
        ),
      ),
    );
  }
}
