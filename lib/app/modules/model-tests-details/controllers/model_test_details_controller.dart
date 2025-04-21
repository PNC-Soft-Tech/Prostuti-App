import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../APIs/api_helper.dart';
import '../../../routes/app_pages.dart';
import '../../contests/models/contest_model.dart';
import '../../contests/models/contest_status.dart';
import '../../questions/models/question_model.dart';
import '../models/model_test_response_model.dart';
import '../../../common/controllers/base_question_controller.dart';

class ModelTestDetailsController extends GetxController implements BaseQuestionController {
  final ApiHelper _apiHelper = Get.find<ApiHelper>();
  var contestId = ''.obs;
  var modelTestId = ''.obs;
  var contests = <Contest>[].obs;
  var contest = Rxn<Contest>();
  var modelDetails = Rxn<ModelTestDetailsResponse>();
  final RxMap<String, String> selectedAnswers = <String, String>{}.obs;
  final markedQuestions = <String>[].obs;
  final currentQuestionIndex = 0.obs; // Track current question
  final RxBool isReadModeSelected = true.obs;
  final RxBool isExamModeSelected = false.obs;
  final RxString currentSelectedModelTestId = ''.obs;
  final RxString currentSelectedModelTestMode = 'read'.obs;

  final isSubmittingContest =
      false.obs; // This will track loading state for submitContest

  var isLoading = false.obs;
  final RxMap<String, bool> questionLoadingStatus = <String, bool>{}.obs;
  Rx<Duration> remainingTime = const Duration().obs;
  Timer? _timer;
  Rx<ContestStatus?> contestStatus = Rx<ContestStatus?>(null);

  RxBool isQuestionOpened = false.obs;
  final scrollController = ScrollController();
  final questionKeys = <String, GlobalKey>{}.obs;
  final questionIdToIndexMap = <String, int>{}.obs;
  final markedQuestionIndexes = <int>[].obs; // For UI scroll
  final markedQuestionIds = <String>[].obs; // For API call if needed
  final RxList<String> subjectLists =
      <String>[].obs; // Change this in the controller
  final RxString selectedSubject = 'All'.obs; // "All" is selected by default
  RxList<String> visibleQuestions = <String>[].obs;

  @override
  void onInit() {
    super.onInit();
    final Map<String, dynamic> arguments = Get.arguments;
    modelTestId.value = arguments["modelTestId"]; // Retrieve contestId
    currentSelectedModelTestMode.value = arguments["mode"]; // Retrieve contestId
    fetchModelTestDetails(modelTestId.value);
    ever<int>(currentQuestionIndex, (index) {
      scrollController.animateTo(
        index * 300.h, // Approx height per question, tune if needed
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    });
    // Ensure questions are opened in exam mode
    ever(currentSelectedModelTestMode, (mode) {
      if (mode == 'exam' && !isQuestionOpened.value) {
        isQuestionOpened.value = true;
      }
    });
  }

  void toggleMode(bool isReadMode) {
    currentSelectedModelTestMode.value = isReadMode ? 'read' : 'exam';
    isReadModeSelected.value = isReadMode;
    isExamModeSelected.value = !isReadMode;
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
    final originalIndex =
        modelDetails.value?.contest.questions.indexWhere((q) => q.id == questionId);

    if (originalIndex == null || originalIndex == -1) return;

    if (!visibleQuestions.contains(questionId)) {
      selectedSubject.value = 'All';
    }

    scrollController.animateTo(
      originalIndex * 300.h,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  void updateVisibleQuestions(List<String> questionIds) {
    visibleQuestions.value = questionIds;
    debugPrint("Visible Questions: $visibleQuestions");
  }

  bool isQuestionVisible(String questionId) {
    return visibleQuestions.contains(questionId);
  }

  String? getPreviousVisibleQuestion(String currentQuestionId) {
    final index = visibleQuestions.indexOf(currentQuestionId);
    debugPrint(
        "Prev Check - Current: $currentQuestionId, Index: $index, Visible List: $visibleQuestions");

    if (index > 0) {
      debugPrint("✅ Previous Question Found: ${visibleQuestions[index - 1]}");
      return visibleQuestions[index - 1];
    }

    debugPrint("❌ No Previous Question Found");
    return null;
  }

  String? getNextVisibleQuestion(String currentQuestionId) {
    final index = visibleQuestions.indexOf(currentQuestionId);
    debugPrint(
        "Next Visible Question: ${index < visibleQuestions.length - 1 ? visibleQuestions[index + 1] : 'None'}");
    return index < visibleQuestions.length - 1 ? visibleQuestions[index + 1] : null;
  }

  void fetchModelTestDetails(String modelTestId) async {
    isLoading.value = true;

    final result = await _apiHelper.fetchSingleModelTest(modelTestId);

    result.fold(
      (error) {
        isLoading.value = false;
        log('Error fetching model test details: ${error.message}');
      },
      (data) {
        modelDetails.value = data;
        log("model test data: ${modelDetails.value}");
        subjectLists.value = (modelDetails.value?.contest.questions ?? [])
            .map((qs) => qs.topic?.subject?.name)
            .whereType<String>()
            .toSet()
            .toList();

        setUpQuestionKeysAndIndexes(
            modelDetails.value?.contest.questions ?? []);
        startTimer(data.contest.startContest, data.contest.endContest);
        isLoading.value = false;
      },
    );
  }

  List<Question> get filteredQuestions {
    final allQuestions = modelDetails.value?.contest.questions ?? [];
    if (selectedSubject.value == 'All') {
      return allQuestions;
    }
    return allQuestions
        .where((q) => q.topic?.subject?.name == selectedSubject.value)
        .toList();
  }

  void selectSubject(String subject) {
    selectedSubject.value = subject;
  }

  void selectOption(String questionId, String selectedOptionOrder) {
    selectedAnswers[questionId] = selectedOptionOrder;
  }

  bool isOptionSelected(String questionId, String optionOrder) {
    return selectedAnswers[questionId] == optionOrder;
  }

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

  bool isMarkedQuestion(String questionId) {
    return markedQuestionIds.contains(questionId);
  }

  Question? questionAtIndex(int index) {
    final questions = modelDetails.value?.contest.questions ?? [];
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
    String questionId,
    String contestId,
    String selectedAnswer,
  ) async {
    questionLoadingStatus[questionId] = true;

    try {
      final result = await _apiHelper.submitContestAnswer(
        questionId: questionId,
        contestId: contestId,
        selectedAnswer: selectedAnswer,
      );

      bool isSuccess = false;
      result.fold(
        (error) {
          Get.snackbar('Error', error.message ?? 'Something went wrong');
          isSuccess = false;
        },
        (response) {
          Get.snackbar('Success', 'Answer submitted successfully');
          isSuccess = true;
        },
      );

      return isSuccess;
    } catch (e) {
      debugPrint('Error submitting answer: $e');
      return false;
    } finally {
      questionLoadingStatus[questionId] = false;
    }
  }

  String getOptionAns(int index) {
    switch (index) {
      case 1:
        return 'a';
      case 2:
        return 'b';
      case 3:
        return 'c';
      case 4:
        return 'd';
      case 5:
        return 'e';
      case 6:
        return 'f';
      case 7:
        return 'g';
      case 8:
        return 'h';
      case 9:
        return 'i';
      case 10:
        return 'j';
      default:
        return '';
    }
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
        Get.toNamed(Routes.ranking);
      },
    );
  }

  void startTimer(DateTime startTime, DateTime endTime) {
    _updateRemainingTime(startTime, endTime);

    _timer?.cancel();
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
