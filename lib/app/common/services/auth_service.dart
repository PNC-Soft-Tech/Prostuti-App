import 'dart:convert';

import 'package:get/get.dart';
import '../../storage/storage_helper.dart';
import '../controller/app_controller.dart';

/// Service class to handle authentication state and checks
/// Provides centralized methods to verify if user is logged in
/// and manage authentication state across the application
class AuthService extends GetxService {
  static AuthService get instance => Get.find<AuthService>();
  
  final AppController _appController = Get.find<AppController>();
  
  /// Check if user is currently authenticated
  /// Returns true if user has valid token and user data
  Future<bool> isAuthenticated() async {
    try {
      // Check if token exists
      final hasToken = await StorageHelper.hasToken();
      if (!hasToken) {
        print("AuthService: No token found");
        return false;
      }
      
      // Check if token is not null or empty
      final token = await StorageHelper.getToken();
      if (token == null || token.isEmpty) {
        print("AuthService: Token is null or empty");
        return false;
      }
      
      // Check if user data exists
      final userData = await StorageHelper.getUserData();
      if (userData == null || userData.isEmpty) {
        print("AuthService: No user data found");
        return false;
      }
      
      // Try to parse user data to ensure it's valid
      try {
        final Map<String, dynamic> userMap = jsonDecode(userData);
        if (userMap.isEmpty || !userMap.containsKey('_id')) {
          print("AuthService: Invalid user data format");
          return false;
        }
      } catch (e) {
        print("AuthService: Error parsing user data: $e");
        return false;
      }
      
      // Check if userId exists in storage
      final userId = await StorageHelper.getUserId();
      if (userId == null || userId.isEmpty) {
        print("AuthService: No userId found");
        return false;
      }
      
      // Additional check: verify AppController has valid data
      if (_appController.userId.value.isEmpty) {
        print("AuthService: AppController userId is empty");
        return false;
      }
      
      print("AuthService: User is authenticated");
      return true;
    } catch (e) {
      print("AuthService: Error checking authentication: $e");
      return false;
    }
  }
  
  /// Check if user is authenticated, if not redirect to login
  /// Returns true if authenticated, false if redirected to login
  Future<bool> requireAuthentication({String? redirectMessage}) async {
    final isAuth = await isAuthenticated();
    
    if (!isAuth) {
      print("AuthService: User not authenticated, redirecting to login");
      
      // Show message if provided
      if (redirectMessage != null) {
        Get.snackbar(
          'Authentication Required', 
          redirectMessage,
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 3),
        );
      }
      
      // Redirect to login
      Get.offAllNamed('/login');
      return false;
    }
    
    return true;
  }
  
  /// Get current user ID if authenticated
  /// Returns null if not authenticated
  Future<String?> getCurrentUserId() async {
    final isAuth = await isAuthenticated();
    if (!isAuth) return null;
    
    return await StorageHelper.getUserId();
  }
  
  /// Get current user token if authenticated
  /// Returns null if not authenticated
  Future<String?> getCurrentToken() async {
    final isAuth = await isAuthenticated();
    if (!isAuth) return null;
    
    return await StorageHelper.getToken();
  }
  
  /// Get current user data if authenticated
  /// Returns null if not authenticated
  Future<Map<String, dynamic>?> getCurrentUserData() async {
    final isAuth = await isAuthenticated();
    if (!isAuth) return null;
    
    final userData = await StorageHelper.getUserData();
    if (userData == null) return null;
    
    try {
      return jsonDecode(userData);
    } catch (e) {
      print("AuthService: Error parsing current user data: $e");
      return null;
    }
  }
  
  /// Update authentication state in AppController
  /// Call this after login to sync authentication state
  Future<void> updateAuthenticationState() async {
    final isAuth = await isAuthenticated();
    _appController.setLoginStatus(isAuth);
    
    if (isAuth) {
      final userId = await getCurrentUserId();
      final userData = await getCurrentUserData();
      
      if (userId != null) {
        _appController.userId.value = userId;
      }
      
      if (userData != null) {
        _appController.saveUserData(userData);
        
        // Update username if available
        final fullName = userData['fullName'] ?? userData['name'] ?? '';
        if (fullName.isNotEmpty) {
          _appController.updateUsername(fullName);
        }
      }
    }
  }
  
  /// Clear authentication state
  /// Call this during logout
  Future<void> clearAuthenticationState() async {
    _appController.setLoginStatus(false);
    _appController.userId.value = '';
    _appController.username.value = '';
    _appController.userRole.value = '';
    _appController.userData.value = {};
    _appController.decodedToken.value = {};
  }
  
  /// Quick authentication check without detailed logging
  /// Useful for UI conditional rendering
  Future<bool> isLoggedIn() async {
    try {
      final hasToken = await StorageHelper.hasToken();
      if (!hasToken) return false;
      
      final token = await StorageHelper.getToken();
      return token != null && token.isNotEmpty;
    } catch (e) {
      return false;
    }
  }
  
  /// Check if specific feature requires authentication
  /// and handle accordingly
  Future<bool> checkFeatureAccess({
    required String featureName,
    String? customMessage,
  }) async {
    final isAuth = await isAuthenticated();
    
    if (!isAuth) {
      final message = customMessage ?? 
          'You need to be logged in to access $featureName. Please login to continue.';
      
      return await requireAuthentication(redirectMessage: message);
    }
    
    return true;
  }
}
