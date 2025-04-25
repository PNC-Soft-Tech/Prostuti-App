import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:prostuti/app/modules/contest-details/widgets/exam_completed_dialog.dart';

import '../../../common/custom_bottom_fixed_button.dart';
import '../../contests/controller/contest_controller.dart';
import '../controller/contest_details_controller.dart';
import 'bottom_fixed_submit_contest_widget.dart';

class ContestActionWidget extends GetWidget<ContestDetailsController> {
  const ContestActionWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final status = controller.contestStatus.value;
      final isQuestionOpened = controller.isQuestionOpened.value;
      final contestDetails = controller.contestDetails.value;
      
      // If questions are opened, show the submit widget
      if (isQuestionOpened) {
        return Align(
          alignment: Alignment.bottomCenter,
          child: BottomFixedSubmitContestWidget(
            timeLeft: controller.formattedCountdownTime,
            currentQuestionIndex: 2, // Can be made dynamic if needed
            totalQuestions: contestDetails?.contest.questions.length ?? 0,
            onCompletePressed: () {
              showDialog(
                context: context,
                builder: (context) => ExamCompletedDialog(
                  onSubmit: () {
                    Navigator.of(context).pop();
                    controller.submitContest(contestDetails?.contest.id ?? '');
                  },
                ),
              );
            },
          ),
        );
      } else {
        // Determine button text based on contest state
        String buttonText;
        bool isButtonEnabled = true;
        
        if (contestDetails == null) {
          // Contest details not yet loaded
          buttonText = "Loading...";
          isButtonEnabled = false;
        } else if (contestDetails.contest.isSubmitted == true) {
          // Contest already completed
          buttonText = "Completed";
          isButtonEnabled = false;
        } else if (contestDetails.contest.isRegistered == true && status?.isRunning == true) {
          // Registered and contest is running - can enter
          buttonText = "Enter Now";
        } else if (contestDetails.contest.isRegistered == false && 
                  (status?.isRunning == true || status?.isScheduled == true)) {
          // Not registered but contest is running or scheduled - can register
          buttonText = "Register Now";
        } else {
          // Default case (e.g., contest is done but not submitted)
          buttonText = "Loading...";
          isButtonEnabled = false;
        }
        
        return Align(
          alignment: Alignment.bottomCenter,
          child: CustomBottomFixedButton(
            buttonText: buttonText,
            isDisabled: !isButtonEnabled,
            onPressed: () {
              if (!isButtonEnabled) return;
              
              if (contestDetails?.contest.isRegistered == false &&
                  (status?.isRunning == true || status?.isScheduled == true)) {
                // Register for contest
                Get.find<ContestController>()
                    .registerForContest(contestDetails!.contest.id);
                controller.isQuestionOpened.value = true;
              } else if (contestDetails?.contest.isRegistered == true && 
                        (status?.isRunning == true || status?.isDone == false)) {
                // Enter contest
                controller.isQuestionOpened.value = true;
              }
            },
          ),
        );
      }
    });
  }
}