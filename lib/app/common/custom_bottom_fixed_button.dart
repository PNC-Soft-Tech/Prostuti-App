import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:prostuti/app/common/custom_buttons.dart';

class CustomBottomFixedButton extends StatelessWidget {
  final String buttonText;
  final VoidCallback onPressed;

  const CustomBottomFixedButton({
    super.key,
    required this.buttonText,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
        child: Align(
            alignment: Alignment.bottomCenter,
            child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.r),
                  color: Colors.grey.withOpacity(.1),
                ),
                padding: EdgeInsets.symmetric(vertical: 24.h, horizontal: 19.w),
                child: CustomButton.button(
                  mainAxisSize: MainAxisSize.max,
                  text: buttonText,
                  onPressed: onPressed,
                ))));
  }
}
