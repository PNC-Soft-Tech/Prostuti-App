import 'package:get/get.dart';
import '../../subjects/controllers/subject_controller.dart';
import '../controller/custom_exam_controller.dart';


class CustomExamBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => CustomExamController());
    Get.lazyPut(() => CategoryController());
  }
}
