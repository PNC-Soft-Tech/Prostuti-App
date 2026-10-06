import 'package:get/get.dart';

import '../../common/controller/app_controller.dart';
import '../../common/services/auth_service.dart';
import '../../common/widgets/breathing_animation/global_loading_manager.dart';
import '../api_helper.dart';
import '../api_helper_implementation.dart';

class GlobalBinding extends Bindings {
  @override
  void dependencies() {
    // These services must outlive any single route. Without `permanent: true`
    // (or `fenix: true` on lazyPut), GetX disposes them when the last route
    // using them is removed — which is exactly what `Get.offAllNamed(...)`
    // does on login/logout. Disposing ApiHelper mid-session means the next
    // `Get.find<ApiHelper>()` throws, and every controller that depends on
    // it (HomeController, ContestController, etc.) breaks.
    Get.put<AppController>(AppController(), permanent: true);
    Get.put<ApiHelper>(ApiHelperImpl(), permanent: true);
    Get.put<AuthService>(AuthService(), permanent: true);
    Get.put<GlobalLoadingManager>(
      GlobalLoadingManager.instance,
      permanent: true,
    );
  }
}
