import 'package:get/get.dart';

import '../controller/contest_details_controller.dart';


class ContestDetailsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ContestDetailsController());
  }
}
