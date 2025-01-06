import 'package:get/get.dart';
import '../../../APIs/api_helper.dart';
import '../../../routes/app_pages.dart';
import '../models/register_model.dart';

class RegisterController extends GetxController {
  final ApiHelper _apiHelper = Get.find<ApiHelper>();

  var isLoading = false.obs;

  Future<void> registerUser(RegisterRequestModel model) async {
    isLoading.value = true;
    try {
      final response = await _apiHelper
          .register(model); // Call register method from ApiHelper
      response.fold(
          (error) => Get.snackbar('Error', error.message), // Error handling
          (data) {
        Get.toNamed(Routes.emailVarification,
            arguments: {"email": model.email});
        Get.snackbar('Success',
            'Registration successful! Now Verify OTP sent to your email'); // Success handling
      });
    } catch (e) {
      Get.snackbar('Error', 'An unexpected error occurred.');
    } finally {
      isLoading.value = false;
    }
  }
}
