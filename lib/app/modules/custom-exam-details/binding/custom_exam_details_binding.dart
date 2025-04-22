import 'package:get/get.dart';
import '../../custom-exam/controller/custom_exam_controller.dart';
import '../../subjects/controllers/subject_controller.dart';
import '../controller/custom_exam_details_controller.dart';


class CustomExamDetailsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => CustomExamController());
    Get.lazyPut(() => CustomExamDetailsController());
  }
}
