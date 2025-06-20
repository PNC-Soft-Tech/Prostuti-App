import 'package:get/get.dart';
import '../controller/corner_controller.dart';

class CornerBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CornerController>(() => CornerController());
  }
}
