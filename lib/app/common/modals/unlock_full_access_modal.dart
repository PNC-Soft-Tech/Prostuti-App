import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class UnlockFullAccessDialog {
  // Private constructor to prevent instantiation
  UnlockFullAccessDialog._();

  // Static method to show the dialog
  static void show() {
    Get.dialog(
      Dialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(

          borderRadius: BorderRadius.circular(16),
        ),
        child: Container(
          // color: Colors.white,
          padding: EdgeInsets.symmetric(vertical: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Close button
              Align(
                alignment: Alignment.topRight,
                child: Padding(
                  padding: EdgeInsets.only(right: 10),
                  child: IconButton(
                    icon: Icon(Icons.close, color: Colors.grey, size: 28.sp,),
                    onPressed: () => Get.back(),
                    constraints: BoxConstraints(),
                    padding: EdgeInsets.zero,
                  ),
                ),
              ),

              // Crown icon
              // Icon(
              //   Icons.military_tech_outlined,
              //   color: Colors.blue,
              //   size: 64,
              // ),
              Image.asset("assets/unlock.png"),
              // Title
              Padding(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Text(
                  'Unlock Full Access',
                  style: GoogleFonts.inter(
                      textStyle: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF212D40),
                  )),
                ),
              ),

              // Description
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Text(
                  'Upgrade to premium to unlock explanations and enhance your understanding.',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(
                      textStyle: TextStyle(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w400,
                    color: Color(0xFF212D40),
                  )),
                ),
              ),

              // Subtitle
              Padding(
                padding: EdgeInsets.only(top: 10, bottom: 20),
                child: Text(
                  'Don\'t let blurred answers stop you!',
                  style: GoogleFonts.inter(
                      textStyle: TextStyle(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF50AFFF),
                  )),
                ),
              ),

              // Upgrade Button
              ElevatedButton(
                onPressed: () {
                  // Add upgrade logic here
                  Get.back(); // Close dialog
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: Text(
                  'Upgrade Now',
                  style: GoogleFonts.inter(
                      textStyle: TextStyle(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  )),
                ),
              ),
            ],
          ),
        ),
      ),
      barrierDismissible: true,
    );
  }
}
