// lib/modules/model_tests/widgets/question_navigator_widget.dart

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../controllers/model_test_details_controller.dart';

class QuestionNavigatorWidget extends StatelessWidget {
  final ModelTestDetailsController controller;

  const QuestionNavigatorWidget({
    Key? key,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (!controller.isQuestionOpened.value) {
        return const SizedBox.shrink();
      }

      final questions = controller.modelDetails.value?.contest.questions ?? [];
      final currentIndex = controller.currentQuestionIndex.value;
      final totalQuestions = questions.length;
      final markedQuestions = controller.markedQuestionIds;
      final totalMarked = markedQuestions.length;
      
      if (totalQuestions == 0) return const SizedBox.shrink();
      
      final currentQuestion = questions[currentIndex];
      final isMarked = controller.isMarkedQuestion(currentQuestion.id);
      
      // Get navigation questions
      final prevQuestion = controller.getPreviousVisibleQuestion(currentQuestion.id);
      final nextQuestion = controller.getNextVisibleQuestion(currentQuestion.id);

      return GestureDetector(
        onTap: () => _showFlaggedQuestionsSheet(context),
        child: Container(
          width: 60.w,
          padding: EdgeInsets.symmetric(vertical: 12.h),
          decoration: BoxDecoration(
            color: const Color(0xFFFF8143),
            borderRadius: BorderRadius.circular(30.r),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Up navigation
              IconButton(
                icon: Icon(
                  Icons.arrow_upward,
                  color: prevQuestion != null ? Colors.white : Colors.white38,
                ),
                onPressed: prevQuestion != null
                    ? () => controller.scrollToQuestion(prevQuestion)
                    : null,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
              
              SizedBox(height: 8.h),
              
              // Flag indicator
              if (isMarked) 
                const Icon(Icons.flag, color: Colors.white),
              
              SizedBox(height: 8.h),
              
              // Question counter
              Text(
                totalMarked > 0
                    ? "$totalMarked marked"
                    : "${currentIndex + 1} / $totalQuestions",
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              
              SizedBox(height: 8.h),
              
              // Down navigation
              IconButton(
                icon: Icon(
                  Icons.arrow_downward,
                  color: nextQuestion != null ? Colors.white : Colors.white38,
                ),
                onPressed: nextQuestion != null
                    ? () => controller.scrollToQuestion(nextQuestion)
                    : null,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ],
          ),
        ),
      );
    });
  }

  void _showFlaggedQuestionsSheet(BuildContext context) {
    final flaggedIds = controller.markedQuestionIds;
    
    if (flaggedIds.isEmpty) {
      Get.snackbar('No Marked Questions', 'You haven\'t marked any questions yet');
      return;
    }
    
    Get.bottomSheet(
      Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Marked Questions',
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16.h),
            Wrap(
              spacing: 12.w,
              runSpacing: 12.h,
              children: flaggedIds.map((id) {
                final index = controller.questionIdToIndexMap[id] ?? -1;
                if (index == -1) return const SizedBox.shrink();
                
                return GestureDetector(
                  onTap: () {
                    Get.back();
                    controller.scrollToQuestion(id);
                  },
                  child: Container(
                    width: 50.w,
                    height: 50.w,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFF8143),
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Center(
                      child: Text(
                        '${index + 1}',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16.sp,
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
      isScrollControlled: true,
    );
  }
}