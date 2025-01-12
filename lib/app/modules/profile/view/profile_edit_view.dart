import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:prostuti/app/common/custom_simple_appbar.dart';
import 'package:prostuti/app/common/custom_styles.dart';
import 'package:prostuti/app/modules/profile/controllers/profile_controller.dart';

class ProfileEditView extends GetView<ProfileController> {
  const ProfileEditView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomSimpleAppBar.appBar(title: 'Edit Profile'),
      body: Container(
          child: Text(
        'Hello edit profile',
        style: CustomStyles.textStyle,
      )),
    );
  }
}
