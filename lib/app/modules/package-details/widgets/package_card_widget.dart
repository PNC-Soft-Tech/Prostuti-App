import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
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
    return GestureDetector(
      onTap: () {
        if (!isCurrentPackage) {
          _showPaymentDialog();
        }
      },
      child: Stack(
        children: [
          Container(
            padding: EdgeInsets.only(left: 12.w, bottom: 12.w, right: 12.w),
            margin: EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
            decoration: BoxDecoration(
              color: isCurrentPackage ? const Color(0xFFF1F9FF) : Colors.white,
              borderRadius: BorderRadius.circular(10.r),
              border: Border.all(
                  width: 1,
                  color: isCurrentPackage
                      ? AppColors.primary
                      : const Color(0xFFD9D9D9)),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.center,
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
                                color: const Color(0xFF292D34),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 10),
                    Checkbox(
                      value: isCurrentPackage,
                      onChanged: (value) {},
                      activeColor: AppColors.primary,
                      checkColor: Colors.white,
                    ),
                  ],
                ),
                for (var service in services) ...[
                  buildRowItem(title: service, isSelected: isCurrentPackage),
                ]
              ],
            ),
          ),
          // left blank arrow
          Positioned(
            left: 5,
            top: 55,
            child: SvgPicture.asset(
              "assets/icons/angled-arrow.svg",
              width: 10.w,
            ),
          ),
          Positioned(
            top: 24.h,
            left: 6,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 20.0),
              child: Stack(
                children: [
                  // primary bg
                  Container(
                    width: 174.w,
                    height: 42.h,
                    decoration: const BoxDecoration(
                      color: AppColors.primary,
                      borderRadius:
                          BorderRadius.only(topLeft: Radius.circular(6)),
                    ),
                  ),
                  // right white angle
                  Positioned(
                    right: -30,
                    top: 7,
                    child: Transform.rotate(
                      angle: -3.14 / 2,
                      child: CustomPaint(
                        size: Size(70.w, 26.h),
                        painter: TrianglePainter(
                            color: isCurrentPackage
                                ? const Color(0xFFF1F9FF)
                                : Colors.white),
                      ),
                    ),
                  ),
                  // text
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
          ),
        ],
      ),
    );
  }

  void _showPaymentDialog() {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.r),
        ),
        backgroundColor: Colors.white,
        child: Container(
          padding: EdgeInsets.all(16.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 8.h),
              Image.asset(
                'assets/logo/bkash_payment_logo.png',
                width: 200.w,
              ),
              SizedBox(height: 24.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
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
                              color: const Color(0xFF292D34),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 24.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButton(
                    onPressed: () => Get.back(),
                    child: const Text('Cancel'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Get.back();
                      // controller.submitContest(
                      //     controller.modelDetails.value?.contest.id ?? '');
                      // controller.isModelTestSubmittedLocal.value = true;
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50),
                      ),
                    ),
                    child: const Text(
                      'Continue',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildRowItem({String title = '', bool isSelected = false}) =>
      Container(
        margin: EdgeInsets.symmetric(vertical: 4.w),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Flexible(
              flex: 1,
              child: Icon(
                Icons.check_circle_outlined,
                color: isSelected ? AppColors.primary : const Color(0xFFBDBDBD),
                size: 24.sp,
                // grade: 20,
              ),
            ),
            SizedBox(
              width: 10.w,
            ),
            Flexible(
              flex: 9,
              child: Padding(
                padding: const EdgeInsets.only(top: 2),
                child: Text(
                  title,
                  style: GoogleFonts.notoSansBengali(
                    textStyle: TextStyle(
                      fontSize: 14.sp,
                      color: AppColors.charcoalGray,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
}

class TrianglePainterCustom extends CustomPainter {
  final Color color;
  TrianglePainterCustom({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    Path path = Path();

    // Define the points for the 45-45-90 triangle
    path.moveTo(0, 0); // Start at the top-left corner
    path.lineTo(size.width, 0); // Draw the bottom side (horizontal line)
    path.lineTo(0, size.height); // Draw the vertical side
    path.close(); // Close the path to form the triangle

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
