import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

/// A unified question navigator widget that displays current question position
/// and allows navigation between questions
class UnifiedQuestionNavigator extends StatelessWidget {
  /// Controller must implement these methods and properties
  final RxInt currentIndex;
  final int totalQuestions;
  final RxInt totalMarked;
  final RxBool isCurrentMarked;
  final VoidCallback onPrevious;
  final VoidCallback onNext;
  final VoidCallback? onTap;
  final RxBool canScrollUp;
  final RxBool canScrollDown;

  const UnifiedQuestionNavigator({
    Key? key,
    required this.currentIndex,
    required this.totalQuestions,
    required this.totalMarked,
    required this.isCurrentMarked,
    required this.onPrevious,
    required this.onNext,
    this.onTap,
    required this.canScrollUp,
    required this.canScrollDown,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 60.w,
        padding: EdgeInsets.symmetric(vertical: 10.h),
        decoration: BoxDecoration(
          color: const Color(0xFFFF8143),
          borderRadius: BorderRadius.circular(30.r),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // UP button
            Obx(() => _navButton(
              Icons.arrow_upward, 
              onPrevious, 
              enabled: canScrollUp.value
            )),
            SizedBox(height: 4.h),

            // Flag icon for marked questions
            Obx(() => isCurrentMarked.value 
              ? const Icon(Icons.flag, color: Colors.white)
              : SizedBox(height: 24)),
            SizedBox(height: 4.h),

            // Question counter
            Obx(() {
              // Show total marked count if we have marked questions
              if (totalMarked.value > 0) {
                return Text(
                  "${totalMarked.value}/${totalQuestions}",
                  style: TextStyle(
                    color: Colors.white, 
                    fontWeight: FontWeight.bold, 
                    fontSize: 14.sp
                  ),
                );
              }
              
              // Otherwise show current position
              return Text(
                "${currentIndex.value + 1}/${totalQuestions}",
                style: TextStyle(
                  color: Colors.white, 
                  fontWeight: FontWeight.bold, 
                  fontSize: 14.sp
                ),
              );
            }),

            SizedBox(height: 4.h),

            // DOWN button
            Obx(() => _navButton(
              Icons.arrow_downward, 
              onNext, 
              enabled: canScrollDown.value
            )),
          ],
        ),
      ),
    );
  }

  /// Navigation button widget
  Widget _navButton(IconData icon, VoidCallback onPressed, {required bool enabled}) {
    return IconButton(
      icon: Icon(icon, color: enabled ? Colors.white : Colors.white.withOpacity(0.5)),
      onPressed: enabled ? onPressed : null,
      constraints: const BoxConstraints(),
      padding: EdgeInsets.zero,
    );
  }
} 