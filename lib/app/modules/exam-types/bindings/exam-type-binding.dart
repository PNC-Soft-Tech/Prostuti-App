import 'package:get/get.dart';
import '../controllers/exam-type-controller.dart';

class ExamTypeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ExamTypeController());
  }
}
