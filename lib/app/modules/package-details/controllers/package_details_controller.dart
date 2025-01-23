import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../APIs/api_helper.dart';
import '../../../common/controller/app_controller.dart';
import '../../../common/utils/prostuti_utils.dart';
import '../../../routes/app_pages.dart';
import '../../../storage/storage_helper.dart';


class PackageDetailsController extends GetxController {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  // final ApiHelper _apiHelper = Get.find<ApiHelper>();
  // // final ApiHelper _apiHelper = Utils.getApiHelperController();
  // final AppController appController = Utils.getAppController();

  var isLoading = false.obs;

}
