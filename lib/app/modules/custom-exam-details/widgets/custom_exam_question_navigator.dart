import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../common/widgets/unified_question_navigator.dart';
import '../controller/custom_exam_details_controller.dart';

class CustomExamQuestionNavigator extends StatelessWidget {
  final CustomExamDetailsController controller = Get.find<CustomExamDetailsController>();

  CustomExamQuestionNavigator({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      // If questions aren't open, don't show the navigator
      if (!controller.isQuestionOpened.value) {
        return const SizedBox.shrink();
      }

      final questions = controller.customExamDetails.value?.contest.questions ?? [];
      final currentIndex = controller.currentQuestionIndex.value;
      final totalQuestions = questions.length;
      final markedQuestions = controller.markedQuestionIds;
      final totalMarked = markedQuestions.length;
      
      if (totalQuestions == 0) return const SizedBox.shrink();
      
      // Add null safety to prevent null exception
      final currentQuestion = currentIndex < questions.length ? questions[currentIndex] : null;
      final isMarked = currentQuestion != null ? controller.isMarkedQuestion(currentQuestion.id) : false;
      
      // Create reactive properties to properly update the UI
      final RxInt markedCount = RxInt(totalMarked);
      final RxBool isCurrentMarked = RxBool(isMarked);
      
      // Scroll position reactive values
      final RxBool canScrollUp = RxBool(false);
      final RxBool canScrollDown = RxBool(false);
      
      // Update scroll position values whenever the scroll controller changes position
      if (controller.scrollController.hasClients) {
        canScrollUp.value = controller.scrollController.position.pixels > 0;
        canScrollDown.value = controller.scrollController.position.pixels < 
                              controller.scrollController.position.maxScrollExtent;
        
        // Listen to scroll controller changes
        controller.scrollController.addListener(() {
          canScrollUp.value = controller.scrollController.position.pixels > 0;
          canScrollDown.value = controller.scrollController.position.pixels < 
                                controller.scrollController.position.maxScrollExtent;
        });
      }

      // Listen to changes in the marked questions list
      ever(controller.markedQuestionIds, (_) {
        markedCount.value = controller.markedQuestionIds.length;
        if (currentQuestion != null) {
          isCurrentMarked.value = controller.isMarkedQuestion(currentQuestion.id);
        }
      });

      return UnifiedQuestionNavigator(
        currentIndex: controller.currentQuestionIndex,
        totalQuestions: totalQuestions,
        totalMarked: markedCount,
        isCurrentMarked: isCurrentMarked,
        onPrevious: () {
          if (canScrollUp.value) {
            _scrollUp();
          }
        },
        onNext: () {
          if (canScrollDown.value) {
            _scrollDown();
          }
        },
        onTap: () => _showFlaggedQuestionsSheet(context),
        canScrollUp: canScrollUp,
        canScrollDown: canScrollDown,
      );
    });
  }
  
  void _scrollUp() {
    if (!controller.scrollController.hasClients) return;
    
    final currentPos = controller.scrollController.position.pixels;
    final viewportHeight = controller.scrollController.position.viewportDimension;
    final target = (currentPos - viewportHeight).clamp(
      0.0, 
      controller.scrollController.position.maxScrollExtent
    );
    
    controller.scrollController.animateTo(
      target,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }
  
  void _scrollDown() {
    if (!controller.scrollController.hasClients) return;
    
    final currentPos = controller.scrollController.position.pixels;
    final viewportHeight = controller.scrollController.position.viewportDimension;
    final target = (currentPos + viewportHeight).clamp(
      0.0, 
      controller.scrollController.position.maxScrollExtent
    );
    
    controller.scrollController.animateTo(
      target,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }
  
  // Enhanced scrolling method for more reliable navigation to specific questions
  void _ensureScrollToQuestion(String questionId) {
    // Make sure all questions are visible by resetting filters if needed  
    controller.selectedSubject.value = 'All';
    
    // Update currentQuestionIndex first to ensure the question is loaded
    final targetIndex = controller.questionIdToIndexMap[questionId] ?? 0;
    controller.currentQuestionIndex.value = targetIndex;
    
    // Give the UI time to rebuild with filter changes
    Future.delayed(const Duration(milliseconds: 150), () {
      // Try incremental scrolling method for more reliable navigation
      _incrementalScrollToQuestion(questionId, targetIndex);
    });
  }
  
  // Improved scrolling method that handles variable question heights
  void _incrementalScrollToQuestion(String questionId, int targetIndex) {
    if (!controller.scrollController.hasClients) return;
    
    // Get the total number of questions for boundary checks
    final questions = controller.customExamDetails.value?.contest.questions ?? [];
    if (questions.isEmpty) return;
    
    // First attempt: Try direct scroll using context if available
    final questionKey = controller.questionKeys[questionId];
    if (questionKey?.currentContext != null) {
      Scrollable.ensureVisible(
        questionKey!.currentContext!,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
        alignment: 0.1,
      );
      return;
    }
    
    // Second attempt: If context isn't available, use a smarter scrolling approach
    // Calculate a variable height estimation based on question position
    // Assume questions can be very tall
    final averageHeight = 600.0; // Higher estimate for potentially taller questions
    
    // Start with a rough position estimate
    double targetPosition = targetIndex * averageHeight;
    
    // Ensure we don't exceed scroll bounds
    targetPosition = targetPosition.clamp(
      0.0, 
      controller.scrollController.position.maxScrollExtent
    );
    
    // Scroll to the estimated position
    controller.scrollController.animateTo(
      targetPosition,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
    
    // Add a follow-up check to refine the position if needed
    Future.delayed(const Duration(milliseconds: 300), () {
      // Try again with context after initial scroll
      final updatedKey = controller.questionKeys[questionId];
      if (updatedKey?.currentContext != null) {
        Scrollable.ensureVisible(
          updatedKey!.currentContext!,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          alignment: 0.1,
        );
      }
    });
  }
  
  // Legacy method preserved for compatibility
  void _directScrollToQuestion(String questionId, int questionIndex) {
    if (!controller.scrollController.hasClients) return;
    
    // Use a larger height estimate for potentially taller questions
    final estimatedPosition = questionIndex * 600.0;
    
    // Scroll to the estimated position
    controller.scrollController.animateTo(
      estimatedPosition.clamp(0.0, controller.scrollController.position.maxScrollExtent),
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
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
            Obx(() => Wrap(
              spacing: 12.w,
              runSpacing: 12.h,
              children: flaggedIds.map((id) {
                final index = controller.questionIdToIndexMap[id] ?? -1;
                if (index == -1) return const SizedBox.shrink();
                
                return GestureDetector(
                  onTap: () {
                    Get.back();
                    _ensureScrollToQuestion(id); // Use the enhanced navigation method
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
            )),
          ],
        ),
      ),
      isScrollControlled: true,
    );
  }
} 