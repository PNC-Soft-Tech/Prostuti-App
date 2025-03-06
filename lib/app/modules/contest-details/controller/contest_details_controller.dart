import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../APIs/api_helper.dart';
import '../../../common/utils/prostuti_utils.dart';
import '../../../routes/app_pages.dart';
import '../../contests/models/contest_model.dart';
import '../../contests/models/contest_status.dart';
import '../../questions/models/question_model.dart';
import '../models/contest_details_model.dart';

class ContestDetailsController extends GetxController {
  final ApiHelper _apiHelper = Get.find<ApiHelper>();
  var contestId = ''.obs;
  var contests = <Contest>[].obs;
  var contest = Rxn<Contest>();
  var contestDetails = Rxn<ContestDetailsResponse>();
  final RxMap<String, String> selectedAnswers = <String, String>{}.obs;
  final markedQuestions = <String>[].obs;
  // final markedQuestions = <int>[].obs; // Store **question indexes**
  final currentQuestionIndex = 0.obs; // Track current question

  final isSubmittingContest =
      false.obs; // This will track loading state for submitContest

  var isLoading = false.obs;
  final RxMap<String, bool> questionLoadingStatus = <String, bool>{}.obs;
  Rx<Duration> remainingTime = const Duration().obs;
  Timer? _timer;
  Rx<ContestStatus?> contestStatus = Rx<ContestStatus?>(null);

  RxBool isContestRunning = true.obs;
  RxBool isQuestionOpened = false.obs;
  final scrollController = ScrollController();
  final questionKeys = <String, GlobalKey>{}.obs;
  final questionIdToIndexMap = <String, int>{}.obs;
  final markedQuestionIndexes = <int>[].obs; // For UI scroll
  final markedQuestionIds = <String>[].obs; // For API call if needed
  @override
  void onInit() {
    super.onInit();
    final Map<String, dynamic> arguments = Get.arguments;
    contestId.value = arguments["contestId"]; // Retrieve contestId
    fetchContestDetails(contestId.value);
    ever<int>(currentQuestionIndex, (index) {
      scrollController.animateTo(
        index * 300.h, // Approx height per question, tune if needed
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    });
  }

  void setUpQuestionKeysAndIndexes(List<Question> questions) {
    questionKeys.clear();
    questionIdToIndexMap.clear();

    for (int i = 0; i < questions.length; i++) {
      final question = questions[i];
      questionKeys[question.id] = GlobalKey();
      questionIdToIndexMap[question.id] = i;
    }
  }

  void scrollToQuestion(String questionId) {
    final index = questionIdToIndexMap[questionId];
    if (index == null) return;

    scrollController.animateTo(
      questionKeys[questionId]!.currentContext!.size!.height * index,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  void fetchContestDetails(String contestId) async {
    isLoading.value = true;

    final result = await _apiHelper.fetchSingleContest(contestId);

    result.fold(
      (error) {
        isLoading.value = false;
        log('Error fetching contest details: ${error.message}');
      },
      (data) {
        contestDetails.value = data;
        updateContestStatus();
        setUpQuestionKeysAndIndexes(
            contestDetails.value?.contest.questions ?? []);
        startTimer(data.contest.startContest, data.contest.endContest);
        isLoading.value = false;
      },
    );
  }

  void updateContestStatus() {
    final contest = contestDetails.value?.contest;
    if (contest != null) {
      contestStatus.value =
          Utils.getContestStatus(contest.startContest, contest.endContest);
    }
  }

  void selectOption(String questionId, String selectedOptionOrder) {
    selectedAnswers[questionId] =
        selectedOptionOrder; // ✅ Track selection per question
  }

  bool isOptionSelected(String questionId, String optionOrder) {
    return selectedAnswers[questionId] == optionOrder;
  }

  // void markQuestion(String questionId) {
  //   markedQuestions.add(questionId);
  // }

  // void markUnmarkQuestion(int index) {
  //   if (markedQuestions.contains(index)) {
  //     markedQuestions.remove(index);
  //   } else {
  //     markedQuestions.add(index);
  //   }
  // }
// void markUnmarkQuestion(String questionId) {
//   if (markedQuestions.contains(questionId)) {
//     markedQuestions.remove(questionId);
//   } else {
//     markedQuestions.add(questionId);
//   }
// }
  void markUnmarkQuestion(String questionId) {
    final index = questionIdToIndexMap[questionId] ?? -1;
    if (index == -1) return;

    if (markedQuestionIndexes.contains(index)) {
      markedQuestionIndexes.remove(index);
      markedQuestionIds.remove(questionId);
    } else {
      markedQuestionIndexes.add(index);
      markedQuestionIds.add(questionId);
    }
  }

  // void unMarkQuestion(String questionId) {
  //   markedQuestions.remove(questionId);
  // }

  bool isMarkedQuestion(String questionId) {
    return markedQuestionIds.contains(questionId);
  }

  Question? questionAtIndex(int index) {
    final questions = contestDetails.value?.contest.questions ?? [];
    if (index < 0 || index >= questions.length) return null;
    return questions[index];
  }

  List<Map<String, dynamic>> prepareSubmissionPayload(String contestId) {
    return selectedAnswers.entries.map((entry) {
      return {
        "question": entry.key,
        "contest": contestId,
        "selectedAnswer": entry.value,
      };
    }).toList();
  }

  Future<bool> submitAnswer(
      String questionId, String contestId, String selectedAnswer) async {
    // 2️⃣ Set loading for this specific question
    questionLoadingStatus[questionId] = true;

    final result = await _apiHelper.submitContestAnswer(
      questionId: questionId,
      contestId: contestId,
      selectedAnswer: selectedAnswer,
    );

    // 2️⃣ Set loading for this specific question
    questionLoadingStatus[questionId] = false;

    bool isSuccess = false; // Add this flag

    result.fold(
      (error) {
        Get.snackbar('Error', 'Something went wrong' ?? 'Something went wrong');
        isSuccess = false; // Set flag in case of error
      },
      (response) {
        Get.snackbar('Success',
            'Answer submitted successfully' ?? 'Answer submitted successfully');
        Get.toNamed(Routes.home);
        isSuccess = true; // Set flag if success
      },
    );

    return isSuccess; // Finally return the result
  }

  Future<void> submitContest(String contestId) async {
    isSubmittingContest(true);

    final result = await _apiHelper.submitContest(contestId);

    isSubmittingContest(false);

    result.fold(
      (error) {
        Get.snackbar('Error', error.message ?? 'Failed to submit contest');
      },
      (response) {
        Get.snackbar('Success',
            response.body['message'] ?? 'Contest submitted successfully');
        // Optionally: Do further actions like navigating back, refreshing data, etc.
      },
    );
  }

  void startTimer(DateTime startTime, DateTime endTime) {
    _updateRemainingTime(startTime, endTime);

    _timer?.cancel(); // Clear old timer if any
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _updateRemainingTime(startTime, endTime);
    });
  }

  void _updateRemainingTime(DateTime startTime, DateTime endTime) {
    final now = DateTime.now();
    if (now.isBefore(startTime)) {
      remainingTime.value = startTime.difference(now);
    } else if (now.isBefore(endTime)) {
      remainingTime.value = endTime.difference(now);
    } else {
      remainingTime.value = Duration.zero;
      _timer?.cancel();
    }
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }

  String get formattedCountdownTime {
    final minutes =
        remainingTime.value.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds =
        remainingTime.value.inSeconds.remainder(60).toString().padLeft(2, '0');
    return "$minutes:$seconds";
  }
}
