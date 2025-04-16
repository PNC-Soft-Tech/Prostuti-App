import 'dart:developer';

import 'package:get/get.dart';
import '../../../APIs/api_helper.dart';
import '../../../common/utils/prostuti_utils.dart';

import '../models/model_test_model.dart';

class ModelTestController extends GetxController {
  final ApiHelper _apiHelper = Get.find<ApiHelper>();

  var model_tests = <ModelTest>[].obs;
  var model_test = Rxn<ModelTest>();
  var isLoading = false.obs;
  var isLoadingModelTests = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchAllModelTests();
  }



  Future<void> fetchAllModelTests() async {
    isLoadingModelTests.value = true;
    final result = await _apiHelper.fetchAllModelTests();

    result.fold(
      (error) {
        isLoadingModelTests.value = false;

        Utils.showSnackbar(
          message: 'Failed to fetch model test: ${error.message}',
          isSuccess: false,
        );
      },
      (modelTests) {
        isLoadingModelTests.value = false;
  // ✅ Initialize the registration map from API data
        model_tests.value = modelTests;
        // for (var model in modelTests) {
        //    registeredContests[contest.id] = contest.isRegistered ?? false;
        //   log('Contest: ${contest.name}, Total Marks: ${contest.totalMarks}');
        // }

        // Utils.showSnackbar(
        //   message: 'Successfully fetched ${contests.length} contests',
        // );
      },
    );
  }


}
