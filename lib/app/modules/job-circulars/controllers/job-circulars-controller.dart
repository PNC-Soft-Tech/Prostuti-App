import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../APIs/api_helper_implementation.dart';
import '../models/job-circulars-model.dart';


class JobCircularController extends GetxController {
  final ApiHelperImpl apiHelper = ApiHelperImpl();
  var isLoading = false.obs;
  var jobCirculars = <JobCircular>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchJobCirculars();
  }

  Future<void> fetchJobCirculars() async {
    isLoading(true);
    final result = await apiHelper.fetchJobCirculars();
    result.fold(
      (error) {
        Get.snackbar("Error", error.message ?? "Unknown error occurred",
            backgroundColor: Colors.redAccent, colorText: Colors.white);
      },
      (data) {
        jobCirculars.assignAll(data);
      },
    );
    isLoading(false);
  }
}
