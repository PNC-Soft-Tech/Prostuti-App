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

  RxBool isQuestionOpened = true.obs; // Always keep questions open by default
  final scrollController = ScrollController();
  final questionKeys = <String, GlobalKey>{}.obs;
  final questionIdToIndexMap = <String, int>{}.obs;
  final markedQuestionIndexes = <int>[].obs; // For UI scroll
  final markedQuestionIds = <String>[].obs; // For API call if needed
  final RxList<String> subjectLists =
      <String>[].obs; // Change this in the controller
  final RxString selectedSubject = 'All'.obs; // "All" is selected by default
  RxList<String> visibleQuestions = <String>[].obs;
  RxBool isModelTestSubmittedLocal = false.obs;

  @override
  void onInit() {
    super.onInit();
    final Map<String, dynamic> arguments = Get.arguments;
    modelTestId.value = arguments["modelTestId"]; // Retrieve model test ID
    
    // Always set exam mode from arguments if provided
    if (arguments.containsKey("mode")) {
      currentSelectedModelTestMode.value = arguments["mode"];
      
      // Update mode selection state
      isReadModeSelected.value = currentSelectedModelTestMode.value == 'read';
      isExamModeSelected.value = currentSelectedModelTestMode.value == 'exam';
      
      // Always ensure questions are shown
      isQuestionOpened.value = true;
    }
    
    fetchModelTestDetails(modelTestId.value);
    
    // Set up visibleQuestions listener to ensure it's never empty
    ever(visibleQuestions, (_) {
      if (visibleQuestions.isEmpty && filteredQuestions.isNotEmpty) {
        // If we have questions but none are marked as visible, update the visible list
        updateVisibleQuestions(filteredQuestions.map((q) => q.id).toList());
      }
    });
    
    // Listen for question index changes
    ever<int>(currentQuestionIndex, (index) {
      // Don't scroll if no controller or current index invalid
      if (!scrollController.hasClients || index < 0) return;
      
      scrollController.animateTo(
        index * 300.h, // Approx height per question, tune if needed
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    });
  }

  void toggleMode(bool isReadMode) {
    currentSelectedModelTestMode.value = isReadMode ? 'read' : 'exam';
    isReadModeSelected.value = isReadMode;
    isExamModeSelected.value = !isReadMode;
    
    // Always ensure questions are visible
    isQuestionOpened.value = true;

    // When entering exam mode, reset all selected answers and marks
    if (!isReadMode) {
      // Clear selected answers
      selectedAnswers.clear();
      
      // Clear marked questions (optional, based on your requirements)
      markedQuestionIds.clear();
      markedQuestionIndexes.clear();
      
      // Reset submission state
      isModelTestSubmittedLocal.value = false;
    }
  }

  void setUpQuestionKeysAndIndexes(List<Question> questions) {
    questionKeys.clear();
    questionIdToIndexMap.clear();

    for (int i = 0; i < questions.length; i++) {
      final question = questions[i];
      questionKeys[question.id] = GlobalKey();
      questionIdToIndexMap[question.id] = i;
    }
    
    // Initialize visibleQuestions with all question IDs
    updateVisibleQuestions(questions.map((q) => q.id).toList());
  }

  void scrollToQuestion(String questionId) {
    final originalIndex =
        modelDetails.value?.contest.questions.indexWhere((q) => q.id == questionId);

    if (originalIndex == null || originalIndex == -1) return;

    if (!visibleQuestions.contains(questionId)) {
      selectedSubject.value = 'All';
    }

    // Update current question index
    final previousIndex = currentQuestionIndex.value;
    currentQuestionIndex.value = originalIndex;

    // No need to restart timer since we're using total time counting
    if (previousIndex != originalIndex) {
      onQuestionChanged(originalIndex);
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
        
        // For model tests, start timer based on current time + test duration
        startModelTestTimer(data.contest.totalTime ?? 0);
        
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

  @override
  void selectOption(String questionId, String selectedOptionOrder) {
    selectedAnswers[questionId] = selectedOptionOrder;
  }
  @override
  void resetSelectOption(String questionId) {
    selectedAnswers[questionId] = '';
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
        isOptionAnswered= true; // Answer is selected
        break;
      }
    }
    return isOptionAnswered;
  }
@override 
bool isCorrectAnswered(String questionId, String selectedAnswer) {
    // Check if the selected answer is correct
    final question = questionAtIndex(questionIdToIndexMap[questionId] ?? -1);
    if (question == null) return false;
    return question.rightAnswer == selectedAnswer;
   
  }
  @override
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

  @override
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
    // In read mode, don't make API calls - just return success
    if (currentSelectedModelTestMode.value == 'read') {
      // Simulate a brief loading state for UI consistency
      questionLoadingStatus[questionId] = true;
      await Future.delayed(const Duration(milliseconds: 100));
      questionLoadingStatus[questionId] = false;
      return true; // Always return success in read mode
    }

    // In exam mode, proceed with API call
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

  void startModelTestTimer(int totalTimeInMinutes) {
    // Only start timer in exam mode, not in read mode
    if (currentSelectedModelTestMode.value == 'read') {
      // In read mode, show a long duration to avoid showing "Time Up"
      remainingTime.value = const Duration(hours: 24);
      return;
    }
    
    // Calculate total time based on number of questions × 30 seconds each
    const int secondsPerQuestion = 30;
    final totalQuestions = filteredQuestions.length;
    final totalSeconds = totalQuestions * secondsPerQuestion;
    
    print('🕐 Starting model test timer: $totalQuestions questions × $secondsPerQuestion seconds = ${totalSeconds}s total');
    
    // Start the total timer countdown
    _startTotalTimer(totalSeconds);
  }

  void _startTotalTimer(int totalSeconds) {
    // Set initial remaining time for all questions combined
    remainingTime.value = Duration(seconds: totalSeconds);
    
    print('⏱️ Starting total timer: ${totalSeconds}s for entire test');
    
    // Cancel any existing timer
    _timer?.cancel();
    
    // Start countdown timer for entire test
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (remainingTime.value.inSeconds > 0) {
        remainingTime.value = Duration(seconds: remainingTime.value.inSeconds - 1);
      } else {
        // Time up for entire test
        timer.cancel();
        print('⏰ Total test time is up!');
        
        // Auto-submit the test when time is up
        _autoSubmitTest();
      }
    });
  }

  void _autoSubmitTest() {
    print('🏁 Auto-submitting test due to time limit');
    
    // Set the same flag that manual submit sets to show results
    isModelTestSubmittedLocal.value = true;
    
    // Stop the timer
    _timer?.cancel();
    
    // Show completion message
    Get.snackbar(
      'Time Up!', 
      'Test completed automatically. Check your results below.',
      duration: Duration(seconds: 3),
      backgroundColor: Colors.orange.withOpacity(0.1),
      colorText: Colors.orange.shade700,
      icon: Icon(Icons.timer_off, color: Colors.orange),
    );
    
    // Optional: Also call the API submit if needed
    // final contestId = modelDetails.value?.contest.id;
    // if (contestId != null) {
    //   submitContest(contestId);
    // }
  }

  // Remove the per-question navigation methods since we're using total time
  // No longer need per-question timer reset since we're using total time
  void onQuestionChanged(int newQuestionIndex) {
    // Timer continues running for total time, no reset needed
    print('📋 Question changed to ${newQuestionIndex + 1}, timer continues counting total time');
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
    if (remainingTime.value <= Duration.zero) {
      return 'Time Up';
    }

    // Extract time components
    final days = remainingTime.value.inDays;
    final hours = remainingTime.value.inHours.remainder(24);
    final minutes = remainingTime.value.inMinutes.remainder(60);
    final seconds = remainingTime.value.inSeconds.remainder(60);

    // For short time periods (less than 10 minutes), show MM:SS format for better precision
    if (days == 0 && hours == 0 && minutes < 10) {
      return "${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}";
    }

    // For longer periods, use human-readable format
    final parts = <String>[];
    if (days > 0) parts.add('$days day${days != 1 ? 's' : ''}');
    if (hours > 0) parts.add('$hours hour${hours != 1 ? 's' : ''}');
    if (minutes > 0 && parts.length < 2) parts.add('$minutes minute${minutes != 1 ? 's' : ''}');
    if (seconds > 0 && parts.isEmpty) parts.add('$seconds second${seconds != 1 ? 's' : ''}');

    // Take up to two most significant units
    final displayParts = parts.take(2).toList();
    return displayParts.join(' and ');
  }

  @override
  RxString get selectedTestMode => currentSelectedModelTestMode;
  @override
  RxBool get isModelTestSubmitted => isModelTestSubmittedLocal;
  
}
