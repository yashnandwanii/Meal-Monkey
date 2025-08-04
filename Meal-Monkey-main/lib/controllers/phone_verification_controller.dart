import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:food_delivery_app/common/constants.dart';
import 'package:food_delivery_app/models/login_response.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

class PhoneVerificationController extends GetxController {
  final box = GetStorage();

  String _phoneNo = '';
  String get phone => _phoneNo;

  set setPhoneNo(String value) {
    _phoneNo = value;
  }

  RxBool _isLoading = false.obs;
  bool get isLoading => _isLoading.value;

  set setLoading(bool value) {
    _isLoading.value = value;
  }

  Future<void> verifyPhoneNumber() async {
    setLoading = true;

    String accessToken = box.read('token');

    Uri uri = Uri.parse('$appBaseUrl/api/users/verify_phone/$phone');

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $accessToken',
    };
    try {
      var response = await http.post(uri, headers: headers);

      if (response.statusCode != 200) {
        var error = jsonDecode(response.body);
        setLoading = false;
        Get.snackbar(
          'Failed to verify phone number',
          error['message'] ?? 'An error occurred',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          icon: const Icon(Icons.error, color: Colors.white),
          duration: const Duration(seconds: 2),
        );
        return;
      }
      await Future.delayed(const Duration(seconds: 2));

      LoginResponse data = loginResponseFromJson(response.body);
      String userId = data.id;
      String userData = jsonEncode(data);

      box.write(userId, userData);
      box.write('token', data.token);
      box.write('userId', userId);
      box.write('verification', data.verification);
      box.write('phoneNumber', phone);
      setLoading = false;
      Get.snackbar(
        'Success',
        'Phone number verified successfully',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
        icon: const Icon(Icons.check_circle, color: Colors.white),
        duration: const Duration(seconds: 2),
      );
      Get.back();
    } catch (e) {
      setLoading = false;
      Get.snackbar(
        'Error',
        'Failed to verify phone number. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        icon: const Icon(Icons.error, color: Colors.white),
        duration: const Duration(seconds: 2),
      );
    }
  }
}
