import 'package:shared_preferences/shared_preferences.dart';

class StorageHelper {
  static const String _tokenKey = "auth_token";
  static const String _userKey = "user_data";

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
  static Future<void> setUserData(Map<String, dynamic> token) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userKey, token.toString());
  }

  // Get token
  static Future<String?> getUserData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_userKey);
  }

  // Remove token (optional, for logout)
  static Future<void> removeUserData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userKey);
  }
}
