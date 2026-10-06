import 'package:get/get.dart';

import '../controller/email_varification_controller.dart';



class EmailVarificationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => EmailVarificationController());
  }
}
