import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../constant/app_color.dart';

class SharedQuestionCircleWidget extends StatelessWidget {
  final bool isCorrectAns;
  final bool
      isSelected; // Replace with actual logic to determine if the question is selected
  final bool
      showCorrectAns; // Replace with actual logic to determine if the question is selected
  const SharedQuestionCircleWidget({
    super.key,
    this.isCorrectAns = false,
    this.isSelected = false,
    this.showCorrectAns = false,
  });

  @override
  Widget build(BuildContext context) {
    return
    showCorrectAns?   Container(
      width: 26.w,
      height: 26.w,
      margin: EdgeInsets.only(top: 4.h),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: isCorrectAns ? Colors.green : Colors.black45,
          width: 1.5,
        ),
        color: isCorrectAns ? Colors.green : Colors.transparent,
      ),
      child: isCorrectAns
          ? Icon(
              Icons.check,
              color: Colors.white,
              size: 16.sp,
            )
          : isSelected && !isCorrectAns
              ? Icon(
                  Icons.close,
                  color: Colors.red,
                  size: 16.sp,
                )
              : null,
    ):
     Container(
      width: 26.w,
      height: 26.w,
      margin: EdgeInsets.only(top: 4.h),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: isSelected ? Colors.black : Colors.black45,
          width: 1.5,
        ),
        color: isSelected ? AppColors.primary : Colors.transparent,
      ),
      child: isSelected
          ? Icon(
              Icons.check,
              color: Colors.white,
              size: 16.sp,
            )
        
              : null,
    );
  }
}
