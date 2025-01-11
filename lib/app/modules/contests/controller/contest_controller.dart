import 'dart:developer';

import 'package:get/get.dart';
import '../../../APIs/api_helper.dart';
import '../../../common/utils/prostuti_utils.dart';
import '../models/contest_model.dart';

class ContestController extends GetxController {
  final ApiHelper _apiHelper = Get.find<ApiHelper>();

  var contests = <Contest>[].obs;
  var contest = Rxn<Contest>();
  var upcomingContests = <Contest>[].obs;
  var isLoading = false.obs;
  var isLoadingUpcomingContest = false.obs;

  @override
  void onInit() {
    super.onInit();
    // fetchContests();
    displayRecentContests();
  }



  Future<void> displayRecentContests() async {
    isLoadingUpcomingContest.value = true;
    final result = await _apiHelper.fetchRecentContests();

    result.fold(
      (error) {
        isLoadingUpcomingContest.value = false;

        Utils.showSnackbar(
          message: 'Failed to fetch contests: ${error.message}',
          isSuccess: false,
        );
      },
      (contests) {
        isLoadingUpcomingContest.value = false;

        upcomingContests.value = contests;
        for (var contest in contests) {
          log('Contest: ${contest.name}, Total Marks: ${contest.totalMarks}');
        }

        Utils.showSnackbar(
          message: 'Successfully fetched ${contests.length} contests',
        );
      },
    );
  }

  Future<void> registerForContest(String contestId) async {
    final result = await _apiHelper.registerContest(contestId);

    result.fold(
      (error) {
        log('Failed to register contest: ${error.message}');
        Utils.showSnackbar(
            message: "Failed to register contest", isSuccess: false);
      },
      (response) {
        Utils.showSnackbar(
            message: "Successfully registered for contest: ${response.body}",
            isSuccess: true);
        log('Successfully registered for contest: ${response.body}');
      },
    );
  }

  Future<void> fetchContests() async {
    isLoading(true);
    final result = await _apiHelper.fetchAllContests();
    result.fold(
      (error) {
        Get.snackbar('Error', error.message ?? 'Failed to load contests');
      },
      (data) {
        contests.assignAll(data);
        log("data: ${data.first.id}");
      },
    );
    isLoading(false);
  }
}
