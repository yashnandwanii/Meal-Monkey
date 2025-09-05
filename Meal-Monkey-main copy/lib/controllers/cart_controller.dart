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

  // Event to notify cart updates
  static final RxBool cartUpdated = false.obs;
  static void notifyCartUpdate() => cartUpdated.toggle();

  void addToCart(String cart) async {
    setLoading = true;
    String token = box.read('token');
    var uri = Uri.parse('$appBaseUrl/api/cart');

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };

    try {
      var response = await http.post(uri, headers: headers, body: cart);
      debugPrint('Response status: ${response.statusCode}');
      debugPrint('Response body: ${response.body}');
      debugPrint('Request body: $cart');

      if (response.statusCode == 201 || response.statusCode == 200) {
        setLoading = false;
        // Notify cart update
        notifyCartUpdate();
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
        setLoading = false;
        var error = apiErrorFromJson(response.body);

        // Check if this is a "different restaurant" error
        if (response.statusCode == 400 &&
            error.message.contains('one restaurant at a time')) {
          debugPrint('Different restaurant error detected');

          // Show dialog asking user to clear cart or cancel
          Get.dialog(
            AlertDialog(
              title: const Text('Different Restaurant'),
              content: Text(error.message),
              actions: [
                TextButton(
                  onPressed: () => Get.back(),
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () {
                    Get.back();
                    clearCartAndAddItem(cart);
                  },
                  child: const Text(
                    'Clear Cart & Add',
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              ],
            ),
            barrierDismissible: false,
          );
        } else {
          debugPrint('Error: ${error.message}');
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

  void clearCartAndAddItem(String cart) async {
    setLoading = true;

    try {
      // First clear the cart
      await clearCart();

      // Then add the new item
      String token = box.read('token');
      var uri = Uri.parse('$appBaseUrl/api/cart');

      Map<String, String> headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      };

      var response = await http.post(uri, headers: headers, body: cart);
      debugPrint('Add after clear - Response status: ${response.statusCode}');
      debugPrint('Add after clear - Response body: ${response.body}');

      if (response.statusCode == 201 || response.statusCode == 200) {
        setLoading = false;
        // Notify cart update
        notifyCartUpdate();
        Get.snackbar(
          'Cart Updated',
          'Previous items removed. New item added to cart.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
          icon: const Icon(Icons.check_circle_outline, color: Colors.white),
          duration: const Duration(seconds: 3),
        );
      } else {
        setLoading = false;
        var error = apiErrorFromJson(response.body);
        debugPrint('Error after clear: ${error.message}');
        Get.snackbar(
          'Error',
          'Failed to add product to cart after clearing',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          icon: const Icon(Icons.error, color: Colors.white),
          duration: const Duration(seconds: 2),
        );
      }
    } catch (e) {
      debugPrint('Exception in clearCartAndAddItem: $e');
      setLoading = false;
      Get.snackbar(
        'Error',
        'Failed to update cart: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        icon: const Icon(Icons.error, color: Colors.white),
        duration: const Duration(seconds: 3),
      );
    }
  }

  Future<void> clearCart() async {
    String token = box.read('token');
    var uri = Uri.parse(
        '$appBaseUrl/api/cart/clear/userId'); // The actual userId is extracted from token on backend

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };

    try {
      var response = await http.delete(uri, headers: headers);
      debugPrint('Clear cart - Response status: ${response.statusCode}');
      debugPrint('Clear cart - Response body: ${response.body}');

      if (response.statusCode == 200) {
        debugPrint('Cart cleared successfully');
        // Notify cart update
        notifyCartUpdate();
      } else {
        var error = apiErrorFromJson(response.body);
        debugPrint('Error clearing cart: ${error.message}');
        throw Exception('Failed to clear cart');
      }
    } catch (e) {
      debugPrint('Exception clearing cart: $e');
      throw e;
    }
  }

  void removeFromCart(String productId, Function refetch) async {
    setLoading = true;

    String token = box.read('token');

    var uri = Uri.parse('$appBaseUrl/api/cart/$productId');

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };

    try {
      var response = await http.delete(
        uri,
        headers: headers,
      );

      debugPrint('Response status: ${response.statusCode}');
      debugPrint('Response body: ${response.body}');

      if (response.statusCode == 200) {
        setLoading = false;

        // Notify cart update
        notifyCartUpdate();

        await refetch();

        debugPrint('Product removed from cart successfully');
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
