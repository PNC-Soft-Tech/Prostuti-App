import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

void showLoadingDialog() {
  Get.dialog(
    const Center(
      child: CupertinoActivityIndicator(
        color: Colors.white,
        radius: 20,
      ),
    ),
    barrierDismissible: false,
  );
}
