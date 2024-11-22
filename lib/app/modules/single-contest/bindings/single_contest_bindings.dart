import 'package:get/get.dart';

import '../controller/single_contest_controller.dart';



class SingleContestBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SingleContestController());
  }
}
