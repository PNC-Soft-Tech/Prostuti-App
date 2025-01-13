import 'dart:developer';

import 'package:get/get.dart';
import '../../../APIs/api_helper.dart';
import '../../contests/models/contest_model.dart';

class CustomExamController extends GetxController {
  final ApiHelper _apiHelper = Get.find<ApiHelper>();

  var contests = <Contest>[].obs;
    var contest = Rxn<Contest>();
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
  
  }


}
