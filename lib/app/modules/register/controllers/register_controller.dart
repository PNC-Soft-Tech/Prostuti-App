import 'package:get/get.dart';
import 'package:dartz/dartz.dart';
import '../../../APIs/api_helper.dart';
import '../../../APIs/api_helper_implementation.dart';
import '../models/register_model.dart';


class RegisterController extends GetxController {
  final ApiHelper _apiHelper = Get.find<ApiHelper>();

  var isLoading = false.obs;

  Future<void> registerUser(RegisterRequestModel model) async {
    isLoading.value = true;
    try {
      final response = await _apiHelper.register(model); // Call register method from ApiHelper
      response.fold(
        (error) => Get.snackbar('Error', error.message), // Error handling
        (data) => Get.snackbar('Success', 'Registration successful!'), // Success handling
      );
    } catch (e) {
      Get.snackbar('Error', 'An unexpected error occurred.');
    } finally {
      isLoading.value = false;
    }
  }
}
