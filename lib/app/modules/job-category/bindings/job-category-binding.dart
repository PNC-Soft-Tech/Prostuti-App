import 'package:get/get.dart';

import '../controllers/job-category-controller.dart';


class JobCategoryBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => JobCategoryController());
  }
}
