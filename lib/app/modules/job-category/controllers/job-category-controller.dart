import 'dart:developer';

import 'package:get/get.dart';

import '../../../APIs/api_helper.dart';
import '../../../APIs/api_helper_implementation.dart';
import '../../../models/job-category-model.dart';


class JobCategoryController extends GetxController {
  final ApiHelper _apiHelper = Get.find<ApiHelper>();

  var jobCategories = <JobCategory>[].obs;
  var isLoading = true.obs;

  @override
  void onInit() {
    fetchJobCategories();
    super.onInit();
  }

  void fetchJobCategories() async {
     log('Fetching job categories...');
    isLoading.value = true;
    final response = await _apiHelper.getJobCategories();
    log("res: ${response.toString()}");
    response.fold(
      (error) {
        isLoading.value = false;
        Get.snackbar("Error", error.message);
      },
      (categories) {
        jobCategories.value = categories;
        isLoading.value = false;
      },
    );
  }
}
