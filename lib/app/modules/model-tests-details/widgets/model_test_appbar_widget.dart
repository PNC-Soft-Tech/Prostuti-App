// lib/modules/model_tests/widgets/model_test_app_bar.dart

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../controllers/model_test_details_controller.dart';

class ModelTestAppBar extends StatelessWidget implements PreferredSizeWidget {
  final ModelTestDetailsController controller;

  const ModelTestAppBar({
    Key? key,
    required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Obx(() => Text(
            controller.modelDetails.value?.contest.name ?? 'Model Test',
            style: TextStyle(fontSize: 18.sp),
          )),
      actions: [
        // Navigation controls
        IconButton(
          icon: const Icon(Icons.navigate_before),
          onPressed: () {
            final currentQuestionId = controller.currentSelectedModelTestId.value;
            if (currentQuestionId.isNotEmpty) {
              final prevQuestion = controller.getPreviousVisibleQuestion(currentQuestionId);
              if (prevQuestion != null) {
                controller.scrollToQuestion(prevQuestion);
              }
            }
          },
        ),
        IconButton(
          icon: const Icon(Icons.navigate_next),
          onPressed: () {
            final currentQuestionId = controller.currentSelectedModelTestId.value;
            if (currentQuestionId.isNotEmpty) {
              final nextQuestion = controller.getNextVisibleQuestion(currentQuestionId);
              if (nextQuestion != null) {
                controller.scrollToQuestion(nextQuestion);
              }
            }
          },
        ),
        
        // Timer display
        Center(
          child: Padding(
            padding: EdgeInsets.all(8.0.w),
            child: Obx(() => Text(
                  controller.formattedCountdownTime,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                  ),
                )),
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}