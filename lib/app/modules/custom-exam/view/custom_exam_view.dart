import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../common/custom_simple_appbar.dart';
import '../controller/custom_exam_controller.dart';

class CustomExamView extends GetView<CustomExamController> {
  const CustomExamView({super.key});

  @override
  Widget build(BuildContext context) {
    Color txtColor = Color(0xFF7B7B7B);
    return Scaffold(
      appBar: CustomSimpleAppBar.appBar(title: 'Custom Exam'),
      body: Obx(() {
        // if (controller.isLoading.value) {
        //   return const Center(child: CircularProgressIndicator());
        // }

        // if (controller.contests.isEmpty) {
        //   return const Center(child: Text('No contests available'));
        // }

        return !controller.isLoading.value
            ? Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Subject Dropdown
                      Text(
                        "Subject 1",
                        style: GoogleFonts.inter(
                            textStyle: TextStyle(
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w400,
                                color: txtColor)),
                      ),
                      SizedBox(height: 8.h),
                      DropdownButtonFormField<String>(
                        decoration: InputDecoration(
                          hintText: "ex: English",
                          hintStyle: GoogleFonts.inter(
                              textStyle: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 14.sp,
                                  fontStyle: FontStyle.italic)),
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 18.h, horizontal: 16.w),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(50.r),
                          ),
                        ),
                        items: [
                          DropdownMenuItem(
                              value: "English", child: Text("English")),
                          DropdownMenuItem(value: "Math", child: Text("Math")),
                          DropdownMenuItem(
                              value: "Science", child: Text("Science")),
                        ],
                        onChanged: (value) {},
                      ),
                      SizedBox(height: 16.h),

                      // Topic and Questions Row
                      Row(
                        children: [
                          // Topic Field

                          Expanded(
                            flex: 2,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Topic 1",
                                  style: GoogleFonts.inter(
                                      textStyle: TextStyle(
                                          fontSize: 12.sp,
                                          fontWeight: FontWeight.w400,
                                          color: txtColor)),
                                ),
                                SizedBox(height: 8.h),
                                TextFormField(
                                  decoration: InputDecoration(
                                    hintText: "ex: Tense",
                                    hintStyle: GoogleFonts.inter(
                                        textStyle: TextStyle(
                                            fontWeight: FontWeight.w400,
                                            fontSize: 14.sp,
                                            fontStyle: FontStyle.italic)),
                                    contentPadding: EdgeInsets.symmetric(
                                        vertical: 18.h, horizontal: 16.w),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(50.r),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: 8.w),
                          // Questions Field

                          Expanded(
                            flex: 1,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Questions",
                                  style: GoogleFonts.inter(
                                      textStyle: TextStyle(
                                          fontSize: 12.sp,
                                          fontWeight: FontWeight.w400,
                                          color: txtColor)),
                                ),
                                SizedBox(height: 8.h),
                                TextFormField(
                                  decoration: InputDecoration(
                                    hintText: "ex: 10",
                                    hintStyle: GoogleFonts.inter(
                                        textStyle: TextStyle(
                                            fontWeight: FontWeight.w400,
                                            fontSize: 14.sp,
                                            fontStyle: FontStyle.italic)),
                                    contentPadding: EdgeInsets.symmetric(
                                        vertical: 18.h, horizontal: 16.w),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(50.r),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16.h),

                      // Add Topic Button

                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50.r),
                            color: Color(0xFFA1A1A1),
                            border:
                                Border.all(width: 1, color: Color(0xFFA1A1A1))),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.add, color: Colors.white,), 
                            SizedBox(width: 5.w),
                            Text(
                              "Add Topic",
                              style: GoogleFonts.inter(
                                  textStyle: TextStyle(
                                      fontSize: 13.sp,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white)),
                            ),
                          ],
                        ),
                      ),
                   
                      SizedBox(height: 24.h),

                      // Add Subject Button
                   
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50.r),
                            color: Color(0xFF50BDB4),
                            border:
                                Border.all(width: 1, color: Color(0xFF50BDB4))),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.add, color: Colors.white,), 
                            SizedBox(width: 5.w),
                            Text(
                              "Add Subject",
                              style: GoogleFonts.inter(
                                  textStyle: TextStyle(
                                      fontSize: 13.sp,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white)),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              )
            : Wrap();
      }),
    );
  }
}
