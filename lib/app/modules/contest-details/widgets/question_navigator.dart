import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../controller/contest_details_controller.dart';
import '../widgets/show_flagged_questions_bottomsheet_widget.dart';
import 'question_navigator_widget.dart';

class QuestionNavigatorWidget extends GetWidget<ContestDetailsController> {
  const QuestionNavigatorWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isQuestionOpened.value) {
        return Positioned(
          right: 16.w,
          bottom: 100.h,
          child: QuestionNavigatorFloating(
            onOpenFlaggedSheet: () => showFlaggedQuestionsBottomSheet(controller.markedQuestionIds),
          ),
        );
      }
      return const SizedBox.shrink(); // If not opened, don't show
    });
  }
}
