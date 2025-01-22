import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../constant/app_color.dart';
import '../controller/search_controller.dart';

class SearchInputWidget extends GetWidget<SearchPageController> {
  const SearchInputWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50.r),
          border: Border.all(color: const Color(0xFFE9E9E9), width: 1)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Row(
              children: [
                Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 11.w, vertical: 11.w),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50.r),
                        color: AppColors.primary),
                    child: Icon(
                      Icons.search,
                      color: Colors.white,
                      size: 11.r,
                    )),
                SizedBox(
                  width: 9.w,
                ),
                Expanded(
                  child: TextFormField(
                    controller: controller.searchController,
                    decoration: InputDecoration(
                      hintText: "Search ", // Placeholder text
                      hintStyle: GoogleFonts.inter(
                          textStyle: TextStyle(
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w300,
                              color: AppColors.lightGray)),
                      border: InputBorder.none, // Customize as needed
                    ),
                    style: GoogleFonts.inter(
                        textStyle: TextStyle(
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w300,
                            color: AppColors.primary)),
                  ),
                ),
              ],
            ),
          ),
          Container(
              padding: EdgeInsets.symmetric(horizontal: 11.w, vertical: 11.w),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50.r),
                  color: const Color(0xFFA3A9B6)),
              child: Icon(
                Icons.mic,
                color: Colors.white,
                size: 16.r,
              )),
        ],
      ),
    );
  }
}
