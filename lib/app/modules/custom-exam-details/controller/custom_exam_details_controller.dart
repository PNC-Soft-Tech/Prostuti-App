import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../APIs/api_helper.dart';
import '../../../common/controllers/base_question_controller.dart';
import '../../../common/utils/prostuti_utils.dart';
import '../../../routes/app_pages.dart';
import '../../exam-topics/models/exam_topics_model.dart';

import '../../questions/models/question_model.dart';
import '../../subjects/models/subjects_model.dart';
import '../models/custom_exam_response_model.dart';

class CustomExamDetailsController extends GetxController
    implements BaseQuestionController {
  final ApiHelper _apiHelper = Get.find<ApiHelper>();

  // Observable state
  var customExamId = ''.obs;
  var customExamDetails = Rxn<CustomExamDetailsResponse>();
  final RxMap<String, String> selectedAnswers = <String, String>{}.obs;
  final RxList<String> markedQuestionIds = <String>[].obs;
  final currentQuestionIndex = 0.obs;
  final RxBool isReadModeSelected = true.obs;
  final RxBool isExamModeSelected = false.obs;
  final RxString currentSelectedModelTestId = ''.obs;
  final RxString currentSelectedModelTestMode = 'exam'.obs;
  final RxList<String> subjectLists = <String>[].obs;
  final RxString selectedSubject = 'All'.obs;
  RxList<String> visibleQuestions = <String>[].obs;
  @override
  final RxBool isQuestionOpened = true.obs;
  final RxBool isModelTestSubmittedValue = false.obs;

  // Loading states
  var isLoading = false.obs;
  final isSubmittingContest = false.obs;
  final RxMap<String, bool> questionLoadingStatus = <String, bool>{}.obs;

  // Timer state
  Rx<Duration> remainingTime = const Duration().obs;
  RxBool isTimeExpired = false.obs;
  Timer? _timer;

  // Navigation
  final scrollController = ScrollController();
  final questionKeys = <String, GlobalKey>{}.obs;
  final questionIdToIndexMap = <String, int>{}.obs;

  @override
  void onInit() {
    super.onInit();
    final Map<String, dynamic> arguments = Get.arguments;
    customExamId.value = arguments["customExamId"]; // Retrieve customExamId
    fetchCustomExamDetails(customExamId.value); // Fetch exam details
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

  @override
  void scrollToQuestion(String questionId) {
    final originalIndex = customExamDetails.value?.contest.questions
        .indexWhere((q) => q.id == questionId);

    if (originalIndex == null || originalIndex == -1) return;

    // Reset filter if needed
    if (!visibleQuestions.contains(questionId)) {
      selectedSubject.value = 'All';
    }

    // Allow UI to update
    Future.delayed(const Duration(milliseconds: 50), () {
      final context = questionKeys[questionId]?.currentContext;
      if (context != null) {
        Scrollable.ensureVisible(
          context,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
          alignment: 0.1,
        );
      } else {
        // Fallback to estimated position
        scrollController.animateTo(
          originalIndex * 300.h,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  void updateVisibleQuestions(List<String> questionIds) {
    visibleQuestions.value = questionIds;
    debugPrint("Visible Questions: $visibleQuestions");
  }

  bool isQuestionVisible(String questionId) {
    return visibleQuestions.contains(questionId);
  }

  @override
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

  @override
  String? getNextVisibleQuestion(String currentQuestionId) {
    final index = visibleQuestions.indexOf(currentQuestionId);
    debugPrint(
        "Next Visible Question: ${index < visibleQuestions.length - 1 ? visibleQuestions[index + 1] : 'None'}");
    return index < visibleQuestions.length - 1
        ? visibleQuestions[index + 1]
        : null;
  }

  void fetchCustomExamDetails(String customExamId) async {
    isLoading.value = true;

    final result = await _apiHelper.fetchSingleCustomExam(customExamId);

    result.fold(
      (error) {
        isLoading.value = false;
        log('Error fetching custom exam details: ${error.message}');
        Get.snackbar('Error', 'Failed to load customexam: ${error.message}');
      },
      (data) {
        customExamDetails.value = data;
        subjectLists.value = (customExamDetails.value?.contest.questions ?? [])
            .map((qs) => qs.topic?.subject?.name)
            .whereType<String>()
            .toSet()
            .toList();

        // Set up navigation
        setUpQuestionKeysAndIndexes(
            customExamDetails.value?.contest.questions ?? []);

        // Set visible questions (all at first)
        updateVisibleQuestions(
            (customExamDetails.value?.contest.questions ?? [])
                .map((q) => q.id)
                .toList());

        // Start timer
        startTimer(data.contest.startContest, data.contest.endContest);

        isLoading.value = false;
      },
    );
  }

  List<Question> get filteredQuestions {
    final allQuestions = customExamDetails.value?.contest.questions ?? [];
    if (selectedSubject.value == 'All') {
      return allQuestions;
    }
    return allQuestions
        .where((q) => q.topic?.subject?.name == selectedSubject.value)
        .toList();
  }

  void selectSubject(String subject) {
    selectedSubject.value = subject;

    // Update visible questions based on filter
    final visibleIds = filteredQuestions.map((q) => q.id).toList();
    updateVisibleQuestions(visibleIds);
  }

  @override
  void selectOption(String questionId, String selectedOptionOrder) {
    selectedAnswers[questionId] = selectedOptionOrder;
  }

  @override
  void resetSelectOption(String questionId) {
    selectedAnswers[questionId] = ''; // Reset selection for the question
  }

  @override
  bool isCorrectAnswered(String questionId, String selectedAnswer) {
    // Check if the selected answer is correct
    final question = questionAtIndex(questionIdToIndexMap[questionId] ?? -1);
    if (question == null) return false;
    return question.rightAnswer == selectedAnswer;
  }

  @override
  bool isOptionSelected(String questionId, String optionOrder) {
    return selectedAnswers[questionId] == optionOrder;
  }

  @override
  bool isAnswered(String questionId, List<String> optionOrderList) {
    bool isOptionAnswered = false;
    for (var optionOrder in optionOrderList) {
      if (selectedAnswers[questionId] == optionOrder) {
        isOptionAnswered = true; // Answer is selected
        break;
      }
    }
    return isOptionAnswered;
  }

  @override
  void markUnmarkQuestion(String questionId) {
    if (markedQuestionIds.contains(questionId)) {
      markedQuestionIds.remove(questionId);
    } else {
      markedQuestionIds.add(questionId);
    }
  }

  @override
  bool isMarkedQuestion(String questionId) {
    return markedQuestionIds.contains(questionId);
  }

  Question? questionAtIndex(int index) {
    final questions = customExamDetails.value?.contest.questions ?? [];
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

  @override
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

  @override
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
      },      (response) {
        Get.snackbar('Success',
            response.body['message'] ?? 'Contest submitted successfully');
        Get.toNamed(Routes.ranking, arguments: contestId);
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
      isTimeExpired.value = true;
      _timer?.cancel();
      
      // Auto-submit and navigate home after a short delay
      if (!isModelTestSubmittedValue.value) {
        isModelTestSubmittedValue.value = true; // Prevent multiple submissions
        
        Get.snackbar(
          'Time\'s Up!',
          'Your exam time has ended. Your answers have been submitted.',
          duration: const Duration(seconds: 3),
          backgroundColor: Colors.red.withOpacity(0.8),
          colorText: Colors.white,
        );
        
        // Submit exam answers
        Future.delayed(const Duration(seconds: 1), () {
          submitContest(customExamId.value).then((_) {
            // Navigate to home after submission
            Future.delayed(const Duration(seconds: 2), () {
              Get.offAllNamed('/home');
            });
          });
        });
      }
    }
  }

  @override
  void onClose() {
    _timer?.cancel();
    scrollController.dispose();
    super.onClose();
  }

  String get formattedCountdownTime {
    if (remainingTime.value.inHours > 0) {
      final hours = remainingTime.value.inHours;
      final minutes = remainingTime.value.inMinutes.remainder(60).toString().padLeft(2, '0');
      final seconds = remainingTime.value.inSeconds.remainder(60).toString().padLeft(2, '0');
      return "$hours:$minutes:$seconds";
    } else {
      final minutes = remainingTime.value.inMinutes.remainder(60).toString().padLeft(2, '0');
      final seconds = remainingTime.value.inSeconds.remainder(60).toString().padLeft(2, '0');
      return "$minutes:$seconds";
    }
  }

  @override
  RxBool get isModelTestSubmitted => isModelTestSubmittedValue;

  @override
  RxString get selectedTestMode => currentSelectedModelTestMode;

  // Add method to check if exam can be completed
  bool canCompleteExam() {
    return !isTimeExpired.value;
  }
}
