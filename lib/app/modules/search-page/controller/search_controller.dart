import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../APIs/api_helper.dart';

class SearchPageController extends GetxController {
  final ApiHelper _apiHelper = Get.find<ApiHelper>();

  // var questions = <Question>[].obs;
  var isLoading = false.obs;
  TextEditingController searchController = TextEditingController();

  // Future<void> fetchQuestions() async {
  //   isLoading(true);
  //   final result = await _apiHelper.fetchAllQuestions();
  //   result.fold(
  //     (error) {
  //       Get.snackbar('Error', error.message ?? 'Failed to load questions');
  //     },
  //     (data) {
  //       questions.assignAll(data);
  //     },
  //   );
  //   isLoading(false);
  // }
}
