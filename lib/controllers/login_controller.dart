import 'dart:convert';

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

  void loginFunction(String data) async {
    setLoading = true;

    Uri uri = Uri.parse('$appBaseUrl/login');
    Map<String, String> headers = {
      'Content-Type': 'application/json',
    };

    try {
      var response = await http.post(uri, body: data, headers: headers);

      if (response.statusCode == 200) {
        LoginResponse data = loginResponseFromJson(response.body);
        String userId = data.id;
        String userData = jsonEncode(data);

        box.write('currentUserId', userId);
        box.write(userId, userData);
        box.write('token', data.token);
        box.write('userId', userId);
        box.write('verification', data.verification);

        setLoading = false;
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
      }
    } catch (e) {
      debugPrint('Error during login: $e');
      setLoading = false;
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

  LoginResponse? getUserInfo() {
    String? userId = box.read('userId');
    String? data;
    if (userId != null) {
      data = box.read(userId);
    }

    if (data != null) {
      return loginResponseFromJson(data);
    } else {
      return null;
    }
  }
}
