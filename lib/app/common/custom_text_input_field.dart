import 'package:flutter/material.dart';

class CustomTextInput extends StatelessWidget {
  final String? hintText;
  final String? labelText;
  final TextEditingController? controller;
  final TextInputType keyboardType;
  final TextCapitalization textCapitalization;
  final TextStyle? textStyle;
  final TextStyle? hintStyle;
  final TextStyle? labelStyle;
  final Color borderColor;
  final double borderRadius;
  final double borderWidth;
  final EdgeInsets padding;
  final EdgeInsets margin;
  final Color backgroundColor;
  final bool isDense;
  final bool obscureText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final VoidCallback? onTap;
  final ValueChanged<String>? onChange; // Updated type
  final TextAlign? textAlign;
  final FocusNode? focusNode;

  const CustomTextInput({
    super.key,
    this.hintText,
    this.labelText,
    this.controller,
    this.keyboardType = TextInputType.text,
    this.textCapitalization = TextCapitalization.none,
    this.textStyle,
    this.hintStyle,
    this.labelStyle,
    this.borderColor = Colors.grey,
    this.borderRadius = 8.0,
    this.borderWidth = 1.0,
    this.padding = const EdgeInsets.symmetric(horizontal: 12.0, vertical: 16.0),
    this.margin = const EdgeInsets.symmetric(vertical: 8.0),
    this.backgroundColor = Colors.white,
    this.isDense = false,
    this.obscureText = false,
    this.prefixIcon,
    this.suffixIcon,
    this.onTap,
    this.onChange,
    this.textAlign,
    this.focusNode,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      decoration: BoxDecoration(
        color: backgroundColor,
        border: Border.all(color: borderColor, width: borderWidth),
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: Padding(
        padding: padding,
        child: TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          textCapitalization: textCapitalization,
          obscureText: obscureText,
          style: textStyle,
          onTap: onTap,
          focusNode: focusNode,
          onChanged: onChange,
          textAlign: textAlign ?? TextAlign.start,
          decoration: InputDecoration(
            isDense: isDense,
            border: InputBorder.none,
            hintText: hintText,
            labelText: labelText,
            hintStyle: hintStyle,
            labelStyle: labelStyle,
            prefixIcon: prefixIcon,
            suffixIcon: suffixIcon,
          ),
        ),
      ),
    );
  }
}
