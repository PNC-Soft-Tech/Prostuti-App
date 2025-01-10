import 'package:shared_preferences/shared_preferences.dart';

class StorageHelper {
  static const String _tokenKey = "auth_token";
  static const String _userKey = "user_data";
  static const String _userId = "userId";

  // Set token
  static Future<void> setToken(String token) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
  }

  // Get token
  static Future<String?> getToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  // Remove token (optional, for logout)
  static Future<void> removeToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
  }

  // Check if token exists
  static Future<bool> hasToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.containsKey(_tokenKey);
  }

  // Set token
  static Future<void> setUserData(Map<String, dynamic> userData) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userKey, userData.toString());
    await prefs.setString('userId', userData.toString());
  }

  // Get token
  static Future<String?> getUserData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_userKey);
  }

  // Remove user data (optional, for logout)
  static Future<void> removeUserData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userKey);
  }


    // Set user Id
  static Future<void> setUserId(String userData) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userId, userData.toString());

  }

  // Get user id
  static Future<String?> getUserId() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_userId);
  }

  // Remove user id (optional, for logout)
  static Future<void> removeUserId() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userId);
  }
}
