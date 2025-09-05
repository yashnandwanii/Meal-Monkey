import 'package:flutter/material.dart';
import 'package:food_delivery_app/common/constants.dart';
import 'package:food_delivery_app/models/api_error.dart';
import 'package:food_delivery_app/models/payment_request.dart';
import 'package:food_delivery_app/models/payment_response.dart';
import 'package:food_delivery_app/models/hook_models/hook_result.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

FetchHook useProcessPayment() {
  final box = GetStorage();
  final paymentResponse = useState<PaymentResponse?>(null);
  final isLoading = useState<bool>(false);
  final error = useState<Exception?>(null);
  final apiError = useState<ApiError?>(null);

  Future<void> processPayment(PaymentRequest paymentRequest) async {
    String? accessToken = box.read('token');
    if (accessToken == null) {
      error.value = Exception('User not authenticated');
      return;
    }

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $accessToken',
    };

    isLoading.value = true;
    try {
      Uri url = Uri.parse('$appBaseUrl/api/payment/process');
      debugPrint('Processing payment at: $url');
      debugPrint('Payment request: ${paymentRequestToJson(paymentRequest)}');

      final response = await http.post(
        url,
        headers: headers,
        body: paymentRequestToJson(paymentRequest),
      );

      debugPrint('Payment response status: ${response.statusCode}');
      debugPrint('Payment response body: ${response.body}');

      if (response.statusCode == 201 || response.statusCode == 200) {
        final responseData = json.decode(response.body);
        paymentResponse.value = PaymentResponse.fromJson(responseData);
        debugPrint(
            'Payment processed successfully: ${paymentResponse.value?.message}');
      } else if (response.statusCode == 400) {
        apiError.value = ApiError.fromJson(json.decode(response.body));
        error.value = null;
        debugPrint('API Error: ${apiError.value?.message}');
      } else {
        throw Exception('Failed to process payment: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Exception in processPayment: $e');
      error.value = Exception(e.toString());
      apiError.value = null;
    } finally {
      isLoading.value = false;
    }
  }

  void reset() {
    paymentResponse.value = null;
    error.value = null;
    apiError.value = null;
  }

  return FetchHook(
    data: paymentResponse.value,
    isLoading: isLoading.value,
    error: error.value,
    refetch: () async {
      // This is a placeholder - the actual payment processing is done via processPayment method
      debugPrint('Refetch called - use processPayment method instead');
    },
  );
}
