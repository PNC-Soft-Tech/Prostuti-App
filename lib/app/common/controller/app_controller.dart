import 'dart:convert';
import 'dart:developer';

import 'package:get/get.dart';

import '../../APIs/api_helper.dart';
import '../utils/prostuti_utils.dart';
import '../../storage/storage_helper.dart';
import '../../routes/app_pages.dart';

class AppController extends GetxController {
    final ApiHelper _apiHelper = Utils.getApiHelperController();

  // Example of global variables
  var username = ''.obs; // Reactive variable
  var isLoggedIn = false.obs;
  var appTheme = 'light'.obs; // Example: theme management

  // Global data store
  var userData = {}.obs; // Storing user-related data in a map
  var settings = {}.obs; // Storing app settings
  // Example global variable to store decoded JWT payload
  var decodedToken = <String, dynamic>{}.obs;

  // New Rx variables for _id and userRole
  var userId = ''.obs;
  var userRole = ''.obs;

  // Example functions to manage data
  void updateUsername(String newName) {
    username.value = newName;
  }

  void setLoginStatus(bool status) {
    isLoggedIn.value = status;
  }

  void toggleTheme() {
    appTheme.value = appTheme.value == 'light' ? 'dark' : 'light';
  }

  void saveUserData(Map<String, dynamic> data) {
    userData.value = data;
  }

  Map<String, dynamic> retrieveUserData() {
    return userData.value.cast<String, dynamic>();
  }

  void updateSetting(String key, dynamic value) {
    settings[key] = value;
  }

  dynamic getSetting(String key) {
    return settings[key];
  }

  // Decode JWT function
  Map<String, dynamic> decodeJWT(String token) {
    try {
      // Split the token into its parts
      final parts = token.split('.');
      if (parts.length != 3) {
        throw Exception('Invalid JWT token');
      }

      // Decode the payload
      final payload = parts[1];
      final normalized =
          base64.normalize(payload); // Normalize the base64 string
      final decodedBytes =
          base64.decode(normalized); // Decode the base64 string
      final decodedString =
          utf8.decode(decodedBytes); // Convert bytes to a UTF-8 string
      final payloadMap = json.decode(decodedString); // Parse JSON string to Map
      // Store the decoded payload
      decodedToken.value = payloadMap;
      log("payload map: $payloadMap");
      // Extract and save _id and userRole into Rx variables
      if (payloadMap.containsKey('_id')) {
        userId.value = payloadMap['_id'] ?? '';
      }
      if (payloadMap.containsKey('userRole')) {
        userRole.value = payloadMap['userRole'] ?? '';
      }
      log(" user id: ${userId.value}");
      log(" user role: ${userRole.value}");
      if (payloadMap is! Map<String, dynamic>) {
        throw Exception('Invalid payload');
      }

      // Store the decoded payload
      decodedToken.value = payloadMap;

      return payloadMap;
    } catch (e) {
      print('Error decoding JWT: $e');
      return {};
    }
  }

  // Token validation method
  Future<bool> validateToken() async {
    try {
      log('AppController: Validating token...');
      
      // Check if token exists in storage
      final hasToken = await StorageHelper.hasToken();
      if (!hasToken) {
        log('AppController: No token found in storage');
        await _handleInvalidToken();
        return false;
      }

      // Validate token with API
      final result = await _apiHelper.validateToken();
      
      return result.fold(
        (error) async {
          log('AppController: Token validation failed - ${error.message}');
          await _handleInvalidToken();
          return false;
        },
        (tokenData) {
          log('AppController: Token validation successful');
          log('AppController: Token data - ${tokenData}');
          
          // Update user data with validated token information
          if (tokenData.containsKey('_id')) {
            userId.value = tokenData['_id'] ?? '';
          }
          if (tokenData.containsKey('userRole')) {
            userRole.value = tokenData['userRole'] ?? '';
          }
          
          // Update login status
          setLoginStatus(true);
          
          return true;
        },
      );
    } catch (e) {
      log('AppController: Error during token validation - $e');
      await _handleInvalidToken();
      return false;
    }
  }

  // Helper method to handle invalid token
  Future<void> _handleInvalidToken() async {
    try {
      // Clear all stored data
      await StorageHelper.removeToken();
      await StorageHelper.removeUserData();
      await StorageHelper.removeUserId();
      
      // Reset controller state
      setLoginStatus(false);
      userId.value = '';
      userRole.value = '';
      decodedToken.value = {};
      userData.value = {};
      
      log('AppController: Cleared all user data and redirecting to login');
      
      // Navigate to login screen
      Get.offAllNamed(Routes.login);
    } catch (e) {
      log('AppController: Error clearing user data - $e');
    }
  }

  // Method to check token on app startup
  Future<void> checkAuthenticationStatus() async {
    log('AppController: Checking authentication status on app startup');
    
    final isValid = await validateToken();
    if (isValid) {
      log('AppController: User is authenticated, staying logged in');
      // User is authenticated, they can stay on current screen
    } else {
      log('AppController: User is not authenticated, redirecting to login');
      // User will be redirected to login by _handleInvalidToken
    }
  }
}
