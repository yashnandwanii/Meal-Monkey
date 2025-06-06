import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:food_delivery_app/common/color_extension.dart';
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

  set setLoading(bool value) {
    _isLoading.value = value;
  }

  void registrationFunction(String data) async {
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
        var data = successModelFromJson(response.body);

        setLoading = false;
        

        Get.snackbar(
          'You are successfully registered,',
          data.message,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Tcolor.primary,
          colorText: Colors.white54,
          icon: const Icon(Ionicons.fast_food_outline, color: Colors.white54),
          duration: const Duration(seconds: 2),
        );
      } else {
        var error = apiErrorFromJson(response.body);
        setLoading = false;
        Get.snackbar(
          'Failed to register',
          error.message,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          icon: const Icon(Ionicons.close_circle_outline, color: Colors.white),
          duration: const Duration(seconds: 2),
        );
      }
    } catch (e) {
      debugPrint('Error during registration: $e');
      setLoading = false;
    }
  }
}
