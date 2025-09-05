import 'package:flutter/material.dart';
import 'package:food_delivery_app/common/constants.dart';
import 'package:food_delivery_app/models/api_error.dart';
import 'package:food_delivery_app/models/cart_response.dart';
import 'package:food_delivery_app/models/hook_models/hook_result.dart';
import 'package:food_delivery_app/services/auth_service.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:get/get.dart';
import 'package:food_delivery_app/controllers/cart_controller.dart';

FetchHook useFetchCart() {
  final cart = useState<List<CartResponse>?>(null);
  final isLoading = useState<bool>(false);
  final error = useState<Exception?>(null);
  final apiError = useState<ApiError?>(null);

  Future<void> fetchData() async {
    String? accessToken = AuthService.getAuthToken();

    if (accessToken == null) {
      error.value = Exception('No authentication token found');
      return;
    }

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $accessToken',
    };

    isLoading.value = true;
    try {
      Uri url = Uri.parse('$appBaseUrl/api/cart');
      final response = await http.get(url, headers: headers);

      // debugPrint('Cart fetch response status: ${response.statusCode}');
      // debugPrint('Cart fetch response body: ${response.body}');

      if (response.statusCode == 200) {
        cart.value = cartResponseFromJson(response.body);
        // debugPrint('Cart data: ${cart.value}');
      } else if (response.statusCode == 401 || response.statusCode == 403) {
        // Token expired or invalid
        print('Authentication failed while fetching cart - clearing user data');
        await AuthService.clearUserData();
        Get.offAllNamed('/');
        error.value = Exception('Authentication failed. Please login again.');
      } else if (response.statusCode == 400) {
        apiError.value = ApiError.fromJson(json.decode(response.body));
        error.value = null;
      } else {
        throw Exception('Failed to load cart: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Cart fetch error: $e');
      error.value = Exception(e.toString());
      apiError.value = null;
    } finally {
      isLoading.value = false;
    }
  }

  useEffect(() {
    fetchData();
    return null;
  }, []);

  // Listen to cart updates
  useEffect(() {
    final subscription = ever(CartController.cartUpdated, (_) {
      fetchData();
    });
    return () => subscription();
  }, []);

  void refetch() {
    isLoading.value = true;
    fetchData();
  }

  return FetchHook(
    data: cart.value,
    isLoading: isLoading.value,
    error: error.value,
    refetch: refetch,
  );
}
