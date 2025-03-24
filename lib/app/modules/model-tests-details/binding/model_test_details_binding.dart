import 'package:get/get.dart';

import '../../contest-details/controller/contest_details_controller.dart';
import '../controllers/model_test_details_controller.dart';



class ModelTestDetailsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ModelTestDetailsController());
    Get.lazyPut(() => ContestDetailsController());
  }
}
