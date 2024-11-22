import 'dart:developer';

import 'package:get/get.dart';
import '../../../APIs/api_helper.dart';
import '../models/single_contest_model.dart';



class SingleContestController extends GetxController {
  final ApiHelper _apiHelper = Get.find<ApiHelper>();

  var isLoading = false.obs;
  var contest = Rxn<SingleContest>();
  @override
  void onInit() {
    super.onInit();
    // Retrieve contest ID from route parameters
   final contestId = Get.parameters['id']!;
    fetchContest(contestId);
  }
  Future<void> fetchContest(String contestId) async {
    isLoading(true);
    final result = await _apiHelper.fetchSingleContest(contestId);
    result.fold(
      (error) {
        Get.snackbar('Error', error.message ?? 'Failed to fetch contest');
      },
      (data) {
        log("single contest data : ${data}");
        contest.value = data;
      },
    );
    isLoading(false);
  }
}
