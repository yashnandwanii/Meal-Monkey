import 'dart:convert';
import 'package:food_delivery_app/models/login_response.dart';
import 'package:food_delivery_app/view/on_boarding/on_boarding_view.dart';
import 'package:get_storage/get_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:food_delivery_app/common/constants.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class VerificationController extends GetxController {
  final box = GetStorage();

  void debugGetStorage() {
    final box = GetStorage();
    debugPrint('--- GetStorage Contents ---');
    box.getKeys().forEach((key) {
      debugPrint('$key: ${box.read(key)}');
    });
    debugPrint('----------------------------');
  }

  String _code = '';
  String get code => _code;

  set setCode(String value) {
    _code = value;
  }

  RxBool _isLoading = false.obs;
  bool get isLoading => _isLoading.value;

  set setLoading(bool value) {
    _isLoading.value = value;
  }

  Future<void> verificationFunction(String code) async {
    try {
      debugGetStorage();
      setLoading = true;

      // Get the temporary stored data from registration
      String? email = box.read('email');
      String? tempData = box.read('tempUserData');
      debugPrint('Verifying email: $email');
      debugPrint('Using verification code: $code');

      if (tempData == null) {
        Get.snackbar(
          'Error',
          'Registration data not found. Please register again.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          icon: const Icon(Ionicons.close_circle_outline, color: Colors.white),
          duration: const Duration(seconds: 2),
        );
        setLoading = false;
        return;
      }

      // Get stored token after registration
      String? token = box.read('token');

      Uri uri = Uri.parse('$appBaseUrl/api/users/verify/$code');
      Map<String, String> headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      };

      var response = await http.get(uri, headers: headers);
      debugPrint('Response status: ${response.statusCode}');
      debugPrint('Response body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        debugPrint('Verification successful');
        try {
          LoginResponse data = loginResponseFromJson(response.body);

          if (data.verification != true) {
            throw Exception('Verification status not updated properly');
          }

          // Store the verified user data
          String userId = data.id;
          String userData = jsonEncode(data);

          debugPrint('Verification - New Token: ${data.token}');
          debugPrint('Verification - User ID: $userId');
          debugPrint('Verification - Email: ${data.email}');

          // Clear old data and update with verified user data
          box.erase();

          box.write(userId, userData);
          box.write('token', data.token);
          box.write('userId', userId);
          box.write('verification', true);
          box.write('isLoggedIn', true);
          box.write('currentUserId', userId);

          // Debug: Verify what was stored
          debugPrint('After verification - Stored token: ${box.read('token')}');
          debugPrint(
              'After verification - Stored userId: ${box.read('userId')}');

          setLoading = false;

          Get.snackbar(
            'Success',
            'Email verified successfully!',
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.green,
            colorText: Colors.white,
            duration: const Duration(seconds: 2),
          );

          // Navigate to onboarding after short delay to allow snackbar to be seen
          Future.delayed(const Duration(seconds: 2), () {
            Get.offAll(() => const OnBoardingView());
          });
        } catch (parseError) {
          debugPrint('Error parsing response: $parseError');
          setLoading = false;
          Get.snackbar(
            'Error',
            'Invalid response from server',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            colorText: Colors.white,
            duration: const Duration(seconds: 3),
          );
          return;
        }
      } else {
        Map<String, dynamic> errorData = {};
        try {
          errorData = json.decode(response.body);
        } catch (e) {
          debugPrint('Error parsing error response: $e');
        }

        String errorMessage =
            errorData['message'] ?? 'Failed to verify email. Please try again.';
        if (response.statusCode == 404) {
          errorMessage =
              'Verification endpoint not found. Please contact support.';
        } else if (response.statusCode == 401) {
          errorMessage = 'Invalid verification code. Please try again.';
        }

        Get.snackbar(
          'Verification Failed',
          errorMessage,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          icon: const Icon(Ionicons.close_circle_outline, color: Colors.white),
          duration: const Duration(seconds: 3),
        );
        setLoading = false;
      }
    } catch (e) {
      debugPrint('Error during verification: $e');
      Get.snackbar(
        'Error',
        'An error occurred during verification. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        icon: const Icon(Ionicons.close_circle_outline, color: Colors.white),
        duration: const Duration(seconds: 3),
      );
      setLoading = false;
    }
  }

  Future<void> resendVerificationCode() async {
    try {
      setLoading = true;

      String? email = box.read('email');

      Uri uri = Uri.parse('$appBaseUrl/api/users/resend-verification');
      Map<String, String> headers = {
        'Content-Type': 'application/json',
      };

      Map<String, String> payload = {'email': email!};
      String jsonData = json.encode(payload);

      var response = await http.post(uri, headers: headers, body: jsonData);

      if (response.statusCode == 200 || response.statusCode == 201) {
        Get.snackbar(
          'Success',
          'Verification code resent. Please check your email.',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.green,
          colorText: Colors.white,
          duration: const Duration(seconds: 3),
        );
      } else {
        Map<String, dynamic> errorData = {};
        try {
          errorData = json.decode(response.body);
        } catch (e) {
          debugPrint('Error parsing error response: $e');
        }

        Get.snackbar(
          'Error',
          errorData['message'] ?? 'Failed to resend code. Please try again.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          duration: const Duration(seconds: 3),
        );
      }
    } catch (e) {
      debugPrint('Error resending verification code: $e');
      Get.snackbar(
        'Error',
        'Failed to resend verification code. Please try again.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );
    } finally {
      setLoading = false;
    }
  }
}
