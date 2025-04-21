import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
// import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../APIs/api_helper.dart';
import '../../../routes/app_pages.dart';
import '../../contests/models/contest_model.dart';
import '../../contests/models/contest_status.dart';
import '../../questions/models/question_model.dart';
import '../models/contest_details_model.dart';
import '../../../common/controllers/base_question_controller.dart';

class ContestDetailsController extends GetxController implements BaseQuestionController {
  final ApiHelper _apiHelper = Get.find<ApiHelper>();
  var contestId = ''.obs;
  var contests = <Contest>[].obs;
  var contest = Rxn<Contest>();
  var contestDetails = Rxn<ContestDetailsResponse>();
  final RxMap<String, String> selectedAnswers = <String, String>{}.obs;
  final markedQuestions = <String>[].obs;
  // final markedQuestions = <int>[].obs; // Store **question indexes**
  final currentQuestionIndex = 0.obs; // Track current question
  // late quill.QuillController _controller;

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
  final RxList<String> subjectLists =
      <String>[].obs; // Change this in the controller
  final RxString selectedSubject = 'All'.obs; // "All" is selected by default
  // ✅ Track which questions are currently visible
  RxList<String> visibleQuestions = <String>[].obs;
  @override
  Future<void> onInit() async {
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

  void updateVisibleQuestions(List<String> questionIds) {
    visibleQuestions.value = questionIds;
    debugPrint("Visible Questions: $visibleQuestions"); // ✅ Debugging
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
    return index < visibleQuestions.length - 1
        ? visibleQuestions[index + 1]
        : null;
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
        subjectLists.value = (contestDetails.value?.contest.questions ?? [])
            .map((qs) => qs.topic?.subject?.name) // This returns List<String?>
            .whereType<
                String>() // ✅ Removes null values and casts to List<String>
            .toSet()
            .toList();

        updateContestStatus();
        setUpQuestionKeysAndIndexes(
            contestDetails.value?.contest.questions ?? []);
        startTimer(data.contest.startContest, data.contest.endContest);
        isLoading.value = false;
      },
    );
  }

// Update status check wherever needed
void updateContestStatus() {
  final contest = contestDetails.value?.contest;
  if (contest != null) {
    contestStatus.value = ContestStatus.fromDates(
      contest.startContest.toLocal(),
      contest.endContest.toLocal(),
    );
  }
}

  List<Question> get filteredQuestions {
    final allQuestions = contestDetails.value?.contest.questions ?? [];
    if (selectedSubject.value == 'All') {
      return allQuestions; // Show all questions if "All" is selected
    }
    return allQuestions
        .where((q) => q.topic?.subject?.name == selectedSubject.value)
        .toList(); // Filter based on selected subject
  }

  void selectSubject(String subject) {
    selectedSubject.value = subject; // Update the selected subject
  }

  @override
  void selectOption(String questionId, String selectedOptionOrder) {
    selectedAnswers[questionId] =
        selectedOptionOrder; // ✅ Track selection per question
  }
  @override
void resetSelectOption(String questionId) {
    selectedAnswers[questionId] = ''; // Reset selection for the question
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
    final index = questionIdToIndexMap[questionId];
    if (index == null) return;

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

  @override
  Future<bool> submitAnswer(
      String questionId, String contestId, String selectedAnswer) async {
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
        // Optionally: Do further actions like navigating back, refreshing data, etc.
      },
    );
  }

// In ContestDetailsController
void startTimer(DateTime startTime, DateTime endTime) {
  // Convert to local timezone
  final localStart = startTime.toLocal();
  final localEnd = endTime.toLocal();

  _updateRemainingTime(localStart, localEnd);
  _timer?.cancel();
  _timer = Timer.periodic(const Duration(seconds: 1), (_) {
    _updateRemainingTime(localStart, localEnd);
  });
}

void _updateRemainingTime(DateTime startTime, DateTime endTime) {
  final status = ContestStatus.fromDates(startTime, endTime);
  contestStatus.value = status;

  final now = DateTime.now();
  if (status.isScheduled) {
    remainingTime.value = startTime.difference(now);
  } else if (status.isRunning) {
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
    if (contestStatus.value?.isDone ?? true) {
      return 'Contest Ended';
    }

    final time = remainingTime.value;
    if (time <= Duration.zero) {
      return 'Contest Ended';
    }

    // Extract time components
    final days = time.inDays;
    final hours = time.inHours.remainder(24);
    final minutes = time.inMinutes.remainder(60);
    final seconds = time.inSeconds.remainder(60);

    // Build human-readable parts
    final parts = <String>[];
    if (days > 0) parts.add('$days day${days != 1 ? 's' : ''}');
    if (hours > 0) parts.add('$hours hour${hours != 1 ? 's' : ''}');
    if (minutes > 0) parts.add('$minutes minute${minutes != 1 ? 's' : ''}');
    if (seconds > 0) parts.add('$seconds second${seconds != 1 ? 's' : ''}');

    // Get up to two most significant units
    final displayParts = parts.take(2).toList();
    final timeString = displayParts.join(' and ');

    // Add status context
    return contestStatus.value!.isScheduled 
        ? 'Starts in $timeString'
        : 'Ends in $timeString';
  }

  String? getNextFlaggedQuestion(String currentQuestionId) {
    if (markedQuestionIds.isEmpty) return null;
    
    final sortedFlagged = markedQuestionIds
      .where((id) => questionIdToIndexMap.containsKey(id))
      .toList()
      ..sort((a, b) => questionIdToIndexMap[a]!.compareTo(questionIdToIndexMap[b]!));

    final currentIndex = sortedFlagged.indexWhere((id) => id == currentQuestionId);
    
    if (currentIndex == -1) return sortedFlagged.first;
    if (currentIndex >= sortedFlagged.length - 1) return sortedFlagged.first;
    return sortedFlagged[currentIndex + 1];
  }

  String? getPreviousFlaggedQuestion(String currentQuestionId) {
    if (markedQuestionIds.isEmpty) return null;
    
    final sortedFlagged = markedQuestionIds
      .where((id) => questionIdToIndexMap.containsKey(id))
      .toList()
      ..sort((a, b) => questionIdToIndexMap[a]!.compareTo(questionIdToIndexMap[b]!));

    final currentIndex = sortedFlagged.indexWhere((id) => id == currentQuestionId);
    
    if (currentIndex == -1) return sortedFlagged.last;
    if (currentIndex <= 0) return sortedFlagged.last;
    return sortedFlagged[currentIndex - 1];
  }

  void scrollToQuestion(String? questionId) async {
    if (questionId == null || !questionId.startsWith('ObjectId')) return;

    final controller = Get.find<ContestDetailsController>();
    
    // Force show all questions
    controller.selectedSubject.value = 'All';
    
    // Wait for UI rebuild
    await Future.delayed(const Duration(milliseconds: 50));

    final context = controller.questionKeys[questionId]?.currentContext;
    if (context == null) return;

    Scrollable.ensureVisible(
      context,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
      alignment: 0.1,
    );
  }
}
