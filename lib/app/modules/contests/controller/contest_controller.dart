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
  final registeredContests = <String, bool>{}.obs; // Contest ID => isRegistered

  @override
  void onInit() {
    super.onInit();
    // fetchContests();
    displayRecentContests();
  }

  Future<void> displayRecentContests() async {
    isLoadingUpcomingContest.value = true;
    final result = await _apiHelper.fetchAllContests();

    result.fold(
      (error) {
        isLoadingUpcomingContest.value = false;

        Utils.showSnackbar(
          message: 'Failed to fetch contests: ${error.message}',
          isSuccess: false,
        );      },
      (contests) {
        isLoadingUpcomingContest.value = false;
        // ✅ Filter out completed contests - only show running/upcoming contests
        final now = DateTime.now();
        log('Current time: $now');
        log('Total contests fetched: ${contests.length}');
        
        final activeContests = contests.where((contest) {
          // Convert to local timezone for accurate comparison
          final localEndTime = contest.endContest.toLocal();
          final isActive = localEndTime.isAfter(now);
          log('Contest: ${contest.name}');
          log('  Start: ${contest.startContest}');
          log('  End: ${contest.endContest}');
          log('  End (Local): $localEndTime');
          log('  Is Active: $isActive');
          log('  ---');
          return isActive;
        }).toList();
        
        log('Active contests after filtering: ${activeContests.length}');
        
        upcomingContests.value = activeContests;
        // ✅ Initialize the registration map from filtered data
        for (var contest in activeContests) {
          registeredContests[contest.id] = contest.isRegistered ?? false;
        }

        // Utils.showSnackbar(
        //   message: 'Successfully fetched ${contests.length} contests',
        // );
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
        // ✅ Mark this contest as registered
        registeredContests[contestId] = true;
        // Utils.showSnackbar(
        //     message: "Successfully registered for contest: ${response.body}",
        //     isSuccess: true);
        Utils.showSnackbar(
            message: "Successfully registered for contest", isSuccess: true);
        log('Successfully registered for contest: ${response.body}');
      },
    );
  }

  Future<void> fetchContests() async {
    isLoading(true);
    final result = await _apiHelper.fetchAllContests();
    result.fold(
      (error) {
        Get.snackbar('Error', error.message);
      },
      (data) {
        contests.assignAll(data);
        log("data: ${data.first.id}");
      },
    );
    isLoading(false);
  }
}
