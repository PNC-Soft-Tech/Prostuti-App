import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PostutiDialog {
  /// Display a custom modal with flexible parameters
  static void show({
    required String title,
    required String message,
    required IconData icon,
    required Color iconColor,
    bool isBottomButton = false,
    bool isCentered = false,
    int noOfButtons = 1,
    List<String>? buttonLabels,
    List<VoidCallback>? buttonActions,
  }) {
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: 50,
                color: iconColor,
              ),
              const SizedBox(height: 16),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: isCentered ? TextAlign.center : TextAlign.start,
              ),
              const SizedBox(height: 8),
              Text(
                message,
                style: const TextStyle(
                  fontSize: 16,
                ),
                textAlign: isCentered ? TextAlign.center : TextAlign.start,
              ),
              const SizedBox(height: 16),
              if (isBottomButton)
                Column(
                  children: [
                    const Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: List.generate(noOfButtons, (index) {
                        return ElevatedButton(
                          onPressed: buttonActions != null &&
                                  buttonActions.length > index
                              ? buttonActions[index]
                              : () => Get.back(),
                          child: Text(buttonLabels != null &&
                                  buttonLabels.length > index
                              ? buttonLabels[index]
                              : "Button ${index + 1}"),
                        );
                      }),
                    ),
                  ],
                ),
              if (!isBottomButton)
                ElevatedButton(
                  onPressed: () => Get.back(),
                  child: const Text("Close"),
                ),
            ],
          ),
        ),
      ),
      barrierDismissible: false,
    );
  }

  /// Display a predefined error modal
  static void error(String message,
      {String? title,
      bool isBottomButton = false,
      int noOfButtons = 1,
      List<String>? buttonLabels,
      List<VoidCallback>? buttonActions}) {
    show(
      title: title ?? "Error",
      message: message,
      icon: Icons.error,
      iconColor: Colors.red,
      isBottomButton: isBottomButton,
      noOfButtons: noOfButtons,
      buttonLabels: buttonLabels,
      buttonActions: buttonActions,
    );
  }

  /// Display a predefined success modal
  static void success(String message,
      {String? title,
      bool isBottomButton = false,
      int noOfButtons = 1,
      List<String>? buttonLabels,
      List<VoidCallback>? buttonActions}) {
    show(
      title: title ?? "Success",
      message: message,
      icon: Icons.check_circle,
      iconColor: Colors.green,
      isBottomButton: isBottomButton,
      noOfButtons: noOfButtons,
      buttonLabels: buttonLabels,
      buttonActions: buttonActions,
    );
  }

  /// Display a predefined info modal
  static void info(String message,
      {String? title,
      bool isBottomButton = false,
      int noOfButtons = 1,
      List<String>? buttonLabels,
      List<VoidCallback>? buttonActions}) {
    show(
      title: title ?? "Info",
      message: message,
      icon: Icons.info,
      iconColor: Colors.blue,
      isBottomButton: isBottomButton,
      noOfButtons: noOfButtons,
      buttonLabels: buttonLabels,
      buttonActions: buttonActions,
    );
  }

  /// Display a predefined warning modal
  static void warning(String message,
      {String? title,
      bool isBottomButton = false,
      int noOfButtons = 1,
      List<String>? buttonLabels,
      List<VoidCallback>? buttonActions}) {
    show(
      title: title ?? "Warning",
      message: message,
      icon: Icons.warning,
      iconColor: Colors.orange,
      isBottomButton: isBottomButton,
      noOfButtons: noOfButtons,
      buttonLabels: buttonLabels,
      buttonActions: buttonActions,
    );
  }
}
