import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:prostuti/app/common/custom_buttons.dart';
import 'package:prostuti/app/common/custom_styles.dart';
import 'package:prostuti/app/constant/app_color.dart';

import '../../../common/custom_text_input_field.dart';
import '../../../common/widgets/header_curve_logo_widget.dart';
import '../controller/email_varification_controller.dart';

class EmailVarificationView extends GetView<EmailVarificationController> {
  const EmailVarificationView({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = ScreenUtil().screenWidth;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 40, horizontal: 10.w),
          child: Obx(
            () => controller.isLoading.value
                ? const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Center(child: CircularProgressIndicator()),
                    ],
                  )
                : Column(
                    // mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const HeaderCurveLogoWidget(),
                      const SizedBox(
                        height: 20,
                      ),
                      Center(
                        child: Text(
                          'Enter the 4 Digit Code we sent to',
                          style: CustomStyles.textStyle.copyWith(
                              fontSize: 18.sp, fontWeight: FontWeight.w600),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Center(
                        child: Text(
                          '${controller.email}',
                          style: CustomStyles.textStyle.copyWith(
                              color: AppColors.midnightBlue.withOpacity(0.7)),
                        ),
                      ),
                      SizedBox(
                        height: 60.h,
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 5, horizontal: 5),
                        child: Row(
                          children: [
                            Expanded(
                                child: CustomTextInput(
                              borderRadius: 10,
                              controller: controller.code1,
                              textAlign: TextAlign.center,
                              onChange: controller.onCode1Change,
                            )),
                            SizedBox(width: 18.w),
                            Expanded(
                                child: CustomTextInput(
                              borderRadius: 10,
                              controller: controller.code2,
                              textAlign: TextAlign.center,
                              onChange: controller.onCode2Change,
                              // Assign the FocusNode for the second field
                              focusNode: controller.code2FocusNode,
                            )),
                            SizedBox(width: 18.w),
                            Expanded(
                                child: CustomTextInput(
                              borderRadius: 10,
                              controller: controller.code3,
                              textAlign: TextAlign.center,
                              onChange: controller.onCode3Change,
                              focusNode: controller.code3FocusNode,
                            )),
                            SizedBox(width: 18.w),
                            Expanded(
                                child: CustomTextInput(
                              borderRadius: 10,
                              controller: controller.code4,
                              textAlign: TextAlign.center,
                              onChange: controller.onCode4Change,
                              focusNode: controller.code4FocusNode,
                            )),
                          ],
                        ),
                      ),
                      if (controller.isSubmitEnable.value)
                        Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 5, horizontal: 5),
                            child: CustomButton.button(
                                text: "Submit",
                                onPressed: () {
                                  controller.verifyOtpAndHandleResponse();
                                })),
                      SizedBox(
                        height: 55.h,
                      ),
                      Center(
                        child: Text(
                          'Send Code Again',
                          style: CustomStyles.textStyle.copyWith(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w600,
                              color: AppColors.primary),
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}

class SocialButton extends StatelessWidget {
  final String icon;
  final VoidCallback onPressed;

  const SocialButton({
    super.key,
    required this.icon,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        padding: const EdgeInsets.all(16),
        backgroundColor: Colors.white,
        side: const BorderSide(color: AppColors.midnightBlue, width: 0.5),
      ),
      child: Image.asset(
        icon,
        width: 30.w,
        height: 30.h,
      ),
    );
  }
}
