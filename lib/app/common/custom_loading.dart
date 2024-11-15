import 'package:flutter/material.dart';
import 'package:get/get.dart';

void showLoadingDialog() {
  Get.dialog(
    Center(
      child: CircularProgressIndicator(),
    ),
    barrierDismissible: false,
  );
}
