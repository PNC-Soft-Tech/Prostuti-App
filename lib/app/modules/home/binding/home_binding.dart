import 'package:get/get.dart';
import '../../contests/controller/contest_controller.dart';
import '../../job-circulars/controllers/job-circulars-controller.dart';
import '../controller/home_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ContestController>(() => ContestController());
    Get.lazyPut<HomeController>(() => HomeController());
    Get.lazyPut<JobCircularController>(() => JobCircularController());
  }
}
