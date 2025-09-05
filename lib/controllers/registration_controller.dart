import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:food_delivery_app/common/constants.dart';
import 'package:food_delivery_app/models/api_error.dart';
import 'package:food_delivery_app/models/success_model.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

class RegistrationController extends GetxController {
  final box = GetStorage();

  RxBool _isLoading = false.obs;
  bool get isLoading => _isLoading.value;
  set setLoading(bool value) => _isLoading.value = value;

  Future<bool> registrationFunction(String data) async {
    setLoading = true;

    Uri uri = Uri.parse('$appBaseUrl/register');
    Map<String, String> headers = {
      'Content-Type': 'application/json',
    };

    try {
      var response = await http.post(uri, body: data, headers: headers);
      debugPrint('Response status: ${response.statusCode}');
      debugPrint('Response body: ${response.body}');

      if (response.statusCode == 201) {
        var successResponse = successModelFromJson(response.body);
        debugPrint('SUCCESS: $successResponse');

        // Parse the registration data
        Map<String, dynamic> registrationData = json.decode(data);
        String email = registrationData['email'];

        // Clear ALL existing data to prevent token conflicts
        box.erase();

        debugPrint('New registration - Token: ${successResponse.token}');
        debugPrint('New registration - User ID: ${successResponse.id}');
        debugPrint('New registration - Email: $email');

        // Store new registration data
        box.write('verification', false); // Initial verification status
        box.write('email', email); // Store email for verification process
        box.write('tempUserData', data); // Store temporary user data
        box.write('token', successResponse.token); // Store the JWT token
        box.write('userId', successResponse.id); // Store the user ID

        // Debug GetStorage contents
        debugPrint('--- GetStorage Contents After Registration ---');
        debugPrint('Email: $email');
        debugPrint('Verification Status: ${box.read('verification')}');
        debugPrint('Token: ${box.read('token')}');
        debugPrint('UserId: ${box.read('userId')}');
        debugPrint('------------------------------------------------');

        setLoading = false;
        return true;
      } else {
        try {
          debugPrint('Error response body: ${response.body}');
          var error = apiErrorFromJson(response.body);
          setLoading = false;
          Get.snackbar(
            'Registration Failed',
            error.message,
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            colorText: Colors.white,
            icon:
                const Icon(Ionicons.close_circle_outline, color: Colors.white),
            duration: const Duration(seconds: 3),
          );
          debugPrint('Error: ${error.message}');
          return false;
        } catch (parseError) {
          debugPrint('Error parsing error response: $parseError');
          setLoading = false;
          Get.snackbar(
            'Registration Failed',
            'An unexpected error occurred. Please try again.',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            colorText: Colors.white,
            icon:
                const Icon(Ionicons.close_circle_outline, color: Colors.white),
            duration: const Duration(seconds: 3),
          );
          return false;
        }
      }
    } catch (e) {
      debugPrint('Error during registration: $e');
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
}
