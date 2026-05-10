import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../APIs/api_helper.dart';
import '../../APIs/api_helper_implementation.dart';
import '../../common/controller/app_controller.dart';
import '../../constant/app_color.dart';
import '../../modules/contests/models/contest_status.dart';
import '../../storage/storage_helper.dart';
import 'package:html/parser.dart' show parseFragment;

class Utils {
  static Future<void> logoutUser() async {
    try {
      // Get AppController instance
      final AppController appController = getAppController();

      // Clear reactive variables in AppController
      appController.userId.value = '';
      appController.username.value = '';
      appController.userRole.value = '';
      appController.isLoggedIn.value = false;
      appController.userData.value = {};
      appController.decodedToken.value = {};

      // Clear SharedPreferences
      await StorageHelper.removeToken();
      await StorageHelper.removeUserData();
      await StorageHelper.removeUserId();

      // Navigate to login or splash screen
      Get.offAllNamed(
          '/login'); // Replace '/login' with your actual login route
    } catch (e) {
      print("Error during logout: $e");
    }
  }

  static void showSnackbar({
    required String message,
    String title = 'Notice',
    Color backgroundColor = AppColors.primary,
    Color textColor = Colors.white,
    SnackPosition position = SnackPosition.BOTTOM,
    bool isSuccess = true,
    Duration duration = const Duration(seconds: 3),
    IconData? icon,
  }) {
    // Defer to the next frame so Get's overlay context has a chance to
    // settle. Then check the overlay is actually mounted BEFORE calling
    // Get.snackbar — because Get.snackbar enqueues the job asynchronously
    // and the overlay lookup happens later in a microtask, a synchronous
    // try/catch around Get.snackbar can't catch that throw. The cleanest
    // way to avoid the crash is to skip when no overlay is available.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final ctx = Get.overlayContext;
      if (ctx == null || Overlay.maybeOf(ctx) == null) {
        // ignore: avoid_print
        print('showSnackbar skipped (no overlay): $title - $message');
        return;
      }
      try {
        Get.snackbar(
          title,
          message,
          backgroundColor: backgroundColor,
          colorText: textColor,
          snackPosition: position,
          icon: Icon(
            icon ?? (isSuccess ? Icons.check_circle : Icons.error),
            color: Colors.white,
          ),
          duration: duration,
          margin: const EdgeInsets.all(10),
          borderRadius: 8,
        );
      } catch (e) {
        // ignore: avoid_print
        print('showSnackbar suppressed: $e | $title - $message');
      }
    });
  }

  static AppController getAppController() {
    return Get.isRegistered<AppController>()
        ? Get.find<AppController>()
        : Get.put(AppController());
  }

  static ApiHelper getApiHelperController() {
    return Get.isRegistered<ApiHelper>()
        ? Get.find<ApiHelper>()
        : Get.put(ApiHelperImpl());
  }

  static ContestStatus getContestStatus(DateTime start, DateTime end) {
    return ContestStatus.fromDates(start, end);
  }

  /// Formats a [DateTime] into "সোমবার, ২২ ডিসেম্বর, ২৪  10:00 AM" format
  static String formatDateToBangla(DateTime date) {
    final DateFormat formatter =
        DateFormat('dd MMMM, hh:mm a', 'bn_BD'); //'EEEE, dd MMMM, yy hh:mm a'
    return formatter.format(date);
  }

  static String formatDateToBanglaDDM(DateTime date) {
    List<String> bengaliMonths = [
      'জানুয়ারি',
      'ফেব্রুয়ারি',
      'মার্চ',
      'এপ্রিল',
      'মে',
      'জুন',
      'জুলাই',
      'আগস্ট',
      'সেপ্টেম্বর',
      'অক্টোবর',
      'নভেম্বর',
      'ডিসেম্বর'
    ];

    String day = convertNumberToBengali(date.day);
    String month = bengaliMonths[date.month - 1];

    return '$day $month';
  }

  static String convertNumberToBengali(int number) {
    List<String> bengaliDigits = [
      '০',
      '১',
      '২',
      '৩',
      '৪',
      '৫',
      '৬',
      '৭',
      '৮',
      '৯'
    ];

    String numberString = number.toString();
    StringBuffer bengaliNumber = StringBuffer();

    for (int i = 0; i < numberString.length; i++) {
      int digit = int.parse(numberString[i]);
      bengaliNumber.write(bengaliDigits[digit]);
    }

    return bengaliNumber.toString();
  }

  static String formatLatexString(String title) {
    // Ensuring LaTeX format is correct by adding the $ symbols
    if (!title.startsWith(r'$\displaystyle') && !title.startsWith(r'$')) {
      return r'$\displaystyle ' +
          title.replaceAll(RegExp(r'\$'), '\\\$') +
          r'$';
    }
    return title; // Return the title if it's already correctly formatted
  }

  static String stripHtmlTags(String input) {
    // Use a regular expression to remove HTML tags
    return input.replaceAll(RegExp(r'<[^>]*>'), '');
  }

// Function to check if the title contains formula expressions
  static bool containsFormulaExpression(String title) {
    // Regex pattern for common LaTeX formula expressions
    RegExp formulaRegex = RegExp(
        r'\\frac{.*?}{.*?}|\\sqrt{.*?}|[a-zA-Z0-9]+[\^]{1}[a-zA-Z0-9]+|[a-zA-Z0-9]+\/[a-zA-Z0-9]+');

    // Check if the title matches any of the patterns
    return formulaRegex.hasMatch(title);
  }

  static String decodeHtmlEntities(String input) {
    final fragment = parseFragment(input);
    return fragment.text ?? '';
  }
}
