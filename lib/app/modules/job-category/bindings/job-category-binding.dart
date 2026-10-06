import 'package:get/get.dart';

import '../../../APIs/api_helper.dart';
import '../../../APIs/api_helper_implementation.dart';
import '../controllers/job-category-controller.dart';


class JobCategoryBinding extends Bindings {
  @override
  void dependencies() {
        Get.put<ApiHelper>(ApiHelperImpl()); // Ensure ApiHelperImpl is ready

    Get.lazyPut(() => JobCategoryController());
  }
}
