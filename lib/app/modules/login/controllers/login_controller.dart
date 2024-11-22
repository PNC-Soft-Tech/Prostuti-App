import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../APIs/api_helper.dart';
import '../../../APIs/api_helper_implementation.dart';
import '../../../routes/app_pages.dart';
import '../../../storage/storage_helper.dart';

import '../models/login_request_model.dart';


class LoginController extends GetxController {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final ApiHelper _apiHelper = Get.find<ApiHelper>();


  var isLoading = false.obs;

  Future<void> login() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      Get.snackbar("Error", "Please enter both email and password",
          backgroundColor: Colors.redAccent, colorText: Colors.white);
      return;
    }

    isLoading(true);

    final loginRequest = LoginRequestModel(
      identifier: email,
      password: password,
    );

    final result = await _apiHelper.login(loginRequest);

    result.fold(
      (error) {
        log("log: ${error.message}");
        Get.snackbar("Login Failed", error.message ?? "Unknown error occurred",
            backgroundColor: Colors.redAccent, colorText: Colors.white);
      },
      (response) async {
        await StorageHelper.setToken(response.token);
        Get.snackbar("Login Success", "Welcome back!",
            backgroundColor: Colors.green, colorText: Colors.white);

        // Navigate to the dashboard
        Get.offAllNamed(Routes.jobCircular);
      },
    );

    isLoading(false);
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
