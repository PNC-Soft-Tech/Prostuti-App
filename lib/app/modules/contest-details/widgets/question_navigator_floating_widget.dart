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
      final questions = controller.contestDetails.value?.contest.questions ?? [];
      final currentIndex = controller.currentQuestionIndex.value;
      final flaggedQuestions = controller.markedQuestionIds;
      final totalFlagged = flaggedQuestions.length;
      final currentQuestion = questions.isNotEmpty ? questions[currentIndex] : null;

      if (questions.isEmpty || currentQuestion == null) {
        return const SizedBox.shrink();
      }

      final isMarked = controller.isMarkedQuestion(currentQuestion.id);

      // ✅ Get the nearest previous and next visible questions
      final prevVisible = controller.getPreviousVisibleQuestion(currentQuestion.id);
      final nextVisible = controller.getNextVisibleQuestion(currentQuestion.id);
  // Replace prevVisible/nextVisible with flagged navigation
  final nextFlagged = controller.getNextFlaggedQuestion(currentQuestion.id);
  final prevFlagged = controller.getPreviousFlaggedQuestion(currentQuestion.id);

      final currentFlaggedIndex = totalFlagged > 0
          ? flaggedQuestions.indexOf(currentQuestion.id) + 1
          : 0;

      return GestureDetector(
        onTap: onOpenFlaggedSheet,
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
              // ✅ Enable UP button only if a previous visible question exists
              _navButton(Icons.arrow_upward, () => controller.scrollToQuestion(prevFlagged), enabled: prevFlagged != null),
              SizedBox(height: 4.h),

              if (isMarked) const Icon(Icons.flag, color: Colors.white),
              SizedBox(height: 4.h),

              if (totalFlagged > 0)
                Text(
                  "$currentFlaggedIndex / $totalFlagged",
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14.sp),
                )
              else
                Text(
                  "${currentIndex + 1} / ${questions.length}",
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14.sp),
                ),

              SizedBox(height: 4.h),

              // ✅ Enable DOWN button only if a next visible question exists
              _navButton(Icons.arrow_downward, () => controller.scrollToQuestion(nextFlagged), enabled: nextFlagged != null),
            ],
          ),
        ),
      );
    });
  }

  /// ✅ Navigation Button Widget
  Widget _navButton(IconData icon, VoidCallback onPressed, {required bool enabled}) {
    return IconButton(
      icon: Icon(icon, color: enabled ? Colors.white : Colors.white.withOpacity(0.5)),
      onPressed: enabled ? onPressed : null,
      constraints: const BoxConstraints(),
      padding: EdgeInsets.zero,
    );
  }

  /// ✅ Scroll to a Specific Question
  // void _scrollToQuestion(String? questionId) {
  //   if (questionId != null) {
  //     controller.scrollToQuestion(questionId);
  //   }
  // }

void _scrollToQuestion(String? questionId) async {
  if (questionId == null) return;

  final controller = Get.find<ContestDetailsController>();
  
  // Always reset filter first
  controller.selectedSubject.value = 'All';
  
  // Wait for UI rebuild
  await Future.delayed(Duration(milliseconds: 50));

  final context = controller.questionKeys[questionId]?.currentContext;
  if (context == null) return;

  Scrollable.ensureVisible(
    context,
    duration: Duration(milliseconds: 500),
    curve: Curves.easeInOut,
    alignment: 0.1, // Adjust this value (0.0 = top, 0.5 = center)
  );
}
}
