import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../common/widgets/unified_question_navigator.dart';
import '../controller/contest_details_controller.dart';

class QuestionNavigatorFloating extends StatelessWidget {
  final VoidCallback onOpenFlaggedSheet;
  final controller = Get.find<ContestDetailsController>();
  QuestionNavigatorFloating({
    required this.onOpenFlaggedSheet,
    super.key,
  });  @override
  Widget build(BuildContext context) {
    return Obx(() {
      // Add null safety checks to prevent runtime errors
      final contestDetails = controller.contestDetails.value;
      if (contestDetails == null || 
      contestDetails.contest == null || 
      contestDetails.contest.questions == null || 
      contestDetails.contest.questions.isEmpty) {
        return const SizedBox.shrink();
      }
      
      final questions = contestDetails.contest.questions;
      final currentIndex = controller.currentQuestionIndex.value;
      final flaggedQuestions = controller.markedQuestionIds;
      final totalFlagged = flaggedQuestions.length;
        // Ensure currentIndex is within bounds
      if (questions.isEmpty || currentIndex < 0 || currentIndex >= questions.length) {
        return const SizedBox.shrink();
      }
      
      final currentQuestion = questions[currentIndex];
      final isMarked = controller.isMarkedQuestion(currentQuestion.id);

      // Create reactive properties to properly update the UI
      final RxInt markedCount = RxInt(totalFlagged);
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
        isCurrentMarked.value = controller.isMarkedQuestion(currentQuestion.id);
      });

      return UnifiedQuestionNavigator(
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
        onTap: onOpenFlaggedSheet,
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
  
  // Override controller's scrollToQuestion to ensure proper scrolling to specific questions
  static void ensureScrollToQuestion(String questionId) {
    final controller = Get.find<ContestDetailsController>();
    
    // Make sure all questions are visible by resetting filters if needed
    controller.selectedSubject.value = 'All';
    
    // Update currentQuestionIndex first to ensure the question is loaded
    final targetIndex = controller.questionIdToIndexMap[questionId] ?? 0;
    controller.currentQuestionIndex.value = targetIndex;
    
    // Give the UI time to rebuild with filter changes
    Future.delayed(const Duration(milliseconds: 150), () {
      // Try sequential scrolling method for more reliable navigation
      _incrementalScrollToQuestion(questionId, targetIndex);
    });
  }
  
  // Improved scrolling method that handles variable question heights
  static void _incrementalScrollToQuestion(String questionId, int targetIndex) {
    final controller = Get.find<ContestDetailsController>();
    if (!controller.scrollController.hasClients) return;
    
    // Get the total number of questions for boundary checks
    final questions = controller.contestDetails.value?.contest.questions ?? [];
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
    // Assume questions can be very tall (500-800px)
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
}
