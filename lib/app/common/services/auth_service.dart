import 'dart:convert';

import 'package:get/get.dart';
import '../../storage/storage_helper.dart';
import '../controller/app_controller.dart';
import '../../APIs/api_helper.dart';

/// Service class to handle authentication state and checks
/// Provides centralized methods to verify if user is logged in
/// and manage authentication state across the application
class AuthService extends GetxService {
  static AuthService get instance => Get.find<AuthService>();
  
  final AppController _appController = Get.find<AppController>();
  final ApiHelper _apiHelper = Get.find<ApiHelper>();
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
      final token = await getCurrentToken();
      
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
      
      // Decode JWT token if available to restore user role and other info
      if (token != null) {
        try {
          final decodedPayload = _appController.decodeJWT(token);
          print("AuthService: JWT payload restored: $decodedPayload");
        } catch (e) {
          print("AuthService: Error decoding JWT token: $e");
        }
      }
      
      print("AuthService: Authentication state restored successfully");
    } else {
      print("AuthService: No valid authentication found, clearing state");
      await clearAuthenticationState();
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

  /// Validate token with backend API
  /// Returns true if token is valid, false if invalid or expired
  /// Automatically handles logout if token is invalid
  Future<bool> validateTokenWithBackend() async {
    try {
      print("AuthService: Starting token validation with backend...");
      
      // Check if token exists locally first
      final hasToken = await StorageHelper.hasToken();
      if (!hasToken) {
        print("AuthService: No token found locally");
        await _handleInvalidToken();
        return false;
      }

      // Call the API to validate token
      final result = await _apiHelper.validateToken();
      
      return result.fold(
        (error) async {
          print("AuthService: Token validation failed - ${error.message}");
          await _handleInvalidToken();
          return false;
        },
        (tokenData) async {
          print("AuthService: Token validation successful");
          print("AuthService: Token data - $tokenData");
          
          // Update authentication state with fresh token data
          await _updateAuthFromTokenData(tokenData);
          
          return true;
        },
      );
    } catch (e) {
      print("AuthService: Error during token validation - $e");
      await _handleInvalidToken();
      return false;
    }
  }

  /// Check authentication with backend validation
  /// This method validates both local storage and backend token validity
  Future<bool> isAuthenticatedWithValidation() async {
    // First check local authentication
    final localAuth = await isAuthenticated();
    if (!localAuth) {
      print("AuthService: Local authentication failed");
      return false;
    }

    // Then validate with backend
    final backendValidation = await validateTokenWithBackend();
    return backendValidation;
  }

  /// Handle invalid token by clearing all data and redirecting
  Future<void> _handleInvalidToken() async {
    try {
      print("AuthService: Handling invalid token - clearing all data");
      
      // Clear all stored data
      await StorageHelper.removeToken();
      await StorageHelper.removeUserData();
      await StorageHelper.removeUserId();
      
      // Clear app controller state
      await clearAuthenticationState();
      
      print("AuthService: Cleared all user data, redirecting to login");
      
      // Show notification
      Get.snackbar(
        'Session Expired',
        'Your session has expired. Please login again.',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 3),
      );
      
      // Navigate to login screen
      Get.offAllNamed('/login');
    } catch (e) {
      print("AuthService: Error clearing user data - $e");
    }
  }

  /// Update authentication state from token validation data
  Future<void> _updateAuthFromTokenData(Map<String, dynamic> tokenData) async {
    try {
      // Update app controller with fresh data
      _appController.setLoginStatus(true);
      
      if (tokenData.containsKey('_id')) {
        _appController.userId.value = tokenData['_id'] ?? '';
      }
      if (tokenData.containsKey('userRole')) {
        _appController.userRole.value = tokenData['userRole'] ?? '';
      }
      
      // Update decoded token data
      _appController.decodedToken.value = tokenData;
      
      print("AuthService: Updated authentication state from token validation");
    } catch (e) {
      print("AuthService: Error updating auth state from token data - $e");
    }
  }

  /// Method to be called on app startup to check authentication status
  Future<void> checkAuthenticationOnStartup() async {
    print("AuthService: Checking authentication status on app startup");
    
    final isValid = await validateTokenWithBackend();
    if (isValid) {
      print("AuthService: User is authenticated with valid token");
      await updateAuthenticationState();
    } else {
      print("AuthService: User authentication failed or token expired");
      // User will be redirected to login by _handleInvalidToken
    }
  }
}
