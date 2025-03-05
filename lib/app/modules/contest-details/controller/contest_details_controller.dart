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

  var isLoading = false.obs;
  RxBool isContestRunning = true.obs;
  RxBool isQuestionOpened = true.obs;
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
        isLoading.value = false;
      },
    );
  }
  void selectOption(String questionId, String selectedOptionOrder) {
    selectedAnswers[questionId] = selectedOptionOrder;  // ✅ Track selection per question
  }

  bool isOptionSelected(String questionId, String optionOrder) {
    return selectedAnswers[questionId] == optionOrder;
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

}
