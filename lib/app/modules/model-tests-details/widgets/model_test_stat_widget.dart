import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../constant/app_color.dart';

// Professional statistics item widget (top-level)
Widget statItem(IconData icon, String value, String label) {
  return Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppColors.primary.withOpacity(0.08),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: AppColors.primary, size: 28),
      ),
      const SizedBox(height: 8),
      Text(
        value,
        style:  TextStyle(
          fontSize: 14.sp,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
      ),
      const SizedBox(height: 4),
      Text(
        label,
        style:  TextStyle(
          fontSize: 11.sp,
          color: Colors.grey,
        ),
      ),
    ],
  );
}

// Format time in minutes to "HH:mm" or "mm min" (top-level)
String formatTime(dynamic totalTime) {
  if (totalTime == null || totalTime == 0) return '—';
  final minutes = int.tryParse(totalTime.toString()) ?? 0;
  if (minutes >= 60) {
    final h = minutes ~/ 60;
    final m = minutes % 60;
    return m > 0 ? '${h}h ${m}m' : '${h}h';
  }
  return '${minutes}m';
}
