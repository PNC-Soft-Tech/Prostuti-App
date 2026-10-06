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
  });

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      // Null safety checks
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

      if (questions.isEmpty ||
          currentIndex < 0 ||
          currentIndex >= questions.length) {
        return const SizedBox.shrink();
      }

      final currentQuestion = questions[currentIndex];
      final isMarked = controller.isMarkedQuestion(currentQuestion.id);

      final RxInt markedCount = RxInt(totalFlagged);
      final RxBool isCurrentMarked = RxBool(isMarked);

      // Update marked count and current marked reactively
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
          if (controller.canScrollUp.value) {
            _scrollUp();
          }
        },
        onNext: () {
          if (controller.canScrollDown.value) {
            _scrollDown();
          }
        },
        onTap: onOpenFlaggedSheet,
        canScrollUp: controller.canScrollUp,
        canScrollDown: controller.canScrollDown,
      );
    });
  }

  void _scrollUp() {
    if (!controller.scrollController.hasClients) return;

    final currentPos = controller.scrollController.position.pixels;
    final viewportHeight =
        controller.scrollController.position.viewportDimension;
    final target = (currentPos - viewportHeight).clamp(
      0.0,
      controller.scrollController.position.maxScrollExtent,
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
    final viewportHeight =
        controller.scrollController.position.viewportDimension;
    final target = (currentPos + viewportHeight).clamp(
      0.0,
      controller.scrollController.position.maxScrollExtent,
    );

    controller.scrollController.animateTo(
      target,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  // Static helpers remain unchanged...
  static void ensureScrollToQuestion(String questionId) {
    final controller = Get.find<ContestDetailsController>();

    controller.selectedSubject.value = 'All';

    final targetIndex = controller.questionIdToIndexMap[questionId] ?? 0;
    controller.currentQuestionIndex.value = targetIndex;

    Future.delayed(const Duration(milliseconds: 150), () {
      _incrementalScrollToQuestion(questionId, targetIndex);
    });
  }

  static void _incrementalScrollToQuestion(String questionId, int targetIndex) {
    final controller = Get.find<ContestDetailsController>();
    if (!controller.scrollController.hasClients) return;

    final questions = controller.contestDetails.value?.contest.questions ?? [];
    if (questions.isEmpty) return;

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

    final averageHeight = 600.0;
    double targetPosition = targetIndex * averageHeight;

    targetPosition = targetPosition.clamp(
      0.0,
      controller.scrollController.position.maxScrollExtent,
    );

    controller.scrollController.animateTo(
      targetPosition,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );

    Future.delayed(const Duration(milliseconds: 300), () {
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
