import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../common/custom_bottom_fixed_button.dart';
import '../../contests/controller/contest_controller.dart';
import '../controller/contest_details_controller.dart';
import '../widgets/exam_completed_dialog.dart';
import 'bottom_fixed_submit_contest_widget.dart';

class ContestActionWidget extends GetWidget<ContestDetailsController> {
  const ContestActionWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final status = controller.contestStatus.value;
      final isQuestionOpened = controller.isQuestionOpened.value;

      if (isQuestionOpened) {
        return Align(
          alignment: Alignment.bottomCenter,
          child: BottomFixedSubmitContestWidget(
            timeLeft: controller.formattedCountdownTime,
            currentQuestionIndex: 2, // Can be made dynamic if needed
            totalQuestions: controller.contestDetails.value?.contest.questions.length ?? 0,
            onCompletePressed: () {
              showDialog(
                context: context,
                builder: (context) => ExamCompletedDialog(
                  onSubmit: () {
                    Navigator.of(context).pop();
                    controller.submitContest(controller.contestDetails.value?.contest.id ?? '');
                  },
                ),
              );
            },
          ),
        );
      } else {
        return Align(
          alignment: Alignment.bottomCenter,
          child: CustomBottomFixedButton(
            buttonText: status?.isRunning == true &&
                    controller.contestDetails.value?.contest.isRegistered == true
                ? "Enter Now"
                : ((status?.isScheduled == true &&
                            controller.contestDetails.value?.contest.isRegistered == false) ||
                        (status?.isRunning == true &&
                            controller.contestDetails.value?.contest.isRegistered == false))
                    ? "Register Now"
                    : "Completed",
            onPressed: () {
              if (controller.contestDetails.value?.contest.isRegistered == false &&
                  (status?.isRunning == true || status?.isScheduled == true)) {
                Get.find<ContestController>()
                    .registerForContest(controller.contestDetails.value!.contest.id);
                controller.isQuestionOpened.value = true;
              } else if (status?.isDone == false || status?.isRunning == true) {
                controller.isQuestionOpened.value = true;
              }
            },
          ),
        );
      }
    });

  }}