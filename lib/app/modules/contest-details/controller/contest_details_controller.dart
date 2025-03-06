import 'dart:async';
import 'dart:developer';

import 'package:get/get.dart';
import '../../../APIs/api_helper.dart';
import '../../contests/models/contest_model.dart';
import '../models/contest_details_model.dart';

class ContestDetailsController extends GetxController {
  final ApiHelper _apiHelper = Get.find<ApiHelper>();
  var contestId = ''.obs;
  var contests = <Contest>[].obs;
  var contest = Rxn<Contest>();
  var contestDetails = Rxn<ContestDetailsResponse>();
  final RxMap<String, String> selectedAnswers = <String, String>{}.obs;
  final markedQuestions = <String>[].obs;
  final isSubmittingContest =
      false.obs; // This will track loading state for submitContest

  var isLoading = false.obs;
  final RxMap<String, bool> questionLoadingStatus = <String, bool>{}.obs;
  Rx<Duration> remainingTime = Duration().obs;
  Timer? _timer;

  RxBool isContestRunning = true.obs;
  RxBool isQuestionOpened = false.obs;
  @override
  void onInit() {
    super.onInit();
    final Map<String, dynamic> arguments = Get.arguments;
    contestId.value = arguments["contestId"]; // Retrieve contestId
    fetchContestDetails(contestId.value);
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
        if (data.contest != null) {
          startTimer(data.contest.startContest, data.contest.endContest);
        }
        isLoading.value = false;
      },
    );
  }

  void selectOption(String questionId, String selectedOptionOrder) {
    selectedAnswers[questionId] =
        selectedOptionOrder; // ✅ Track selection per question
  }

  bool isOptionSelected(String questionId, String optionOrder) {
    return selectedAnswers[questionId] == optionOrder;
  }

  void markQuestion(String questionId) {
    markedQuestions.add(questionId);
  }

  void markUnmarkQuestion(String questionId) {
    if (isMarkedQuestion(questionId)) {
      markedQuestions.remove(questionId);
    } else {
      markedQuestions.add(questionId);
    }
  }

  void unMarkQuestion(String questionId) {
    markedQuestions.remove(questionId);
  }

  bool isMarkedQuestion(String questionId) {
    return markedQuestions.contains(questionId);
  }
  // Future<void> fetchContests() async {
  //   isLoading(true);
  //   final result = await _apiHelper.fetchAllContests();
  //   result.fold(
  //     (error) {
  //       Get.snackbar('Error', error.message ?? 'Failed to load contests');
  //     },
  //     (data) {
  //       contests.assignAll(data);
  //       log("data: ${data.first.id}");
  //     },
  //   );
  //   isLoading(false);
  // }

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
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
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
}
