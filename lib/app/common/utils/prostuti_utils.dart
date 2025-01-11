import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../common/controller/app_controller.dart';
import '../../constant/app_color.dart';
import '../../modules/contests/models/contest_status.dart';
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

  static void showSnackbar({
    required String message,
    String title = 'Notice',
    Color backgroundColor = AppColors.primary, // Default color
    Color textColor = Colors.white, // Default color
    SnackPosition position = SnackPosition.TOP, // Default position
    bool isSuccess = true, // Default icon state
    Duration duration = const Duration(seconds: 3), // Default duration
    IconData? icon, // Optional custom icon
  }) {
    Get.snackbar(
      title, // Title of the Snackbar
      message, // Message content
      backgroundColor: backgroundColor,
      colorText: textColor, // Text color
      snackPosition: position,
      icon: Icon(
        icon ?? (isSuccess ? Icons.check_circle : Icons.error), // Default icon based on `isSuccess`
        color: Colors.white,
      ),
      duration: duration, // Duration of the Snackbar
      margin: const EdgeInsets.all(10), // Margin around the Snackbar
      borderRadius: 8, // Rounded corners
    );
  }
    static AppController getAppController() {
    return Get.isRegistered<AppController>()
        ? Get.find<AppController>()
        : Get.put(AppController());
  }

  static ContestStatus getContestStatus(DateTime start, DateTime end) {
    return ContestStatus.fromDates(start, end);
  }
}
