import 'package:get/get.dart';
import '../controller/custom_exam_controller.dart';


class CustomExamBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => CustomExamController());
  }
}
