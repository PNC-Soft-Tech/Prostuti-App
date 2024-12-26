import 'dart:developer';

import 'package:get/get.dart';
import '../../../APIs/api_helper.dart';
import '../../../common/models/contest_model.dart';


class ContestController extends GetxController {
  final ApiHelper _apiHelper = Get.find<ApiHelper>();

  var contests = <Contest>[].obs;
    var contest = Rxn<Contest>();
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchContests();
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
