import 'package:get/get.dart';
import '../../../APIs/api_helper.dart';
import '../../../common/widgets/breathing_animation/global_loading_manager.dart';
import '../../../routes/app_pages.dart';
import '../models/register_model.dart';

class RegisterController extends GetxController {
  final ApiHelper _apiHelper = Get.find<ApiHelper>();

  Future<void> registerUser(RegisterRequestModel model) async {
    try {
      final response = await GlobalLoadingManager.instance.showDuring(
        _apiHelper.register(model),
        message: 'Creating your account...',
      );
      
      response.fold(
        (error) => Get.snackbar('Error', error.message), // Error handling
        (data) {
          Get.toNamed(Routes.emailVarification,
              arguments: {"email": model.email});
          Get.snackbar('Success',
              'Registration successful! Now Verify OTP sent to your email'); // Success handling
        }
      );
    } catch (e) {
      Get.snackbar('Error', 'An unexpected error occurred.');
    }
  }
}
