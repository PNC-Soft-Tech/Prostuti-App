import 'package:get/get.dart';
import '../../common/controller/app_controller.dart';
import '../../storage/storage_helper.dart';

class Utils {
  static Future<void> logoutUser() async {
    try {
      // Get AppController instance
      final AppController appController = getAppController();

      // Clear reactive variables in AppController
      appController.userId.value = '';
      appController.username.value = '';
      appController.userRole.value = '';
      appController.isLoggedIn.value = false;
      appController.userData.value = {};
      appController.decodedToken.value = {};

      // Clear SharedPreferences
      await StorageHelper.removeToken();
      await StorageHelper.removeUserData();
      await StorageHelper.removeUserId();

      // Navigate to login or splash screen
      Get.offAllNamed('/login'); // Replace '/login' with your actual login route
    } catch (e) {
      print("Error during logout: $e");
    }
  }


    static AppController getAppController() {
    return Get.isRegistered<AppController>()
        ? Get.find<AppController>()
        : Get.put(AppController());
  }
}
