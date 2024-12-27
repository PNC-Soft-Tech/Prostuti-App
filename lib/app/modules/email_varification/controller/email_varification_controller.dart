import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../APIs/api_helper.dart';
import '../../../common/models/contest_model.dart';


class EmailVarificationController extends GetxController {
  final ApiHelper _apiHelper = Get.find<ApiHelper>();
  final code1 = TextEditingController();
  final code2 = TextEditingController();
  final code3 = TextEditingController();
  final code4 = TextEditingController();
  var contests = <Contest>[].obs;
    var contest = Rxn<Contest>();
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();

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
