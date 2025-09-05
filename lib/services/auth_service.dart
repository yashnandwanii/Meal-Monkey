import 'dart:convert';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:food_delivery_app/common/constants.dart';

class AuthService {
  static final GetStorage _box = GetStorage();

  /// Check if user is authenticated and token is valid
  static Future<bool> isAuthenticated() async {
    try {
      final token = _box.read('token');
      if (token == null) {
        return false;
      }

      // Check if token is expired by making a test API call
      final isValid = await _validateToken(token);

      if (!isValid) {
        // Clear invalid token and related data
        await clearUserData();
        return false;
      }

      return true;
    } catch (e) {
      print('Error checking authentication: $e');
      return false;
    }
  }

  /// Validate token by making a test API call
  static Future<bool> _validateToken(String token) async {
    try {
      final Map<String, String> headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      };

      // Use the addresses endpoint as a test since it requires authentication
      final Uri url = Uri.parse('$appBaseUrl/api/address/all');
      final response = await http.get(url, headers: headers);

      // If status is 401 or 403, token is invalid
      if (response.statusCode == 401 || response.statusCode == 403) {
        print('Token validation failed: ${response.statusCode}');
        return false;
      }

      // If status is 200, token is valid
      if (response.statusCode == 200) {
        print('Token validation successful');
        return true;
      }

      // For other status codes, assume token is valid but there might be other issues
      return true;
    } catch (e) {
      print('Error validating token: $e');
      // If there's a network error, assume token might be valid
      return true;
    }
  }

  /// Refresh user data after successful authentication
  static Future<void> refreshUserData() async {
    try {
      final token = _box.read('token');
      if (token == null) {
        throw Exception('No authentication token found');
      }

      print('Refreshing user data...');

      // You can add more data refresh calls here as needed
      // For example, refresh user profile, cart, addresses, etc.

      print('User data refresh completed');
    } catch (e) {
      print('Error refreshing user data: $e');
      // Don't throw error here as it's not critical for app startup
    }
  }

  /// Clear all user data from storage
  static Future<void> clearUserData() async {
    try {
      print('Clearing user data...');

      // Clear all authentication related data
      _box.remove('token');
      _box.remove('userId');
      _box.remove('currentUserId');
      _box.remove('tempUserData');
      _box.remove('verification');
      _box.remove('isLoggedIn');
      _box.remove('email');

      // Clear user-specific cached data
      final keys = _box.getKeys();
      for (String key in keys) {
        // Remove any user-specific cached data
        if (key.startsWith('user_') || key.startsWith('cache_')) {
          _box.remove(key);
        }
      }

      print('User data cleared successfully');
    } catch (e) {
      print('Error clearing user data: $e');
    }
  }

  /// Get current user data with validation
  static Map<String, dynamic>? getCurrentUserData() {
    try {
      final tempUserData = _box.read('tempUserData');
      if (tempUserData != null) {
        if (tempUserData is Map<String, dynamic>) {
          return tempUserData;
        } else if (tempUserData is String) {
          return json.decode(tempUserData) as Map<String, dynamic>;
        }
      }
      return null;
    } catch (e) {
      print('Error reading user data: $e');
      return null;
    }
  }

  /// Get current user ID
  static String? getCurrentUserId() {
    final userData = getCurrentUserData();
    return userData?['_id'];
  }

  /// Get current auth token
  static String? getAuthToken() {
    return _box.read('token');
  }

  /// Check if user is logged in (has valid session)
  static bool isLoggedIn() {
    return _box.read('isLoggedIn') == true && _box.hasData('token');
  }

  /// Perform complete authentication check and data refresh
  static Future<AuthenticationStatus> performAuthenticationCheck() async {
    try {
      print('=== PERFORMING AUTHENTICATION CHECK ===');

      // Step 1: Check if user has login session
      if (!isLoggedIn()) {
        print('No login session found');
        return AuthenticationStatus.notAuthenticated;
      }

      // Step 2: Validate token
      final isValid = await isAuthenticated();
      if (!isValid) {
        print('Token validation failed');
        return AuthenticationStatus.tokenExpired;
      }

      // Step 3: Refresh user data
      await refreshUserData();

      print('Authentication check completed successfully');
      return AuthenticationStatus.authenticated;
    } catch (e) {
      print('Error during authentication check: $e');
      return AuthenticationStatus.error;
    }
  }
}

enum AuthenticationStatus {
  authenticated,
  notAuthenticated,
  tokenExpired,
  error,
}
