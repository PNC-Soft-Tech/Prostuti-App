import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:prostuti/app/common/custom_bottom_fixed_button.dart';
import 'package:prostuti/app/common/custom_simple_appbar.dart';
import 'package:prostuti/app/common/custom_styles.dart';
import 'package:prostuti/app/modules/profile/controllers/profile_controller.dart';

class ProfileEditView extends GetView<ProfileController> {
  const ProfileEditView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomSimpleAppBar.appBar(title: 'Edit Profile'),
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Text(
            'Hello edit profile 2',
            style: CustomStyles.textStyle,
          ),
          CustomBottomFixedButton(buttonText: 'Save Details', onPressed: () {})
        ],
      ),
    );
  }
}
