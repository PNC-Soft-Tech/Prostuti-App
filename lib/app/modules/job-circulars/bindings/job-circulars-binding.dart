import 'package:get/get.dart';
import '../controllers/job-circulars-controller.dart';


class JobCircularBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<JobCircularController>(() => JobCircularController());
  }
}
