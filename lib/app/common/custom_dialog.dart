import 'package:flutter/material.dart';
import 'package:get/get.dart';

void showCustomDialog({
  required String title,
  required String message,
  required IconData icon,
  Color iconColor = Colors.blue,
}) {
  Get.dialog(
    AlertDialog(
      title: Row(
        children: [
          Icon(icon, color: iconColor),
          const SizedBox(width: 10),
          Text(title),
        ],
      ),
      content: Text(message),
      actions: [
        TextButton(
          onPressed: () => Get.back(),
          child: const Text('OK'),
        ),
      ],
    ),
  );
}
