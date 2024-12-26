import 'package:flutter/material.dart';

class CustomButton {
  // Static method to create a button
  static Widget button({
    required String text,
    required VoidCallback onPressed,
    bool isPrimary = true,
    double borderRadius = 8.0,
    double padding = 16.0,
    Color? backgroundColor,
    Color? textColor,
    double fontSize = 16.0,
    FontWeight fontWeight = FontWeight.bold,
    IconData? icon,
    double iconSize = 24.0,
    Color? iconColor,
  }) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: icon != null
          ? Icon(
              icon,
              size: iconSize,
              color: iconColor ?? (isPrimary ? Colors.white : Colors.black),
            )
          : const SizedBox.shrink(),
      label: Text(
        text,
        style: TextStyle(
          fontSize: fontSize,
          fontWeight: fontWeight,
          color: textColor ?? (isPrimary ? Colors.white : Colors.black),
        ),
      ),
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.all(padding),
        backgroundColor:
            backgroundColor ?? (isPrimary ? Colors.blue : Colors.grey[200]),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
    );
  }
}
