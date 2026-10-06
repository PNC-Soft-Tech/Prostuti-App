import 'package:get/get.dart';
import '../controller/model_tests_list_controller.dart';

class ModelTestsListBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ModelTestsListController>(
      () => ModelTestsListController(),
    );
  }
}
