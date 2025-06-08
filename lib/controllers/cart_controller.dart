import 'package:flutter/material.dart';
import 'package:food_delivery_app/common/constants.dart';
import 'package:food_delivery_app/models/api_error.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

class CartController extends GetxController {
  final box = GetStorage();

  RxBool _isLoading = false.obs;
  bool get isLoading => _isLoading.value;
  set setLoading(bool value) => _isLoading.value = value;

  void addToCart(String cart) async {
    setLoading = true;

    String token = box.read('token');

    var uri = Uri.parse('$appBaseUrl/api/cart/add');

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };

    try {
      var response = await http.post(uri, headers: headers, body: cart);

      if (response.statusCode == 201) {
        setLoading = false;
        Get.snackbar(
          'Added to Cart',
          'Enjoy your awesome experience.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
          icon: const Icon(Icons.check_circle_outline, color: Colors.white),
          duration: const Duration(seconds: 2),
        );
      } else {
        var error = apiErrorFromJson(response.body);
        debugPrint('Error: ${error.message}');
        setLoading = false;
        Get.snackbar(
          'Error',
          'Failed to add product to cart',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          icon: const Icon(Icons.error, color: Colors.white),
          duration: const Duration(seconds: 2),
        );
      }
    } catch (e) {
      debugPrint('Exception: $e');
      setLoading = false;
      Get.snackbar(
        'Error',
        'Failed to add product to cart: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        icon: const Icon(Icons.error, color: Colors.white),
        duration: const Duration(seconds: 3),
      );
    }
  }

  void removeFromCart(String productId) async {
    setLoading = true;

    String token = box.read('token');

    var uri = Uri.parse('$appBaseUrl/api/cart/delete/$productId');

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };

    try {
      var response = await http.delete(
        uri,
        headers: headers,
      );

      if (response.statusCode == 200) {
        setLoading = false;
        Get.snackbar(
          'Removed from Cart',
          'Product has been removed from your cart.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
          icon: const Icon(Icons.check_circle_outline, color: Colors.white),
          duration: const Duration(seconds: 2),
        );
      } else {
        var error = apiErrorFromJson(response.body);
        debugPrint('Error: ${error.message}');
        setLoading = false;
        Get.snackbar(
          'Error',
          'Failed to remove product from cart',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          icon: const Icon(Icons.error, color: Colors.white),
          duration: const Duration(seconds: 2),
        );
      }
    } catch (e) {
      debugPrint('Exception: $e');
      setLoading = false;
      Get.snackbar(
        'Error',
        'Failed to remove product from cart: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        icon: const Icon(Icons.error, color: Colors.white),
        duration: const Duration(seconds: 3),
      );
    }
  }
}
