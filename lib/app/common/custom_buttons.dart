import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../constant/app_color.dart';

class CustomButton {
  // Static method to create a button
  static Widget button({
    required String text,
    required VoidCallback onPressed,
    bool isPrimary = true,
    double borderRadius = 50.0,
    double padding = 16.0,
    Color? backgroundColor,
    Color? textColor,
    double fontSize = 16.0,
    FontWeight fontWeight = FontWeight.bold,
    IconData? icon,
    double iconSize = 24.0,
    Color? iconColor,
    String? image,
    bool? isSvgImage = false,
    bool? isImageLeft = true,
    bool? isNetworkImage = false,
    double? imageSpaing = 5.0,
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
      label: Row(
        children: [
          isImageLeft! && image != null
              ? isNetworkImage! && image != null
                  ? Image.network(image)
                  : !isSvgImage!? Image.asset(image): SvgPicture.asset(image)
              : Wrap(),
          isImageLeft && imageSpaing != null
              ? SizedBox(
                  width: imageSpaing,
                )
              : Wrap(),
          Text(
            text,
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: fontWeight,
              color: textColor ?? (isPrimary ? Colors.white : Colors.black),
            ),
          ),
          !isImageLeft && imageSpaing != null
              ? SizedBox(
                  width: imageSpaing,
                )
              : Wrap(),
          !isImageLeft! && image != null
              ? isNetworkImage! && image != null
                  ? Image.network(image)
                  :   !isSvgImage!? Image.asset(image): SvgPicture.asset(image)
              : Wrap(),
        ],
      ),
      style: ElevatedButton.styleFrom(
        padding: EdgeInsets.all(padding),
        backgroundColor: backgroundColor ??
            (isPrimary ? AppColors.primary : Colors.grey[200]),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
    );
  }
}
