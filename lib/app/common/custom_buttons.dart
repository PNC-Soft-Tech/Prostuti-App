import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

import '../constant/app_color.dart';

class CustomButton {
  // Static method to create a button
  static Widget button({
    required String text,
    required VoidCallback onPressed,
    bool isPrimary = true,
    double borderRadius = 50.0,
    double padding = 0,
    double paddingX = 16.0,
    double paddingY = 16.0,
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
    MainAxisSize? mainAxisSize = MainAxisSize.min,
  }) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: icon != null
          ? Icon(
              icon,
              size: iconSize,
              color: iconColor ?? (isPrimary ? Colors.white : Colors.black),
            )
          : null,
      // : const SizedBox.shrink(),
      label: Row(
        mainAxisSize: mainAxisSize ?? MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          isImageLeft! && image != null
              ? isNetworkImage!
                  ? Image.network(image)
                  : !isSvgImage!
                      ? Image.asset(image)
                      : SvgPicture.asset(image)
              : const Wrap(),
          isImageLeft && imageSpaing != null
              ? SizedBox(
                  width: imageSpaing,
                )
              : const Wrap(),
          Text(text,
              style: GoogleFonts.inter(
                textStyle: TextStyle(
                  fontSize: fontSize,
                  fontWeight: fontWeight,
                  color: textColor ?? (textColor ?? Colors.white),
                ),
              )),
          !isImageLeft && imageSpaing != null
              ? SizedBox(
                  width: imageSpaing,
                )
              : const Wrap(),
          !isImageLeft && image != null
              ? isNetworkImage!
                  ? Image.network(image)
                  : !isSvgImage!
                      ? Image.asset(image)
                      : SvgPicture.asset(image)
              : const Wrap(),
        ],
      ),
      style: ElevatedButton.styleFrom(
        padding: padding > 0
            ? EdgeInsets.all(padding)
            : EdgeInsets.symmetric(vertical: paddingY, horizontal: paddingX),
        backgroundColor: backgroundColor ??
            (isPrimary ? AppColors.primary : Colors.grey[200]),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
    );
  }
}
