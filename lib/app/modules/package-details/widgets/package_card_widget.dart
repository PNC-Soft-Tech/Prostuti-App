import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../constant/app_color.dart';
import '../controllers/package_details_controller.dart';
import 'package_rotated_triangle_widget.dart';

class PackageCardWidget extends GetWidget<PackageDetailsController> {
  final String name;
  final bool isCurrentPackage;
  final String price;
  final String period;
  final List<String> services;

  const PackageCardWidget({
    super.key,
    required this.name,
    required this.isCurrentPackage,
    required this.period,
    required this.price,
    required this.services,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
          margin: EdgeInsets.symmetric(vertical: 12.h, horizontal: 20.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10.r),
            border: Border.all(
                width: 1,
                color:
                    isCurrentPackage ? Color(0xFF50AFFF) : Color(0xFFD9D9D9)),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                blurRadius: 4,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  SizedBox(width: 16.w),
                  Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: price,
                          style: GoogleFonts.inter(
                            textStyle: TextStyle(
                              fontSize: 25.sp,
                              fontWeight: FontWeight.w800,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        TextSpan(
                          text: " / $period",
                          style: GoogleFonts.inter(
                            textStyle: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w400,
                              color: Color(0xFF292D34),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 10),
                  Checkbox(
                    value: isCurrentPackage,
                    onChanged: (value) {},
                    activeColor: AppColors.primary,
                    checkColor: Colors.white,
                  ),
                ],
              ),
              for (var service in services) ...[
                buildRowItem(title: "${service}", isSelected: isCurrentPackage),
              ]
            ],
          ),
        ),
        Positioned(
          top: 24.h,
          left: 10,
          child: Stack(
            children: [
              Container(
                width: 174.w,
                height: 40.h,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
              Positioned(
                right: -8,
                top: 7,
                child: Transform.rotate(
                  angle: -3.14 / 2,
                  child: CustomPaint(
                    size: Size(40.w, 26.h),
                    painter: TrianglePainter(color: Colors.white),
                  ),
                ),
              ),
              Positioned(
                left: -5,
                bottom: -10,
                child: Transform.rotate(
                  angle: 180,
                  child: CustomPaint(
                    size: Size(15.w, 15.h),
                    painter: TrianglePainter(color: Colors.black),
                  ),
                ),
              ),
              Positioned(
                top: 10.h,
                left: 23.w,
                child: Align(
                  alignment: Alignment.center,
                  child: Text(
                    name.toUpperCase(),
                    style: GoogleFonts.inter(
                      textStyle: TextStyle(
                        fontSize: 14.55.sp,
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget buildRowItem({String title = '', bool isSelected = false}) =>
      Container(
        margin: EdgeInsets.symmetric(vertical: 12.h),
        child: Row(
          children: [
            Flexible(
              flex: 1,
              child: Icon(
                Icons.check_circle_outlined,
                color: isSelected ? AppColors.primary : Color(0xFFBDBDBD),
                size: 20.w,
                grade: 20,
              ),
            ),
            SizedBox(
              width: 10.w,
            ),
            Flexible(
              flex: 9,
              child: Text(
                title,
                style: GoogleFonts.notoSansBengali(
                  textStyle: TextStyle(
                    fontSize: 14.sp,
                    color: Color(0xFF292D34),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
}
