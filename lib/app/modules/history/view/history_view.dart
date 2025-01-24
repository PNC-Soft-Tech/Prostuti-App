import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:prostuti/app/constant/app_color.dart';
import 'package:prostuti/app/modules/history/controller/history_controller.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HistoryView extends GetWidget<HistoryController> {
  const HistoryView({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const BorderedButtonGroup(),
          SizedBox(height: 5.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Contest List',
                style: TextStyle(
                  fontSize: 18.sp,
                  color: AppColors.textPrimaryColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
              DropdownButton<String>(
                value: 'Sort By Date',
                icon: Icon(Icons.arrow_drop_down, size: 20.sp),
                underline: Container(),
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 14.sp,
                ),
                onChanged: (String? newValue) {
                  print('Selected: $newValue');
                },
                items: <String>['Sort By Date', 'Sort By Rank', 'Sort By Point']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
            ],
          ),
          SizedBox(height: 5.h),
          Column(
            children: [
              ContestCard(),
              SizedBox(height: 15.w),
              ContestCard(),
              SizedBox(height: 15.w),
              ContestCard(),
              SizedBox(height: 15.w),
              ContestCard(),
              SizedBox(height: 15.w),
            ],
          )
        ],
      ),
    );
  }
}

class BorderedButtonGroup extends StatefulWidget {
  const BorderedButtonGroup({super.key});

  @override
  _BorderedButtonGroupState createState() => _BorderedButtonGroupState();
}

class _BorderedButtonGroupState extends State<BorderedButtonGroup> {
  int _selectedIndex = 0; // To keep track of the selected button
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 0),
      height: 50.w,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        border: Border.all(
          color: AppColors.textPrimaryColor.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Expanded(child: _buildButton('Contests', 0)),
          Expanded(child: _buildButton('Model Tests', 1)),
          Expanded(child: _buildButton('Custom Exams', 2)),
        ],
      ),
    );
  }

  Widget _buildButton(String title, int index) {
    return TextButton(
      onPressed: () {
        setState(() {
          _selectedIndex = index; // Update the selected index
        });
      },
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 7),
        minimumSize: const Size(0, 0),
        foregroundColor:
            _selectedIndex == index ? Colors.white : Colors.black, // Text color
        backgroundColor: _selectedIndex == index
            ? AppColors.primary
            : Colors.transparent, // Background color
        shape: RoundedRectangleBorder(
          borderRadius:
              BorderRadius.circular(30), // Rounded corners for the button
        ),
      ),
      child: Text(
        title,
        style: TextStyle(fontSize: 13.sp, fontWeight: FontWeight.w500),
        overflow: TextOverflow.ellipsis,
      ),
    );
  }
}

class ContestCard extends StatelessWidget {
  const ContestCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 14.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: AppColors.lightGray),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Section with logo and contest name
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Image.asset(
                        'assets/govt-bd.png',
                        height: 28,
                        width: 28,
                      ),
                      SizedBox(
                        width: 9.w,
                      ),
                      Text(
                        'ডিপিএসসি কনটেস্ট-০১', // Contest name
                        style: GoogleFonts.notoSansBengali(
                            textStyle: TextStyle(
                                fontSize: 15.sp,
                                color: AppColors.textPrimaryColor,
                                fontWeight: FontWeight.w600)),
                      ),
                    ],
                  ),
                  SizedBox(height: 5.w),
                  Text('বাংলা - শব্দতত্ব',
                      style: GoogleFonts.notoSansBengali(
                          textStyle: TextStyle(
                              fontSize: 14.sp,
                              color: AppColors.textPrimaryColor,
                              fontWeight: FontWeight.w600))),
                  SizedBox(height: 5.w),
                  Row(
                    children: [
                      Text(
                        '৮১',
                        style: GoogleFonts.notoSansBengali(
                            textStyle: TextStyle(
                                fontSize: 16.sp,
                                color: AppColors.textPrimaryColor,
                                fontWeight: FontWeight.w600)),
                      ),
                      Text(
                        '/১০০',
                        style: GoogleFonts.notoSansBengali(
                            textStyle: TextStyle(
                                fontSize: 14.sp,
                                color: AppColors.textPrimaryColor)),
                      ),
                    ],
                  ),
                ],
              ),
              //
              Stack(
                clipBehavior: Clip.none,
                children: [
                  SvgPicture.asset(
                    'assets/rank/rank-top.svg',
                    width: 50.w,
                  ),
                  Positioned(
                    bottom: -22.w,
                    left: 12.w,
                    child: SvgPicture.asset(
                      'assets/rank/rank-star.svg',
                      width: 25.w,
                      height: 25.h,
                    ),
                  ),
                  Positioned(
                    top: 3.w,
                    left: 15.w,
                    right: 0,
                    child: const Text(
                      '23',
                      style:
                          TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
                    ),
                  ),
                ],
              ),
            ],
          ),
          SizedBox(height: 8),
          // Time Section
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Row(
                children: [
                  Image.asset(
                    'assets/total-time.png',
                    scale: 1.5,
                  ),
                  SizedBox(width: 4.w),
                  Text('৩০ মিনিট',
                      style: GoogleFonts.notoSansBengali(
                          textStyle: TextStyle(
                              fontSize: 14.sp,
                              color: AppColors.textPrimaryColor))),
                  SizedBox(width: 10.w),
                  Image.asset(
                    'assets/contest-start.png',
                    scale: 1.5,
                  ),
                  SizedBox(width: 4.w),
                  Text('২২ ডিসেম্বর ১০:০০ AM',
                      style: GoogleFonts.notoSansBengali(
                          textStyle: TextStyle(
                              fontSize: 14.sp,
                              color: AppColors.textPrimaryColor))),
                ],
              ),
              GestureDetector(
                onTap: () {},
                child: const Text(
                  'View Details',
                  style: TextStyle(
                      color: AppColors.primary,
                      decoration: TextDecoration.underline,
                      fontWeight: FontWeight.bold,
                      decorationColor: AppColors.primary),
                  overflow: TextOverflow.ellipsis,
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
