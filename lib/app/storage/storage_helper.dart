import 'dart:convert';
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

  // Set user data - properly encode to JSON string
  static Future<void> setUserData(Map<String, dynamic> userData) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String jsonString = jsonEncode(userData);
    await prefs.setString(_userKey, jsonString);
    
    // Only set userId if it exists in the userData
    if (userData.containsKey('_id')) {
      await prefs.setString(_userId, userData['_id']);
    }
  }

  // Get user data
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
  static Future<void> setUserId(String userId) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userId, userId);
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

  static Future<void> saveLatestContestId(String contestId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('latest_contestId', contestId);
  }

  static Future<String> getLatestContestId() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString("latest_contestId") ?? "";
  }
}
