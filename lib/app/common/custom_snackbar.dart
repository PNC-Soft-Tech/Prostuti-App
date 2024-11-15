import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomSnackbar {
  // Show a success snackbar
  static void success({
    required String title,
    required String message,
    Duration duration = const Duration(seconds: 3),
  }) {
    _showSnackbar(
      title: title,
      message: message,
      backgroundColor: Colors.green,
      icon: Icons.check_circle,
      duration: duration,
    );
  }

  // Show an error snackbar
  static void error({
    required String title,
    required String message,
    Duration duration = const Duration(seconds: 3),
  }) {
    _showSnackbar(
      title: title,
      message: message,
      backgroundColor: Colors.red,
      icon: Icons.error,
      duration: duration,
    );
  }

  // Show an information snackbar
  static void info({
    required String title,
    required String message,
    Duration duration = const Duration(seconds: 3),
  }) {
    _showSnackbar(
      title: title,
      message: message,
      backgroundColor: Colors.blue,
      icon: Icons.info,
      duration: duration,
    );
  }

  // Show a warning snackbar
  static void warning({
    required String title,
    required String message,
    Duration duration = const Duration(seconds: 3),
  }) {
    _showSnackbar(
      title: title,
      message: message,
      backgroundColor: Colors.orange,
      icon: Icons.warning,
      duration: duration,
    );
  }

  // Private method to display the snackbar
  static void _showSnackbar({
    required String title,
    required String message,
    required Color backgroundColor,
    required IconData icon,
    required Duration duration,
  }) {
    Get.snackbar(
      title,
      message,
      icon: Icon(
        icon,
        color: Colors.white,
      ),
      backgroundColor: backgroundColor,
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
      margin: const EdgeInsets.all(16.0),
      borderRadius: 8.0,
      duration: duration,
      animationDuration: const Duration(milliseconds: 300),
      isDismissible: true,
    );
  }
}
