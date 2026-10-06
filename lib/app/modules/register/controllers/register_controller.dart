import 'dart:async';
import 'dart:developer';

import 'package:get/get.dart';

import '../../../APIs/api_helper.dart';
import '../../../routes/app_pages.dart';
import '../models/register_model.dart';

/// Outcome of a registration attempt — returned to the form so it can show
/// a SnackBar via ScaffoldMessenger (more reliable than Get.snackbar in this
/// codebase, which has been observed to silently no-op when overlay context
/// resolution flakes).
class RegisterResult {
  final bool success;
  final String message;
  final int? statusCode;

  const RegisterResult.success(this.message)
      : success = true,
        statusCode = 200;

  const RegisterResult.failure(this.message, this.statusCode) : success = false;
}

class RegisterController extends GetxController {
  final ApiHelper _apiHelper = Get.find<ApiHelper>();

  final isRegistering = false.obs;

  Future<RegisterResult> registerUser(RegisterRequestModel model) async {
    if (isRegistering.value) {
      return const RegisterResult.failure(
        'Registration already in progress…',
        null,
      );
    }

    isRegistering.value = true;
    try {
      // The global GetConnect timeout is 5 minutes (AppConfig.timeoutDuration).
      // A signup that doesn't respond within ~25s isn't going to — Vercel cold
      // starts top out around 10s, so 25s gives a generous margin while still
      // failing fast enough to keep the UI responsive.
      final response = await _apiHelper
          .register(model)
          .timeout(const Duration(seconds: 25));

      return response.fold(
        (error) {
          log('Register failed [${error.code}]: ${error.message}');

          // Backend sometimes returns the literal string "null" if the message
          // field is missing — don't surface that to the user.
          final raw = error.message.trim();
          final friendly = (raw.isEmpty || raw.toLowerCase() == 'null')
              ? "We couldn't create your account. Please try again."
              : raw;
          return RegisterResult.failure(friendly, error.code);
        },
        (_) {
          // Navigation happens here; the form shows the success snackbar so
          // it stays anchored to the verification screen the user lands on.
          Get.toNamed(
            Routes.emailVarification,
            arguments: {"email": model.email},
          );
          return RegisterResult.success(
            'Verify the OTP we sent to ${model.email}.',
          );
        },
      );
    } on TimeoutException catch (_) {
      log('Register timed out after 25s');
      return const RegisterResult.failure(
        'The server is taking too long to respond. Please try again.',
        null,
      );
    } catch (e, st) {
      log('Register unexpected error: $e\n$st');
      return const RegisterResult.failure(
        'Please check your connection and try again.',
        null,
      );
    } finally {
      isRegistering.value = false;
    }
  }
}
