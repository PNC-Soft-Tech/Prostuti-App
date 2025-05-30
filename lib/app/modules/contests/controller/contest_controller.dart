import 'dart:developer';

import 'package:get/get.dart';
import '../../../APIs/api_helper.dart';
import '../../../common/services/auth_service.dart';
import '../../../common/utils/prostuti_utils.dart';
import '../models/contest_model.dart';

class ContestController extends GetxController {
  final ApiHelper _apiHelper = Get.find<ApiHelper>();
  final AuthService _authService = Get.find<AuthService>();

  var contests = <Contest>[].obs;
  var contest = Rxn<Contest>();
  var upcomingContests = <Contest>[].obs;
  var isLoading = false.obs;
  var isLoadingUpcomingContest = false.obs;
  final registeredContests = <String, bool>{}.obs; // Contest ID => isRegistered
  @override
  void onInit() {
    super.onInit();
    // Only fetch contests if user is authenticated
    _checkAuthAndLoadContests();
  }

  /// Check authentication and load contests if authenticated
  void _checkAuthAndLoadContests() async {
    final hasAccess = await _authService.checkFeatureAccess(
      featureName: 'contests',
      customMessage: 'Please login to view contests and participate in competitions.',
    );
    
    if (hasAccess) {
      displayRecentContests();
    }
  }
  /// Fetches recent contests from the server
  /// FIXED: Changed from fetchAllContests() to fetchRecentContests() 
  /// to use server-side filtering instead of client-side filtering.
  /// This ensures only active contests are returned from the API.
  Future<void> displayRecentContests() async {
    isLoadingUpcomingContest.value = true;
    final result = await _apiHelper.fetchRecentContests();

    result.fold(
      (error) {
        isLoadingUpcomingContest.value = false;

        Utils.showSnackbar(
          message: 'Failed to fetch contests: ${error.message}',
          isSuccess: false,
        );      },      (contests) {
        isLoadingUpcomingContest.value = false;
        
        log('=== RECENT CONTESTS API RESPONSE ===');
        log('Total recent contests fetched: ${contests.length}');
        
        // Filter out any completed contests that might have been returned
        // Only keep contests that are running or scheduled (upcoming)
        final filteredContests = contests.where((contest) {
          final contestStatus = Utils.getContestStatus(contest.startContest, contest.endContest);
          return contestStatus.isRunning || contestStatus.isScheduled;
        }).toList();
        
        log('Contests after filtering: ${filteredContests.length}');
        for (var contest in filteredContests) {
          final localEndTime = contest.endContest.toLocal();
          final isActive = localEndTime.isAfter(DateTime.now());
          final status = Utils.getContestStatus(contest.startContest, contest.endContest);
          log('Contest: ${contest.name}');
          log('  End: ${contest.endContest}');
          log('  End (Local): $localEndTime');
          log('  Is Active: $isActive');
          log('  isRunning: ${status.isRunning}');
          log('  isScheduled: ${status.isScheduled}');
          log('  isDone: ${status.isDone}');
          log('  ---');
        }
        log('=== END DEBUG ===');
        
        upcomingContests.value = filteredContests;
        
        // ✅ Initialize the registration map from contests data
        for (var contest in contests) {
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
