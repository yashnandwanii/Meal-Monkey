import 'package:food_delivery_app/common/constants.dart';
import 'package:food_delivery_app/models/api_error.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

dynamic useUpdateCartItem() {
  final box = GetStorage();
  final isLoading = useState<bool>(false);
  final error = useState<Exception?>(null);
  final apiError = useState<ApiError?>(null);

  Future<void> decreaseQuantity(String itemId) async {
    String? accessToken = box.read('token');
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $accessToken',
    };
    isLoading.value = true;
    try {
      Uri url = Uri.parse('$appBaseUrl/api/cart/decrement/$itemId');
      final response = await http.get(url, headers: headers);

      if (response.statusCode == 200) {
        error.value = null;
      } else if (response.statusCode == 400) {
        apiError.value = ApiError.fromJson(json.decode(response.body));
      } else {
        error.value = Exception('Failed to update cart item');
      }
    } catch (e) {
      error.value = e as Exception;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> increaseQuantity(String itemId, String productId) async {
    String? accessToken = box.read('token');
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $accessToken',
    };
    isLoading.value = true;
    try {
      Uri url = Uri.parse('$appBaseUrl/api/cart');
      final response = await http.post(
        url,
        headers: headers,
        body: json.encode({
          'productId': productId,
          'quantity': 1,
          'additives': [],
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        error.value = null;
      } else if (response.statusCode == 400) {
        apiError.value = ApiError.fromJson(json.decode(response.body));
      } else {
        error.value = Exception('Failed to update cart item');
      }
    } catch (e) {
      error.value = e as Exception;
    } finally {
      isLoading.value = false;
    }
  }

  return {
    'isLoading': isLoading.value,
    'error': error.value,
    'apiError': apiError.value,
    'decreaseQuantity': decreaseQuantity,
    'increaseQuantity': increaseQuantity,
  };
}
