import 'package:flutter/material.dart';

class CustomAppBar {
  // Static method to create a custom app bar
  static PreferredSizeWidget appBar({
    required String title,
    bool centerTitle = true,
    Color? backgroundColor,
    Color? titleColor,
    List<Widget>? actions,
    IconData? leadingIcon,
    VoidCallback? onLeadingPressed,
  }) {
    return AppBar(
      title: Text(
        title,
        style: TextStyle(
          color: titleColor ?? Colors.white,
          fontSize: 20.0,
          fontWeight: FontWeight.bold,
        ),
      ),
      centerTitle: centerTitle,
      backgroundColor: backgroundColor ?? Colors.blue,
      actions: actions,
      leading: leadingIcon != null
          ? IconButton(
              icon: Icon(
                leadingIcon,
                color: titleColor ?? Colors.white,
              ),
              onPressed: onLeadingPressed,
            )
          : null,
    );
  }
}
