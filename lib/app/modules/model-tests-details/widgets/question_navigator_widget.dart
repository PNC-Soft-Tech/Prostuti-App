// lib/modules/model_tests/widgets/question_navigator_widget.dart

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../common/widgets/unified_question_navigator.dart';
import '../controllers/model_test_details_controller.dart';

class QuestionNavigatorWidget extends StatelessWidget {
  const QuestionNavigatorWidget({
    Key? key,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GetX<ModelTestDetailsController>(
      builder: (controller) {        
        // Wrap in try-catch to handle any null reference errors
        try {
          // Use null-safe access
          final isLoading = controller.isLoading.value;
          final modelDetailsValue = controller.modelDetails.value;
          
          // Check if controller is loading or data is not ready
          if (isLoading || modelDetailsValue == null) {
            return const SizedBox.shrink();
          }
      
      // Make sure we have questions to display
      final questions = controller.filteredQuestions;
      if (questions.isEmpty) return const SizedBox.shrink();
      
      // Ensure currentIndex is valid
      int currentIndex = controller.currentQuestionIndex.value;
      if (currentIndex < 0 || currentIndex >= questions.length) {
        currentIndex = 0;
        // Only update if needed to avoid loops
        if (controller.currentQuestionIndex.value != currentIndex) {
          controller.currentQuestionIndex.value = currentIndex;
        }
      }
      
      // Get current question details - safely handle null case
      final currentQuestion = questions.isNotEmpty ? questions[currentIndex] : null;
      
      // Initialize with defaults in case currentQuestion is null
      bool isMarked = false;
      int totalMarked = controller.markedQuestionIds.length;
      
      // Only check for marking if we have a valid question
      if (currentQuestion != null) {
        isMarked = controller.isMarkedQuestion(currentQuestion.id);
      }
      
      // If no questions are visible, update the list
      if (controller.visibleQuestions.isEmpty && questions.isNotEmpty) {
        controller.updateVisibleQuestions(questions.map((q) => q.id).toList());
      }
      
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
      });        return UnifiedQuestionNavigator(
          currentIndex: controller.currentQuestionIndex,
          totalQuestions: questions.length,
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
        } catch (e) {
          // Handle any null reference or other errors gracefully
          return const SizedBox.shrink();
        }
      },
    );
  }
    void _scrollUp() {
    final controller = Get.find<ModelTestDetailsController>();
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
    final controller = Get.find<ModelTestDetailsController>();
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
    final controller = Get.find<ModelTestDetailsController>();
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
  }    // Improved scrolling method that handles variable question heights
  void _incrementalScrollToQuestion(String questionId, int targetIndex) {
    final controller = Get.find<ModelTestDetailsController>();
    if (!controller.scrollController.hasClients) return;
    
    // Check if controller is properly initialized
    if (controller.modelDetails.value == null) return;
    
    // Get the total number of questions for boundary checks
    final questions = controller.modelDetails.value?.contest.questions ?? [];
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
    });}
  void _showFlaggedQuestionsSheet(BuildContext context) {
    final controller = Get.find<ModelTestDetailsController>();
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