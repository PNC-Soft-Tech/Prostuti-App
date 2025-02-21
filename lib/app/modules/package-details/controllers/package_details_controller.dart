import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PackageDetailsController extends GetxController {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  // final ApiHelper _apiHelper = Get.find<ApiHelper>();
  // // final ApiHelper _apiHelper = Utils.getApiHelperController();
  // final AppController appController = Utils.getAppController();

  var isLoading = false.obs;
}
