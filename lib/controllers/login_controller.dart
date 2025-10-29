import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:food_delivery_app/common/color_extension.dart';
import 'package:food_delivery_app/models/api_error.dart';
import 'package:food_delivery_app/models/login_response.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:food_delivery_app/common/constants.dart';
import 'package:http/http.dart' as http;

class LoginController extends GetxController {
  final box = GetStorage();

  RxBool _isLoading = false.obs;

  bool get isLoading => _isLoading.value;

  set setLoading(bool value) {
    _isLoading.value = value;
  }

  Future<bool> loginFunction(String data) async {
    setLoading = true;

    Uri uri = Uri.parse('$appBaseUrl/login');
    debugPrint('=== LOGIN REQUEST ===');
    debugPrint('Using base URL: $appBaseUrl');
    debugPrint('Full URL: ${uri.toString()}');
    debugPrint('Platform: ${Platform.operatingSystem}');
    debugPrint('===================');
    
    Map<String, String> headers = {
      'Content-Type': 'application/json',
    };

    try {
      var response = await http.post(uri, body: data, headers: headers);

      if (response.statusCode == 200) {
        LoginResponse data = loginResponseFromJson(response.body);
        String userId = data.id;
        String userData = jsonEncode(data);

        // Clear all existing user data and tokens first
        box.erase();

        debugPrint('New login - Token: ${data.token}');
        debugPrint('New login - User ID: $userId');
        debugPrint('New login - Email: ${data.email}');

        // Store new user data
        box.write('currentUserId', userId);
        box.write(userId, userData);
        box.write('tempUserData', userData);
        box.write('token', data.token);
        box.write('userId', userId);
        box.write('verification', data.verification);
        box.write('isLoggedIn', true);

        // Debug: Verify what was actually stored
        debugPrint('Stored token: ${box.read('token')}');
        debugPrint('Stored userId: ${box.read('userId')}');

        setLoading = false;
        return true;
      } else {
        var error = apiErrorFromJson(response.body);
        setLoading = false;
        Get.snackbar(
          'Failed to login',
          error.message,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          icon: const Icon(Ionicons.close_circle_outline, color: Colors.white),
          duration: const Duration(seconds: 2),
        );
        return false;
      }
    } catch (e) {
      debugPrint('Error during login: $e');
      setLoading = false;
      Get.snackbar(
        'Connection Error',
        'Unable to connect to server. Please check your internet connection and try again.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        icon: const Icon(Ionicons.close_circle_outline, color: Colors.white),
        duration: const Duration(seconds: 3),
      );
      return false;
    }
  }

  void logout() {
    box.erase();
    Get.offAllNamed('/login');
    Get.snackbar(
      'Logged Out',
      'You have been logged out successfully',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Tcolor.primary,
      colorText: Colors.white54,
      icon: const Icon(Ionicons.log_out_outline, color: Colors.white54),
      duration: const Duration(seconds: 2),
    );
  }

  void debugGetStorage() {
    debugPrint('--- GetStorage Contents ---');
    debugPrint('All keys: ${box.getKeys()}');
    box.getKeys().forEach((key) {
      var value = box.read(key);
      if (key == 'token') {
        debugPrint('$key: $value');
      } else if (key.contains('userId') || key.contains('User')) {
        debugPrint('$key: $value');
      } else {
        debugPrint(
            '$key: ${value.toString().length > 100 ? '${value.toString().substring(0, 100)}...' : value}');
      }
    });
    debugPrint('----------------------------');
  }

  LoginResponse? getUserInfo() {
    String? userId = box.read('userId');
    if (userId == null) return null;

    String? data = box.read(userId);
    return loginResponseFromJsonSafe(data);
  }
}
