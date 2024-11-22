import 'package:get/get.dart';

import '../../constant/app_config.dart';
import '../api_helper.dart';
import '../api_helper_implementation.dart';

class GlobalBinding extends Bindings {
  @override
  void dependencies() {
    // Ensure only one instance of ApiHelperImpl is created and globally accessible.
    Get.lazyPut<ApiHelper>(() => ApiHelperImpl());

  }
}
