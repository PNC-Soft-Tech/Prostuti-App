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
        // Check if contest is already submitted
        final isAlreadySubmitted = contestDetails?.contest.isSubmitted == true;
        
        return Align(
          alignment: Alignment.bottomCenter,
          child: BottomFixedSubmitContestWidget(
            timeLeft: controller.formattedCountdownTime,
            currentQuestionIndex: 2, // Can be made dynamic if needed
            totalQuestions: contestDetails?.contest.questions.length ?? 0,
            isSubmitted: isAlreadySubmitted,
            onCompletePressed: isAlreadySubmitted ? null : () {
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
      }else {
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
        } else if (contestDetails.contest.isRegistered == true && 
                  (status?.isRunning == true || status?.isScheduled == true)) {
          // Registered and contest is running or scheduled - can enter
          buttonText = "Enter Now";
        } else if (contestDetails.contest.isRegistered == false && 
                  (status?.isRunning == true || status?.isScheduled == true)) {
          // Not registered but contest is running or scheduled - can register
          buttonText = "Register Now";
        } else if (status?.isDone == true) {
          // Contest is finished
          buttonText = "Contest Ended";
          isButtonEnabled = false;
        } else {
          // Default case - use registration status as fallback
          buttonText = contestDetails.contest.isRegistered == true ? "Enter Now" : "Register Now";
          isButtonEnabled = true;
        }
        
        return Align(
          alignment: Alignment.bottomCenter,
          child: CustomBottomFixedButton(
            buttonText: buttonText,
            isDisabled: !isButtonEnabled,            onPressed: () {
              if (!isButtonEnabled) return;
              
              // Prevent entering if already submitted
              if (contestDetails?.contest.isSubmitted == true) {
                Get.snackbar(
                  'Contest Already Submitted',
                  'You have already submitted this contest. Check the leaderboard for your position.',
                  snackPosition: SnackPosition.TOP,
                  backgroundColor: Colors.orange.withOpacity(0.8),
                  colorText: Colors.white,
                );
                return;
              }
              
              // Check if contest is finished
              if (status?.isDone == true) {
                Get.snackbar(
                  'Contest Ended',
                  'This contest has already ended.',
                  snackPosition: SnackPosition.TOP,
                  backgroundColor: Colors.red.withOpacity(0.8),
                  colorText: Colors.white,
                );
                return;
              }
              
              if (contestDetails?.contest.isRegistered == false) {
                // Register for contest
                Get.find<ContestController>()
                    .registerForContest(contestDetails!.contest.id);
                controller.isQuestionOpened.value = true;
              } else {
                // Enter contest (either registered or fallback case)
                controller.isQuestionOpened.value = true;
              }
            },
          ),
        );
      }
    });
  }
}