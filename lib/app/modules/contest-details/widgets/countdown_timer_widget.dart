import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controller/contest_details_controller.dart';

class CountDownTimerWidget extends StatelessWidget {
  final ContestDetailsController controller = Get.find();

  CountDownTimerWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Row(
        children: [
          Icon(Icons.access_time, color: Colors.blue, size: 20.sp),
          SizedBox(width: 5.w),
          Text(
            "Time Left: ${_formatDuration(controller.remainingTime.value)}",
            style: GoogleFonts.inter(
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
              color: Colors.blue.shade800,
            ),
          ),
        ],
      );
    });
  }

  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    return "$minutes : $seconds";
  }
}
