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
}
