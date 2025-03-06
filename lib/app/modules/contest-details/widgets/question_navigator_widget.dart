import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../controller/contest_details_controller.dart';

class QuestionNavigatorFloating extends StatelessWidget {
  final VoidCallback onOpenFlaggedSheet;

  final controller = Get.find<ContestDetailsController>();

  QuestionNavigatorFloating({
    required this.onOpenFlaggedSheet,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final questions = controller.contestDetails.value?.contest?.questions ?? [];
      final currentIndex = controller.currentQuestionIndex.value;

      if (questions.isEmpty || currentIndex < 0 || currentIndex >= questions.length) {
        return SizedBox.shrink(); // Guard if invalid
      }

      final currentQuestion = questions[currentIndex];
      final isMarked = controller.isMarkedQuestion(currentQuestion.id);

      return GestureDetector(
        onTap: onOpenFlaggedSheet, // Open flagged question bottomsheet
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
              _navButton(Icons.arrow_upward, () => _navigateToPreviousQuestion(), enabled: currentIndex > 0),
              SizedBox(height: 4.h),
              if (isMarked) Icon(Icons.flag, color: Colors.white),
              SizedBox(height: 4.h),
              Text(
                "${currentIndex + 1} / ${questions.length}",
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14.sp),
              ),
              SizedBox(height: 4.h),
              _navButton(Icons.arrow_downward, () => _navigateToNextQuestion(), enabled: currentIndex < questions.length - 1),
            ],
          ),
        ),
      );
    });
  }

  Widget _navButton(IconData icon, VoidCallback onPressed, {required bool enabled}) {
    return IconButton(
      icon: Icon(icon, color: enabled ? Colors.white : Colors.white.withOpacity(0.5)),
      onPressed: enabled ? onPressed : null,
      constraints: const BoxConstraints(),
      padding: EdgeInsets.zero,
    );
  }

  void _navigateToPreviousQuestion() {
    if (controller.currentQuestionIndex.value > 0) {
      controller.currentQuestionIndex.value -= 1;
      _scrollToCurrentQuestion();
    }
  }

  void _navigateToNextQuestion() {
    final totalQuestions = controller.contestDetails.value?.contest?.questions.length ?? 0;
    if (controller.currentQuestionIndex.value < totalQuestions - 1) {
      controller.currentQuestionIndex.value += 1;
      _scrollToCurrentQuestion();
    }
  }

  void _scrollToCurrentQuestion() {
    final currentQuestion = controller.questionAtIndex(controller.currentQuestionIndex.value);
    if (currentQuestion != null) {
      controller.scrollToQuestion(currentQuestion.id);
    }
  }
}
