import 'dart:convert';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:food_delivery_app/common/constants.dart';
import 'package:food_delivery_app/models/order_request.dart';
import 'package:food_delivery_app/models/order_response.dart';
import 'package:food_delivery_app/services/auth_service.dart';

class PaymentService {
  // Create order and get Razorpay order details
  static Future<OrderCreationResponse> createOrder(
      OrderRequest orderRequest) async {
    try {
      final String? accessToken = GetStorage().read('token');
      if (accessToken == null) {
        throw Exception('User not authenticated');
      }

      final Map<String, String> headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      };

      final Uri url = Uri.parse('$appBaseUrl/api/payment/create-order');

      print('Creating order at: $url');
      print('Order request: ${orderRequestToJson(orderRequest)}');

      final response = await http.post(
        url,
        headers: headers,
        body: orderRequestToJson(orderRequest),
      );

      print('Order creation response status: ${response.statusCode}');
      print('Order creation response body: ${response.body}');

      if (response.statusCode == 201 || response.statusCode == 200) {
        final responseData = json.decode(response.body);
        return OrderCreationResponse.fromJson(responseData);
      } else {
        final errorData = json.decode(response.body);
        throw Exception(errorData['message'] ?? 'Failed to create order');
      }
    } catch (e) {
      print('Exception in createOrder: $e');
      throw Exception('Failed to create order: $e');
    }
  }

  // Verify payment after successful Razorpay payment
  static Future<PaymentVerificationResponse> verifyPayment(
      PaymentVerificationRequest request) async {
    try {
      final String? accessToken = GetStorage().read('token');
      if (accessToken == null) {
        throw Exception('User not authenticated');
      }

      final Map<String, String> headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      };

      final Uri url = Uri.parse('$appBaseUrl/api/payment/verify');

      print('Verifying payment at: $url');
      print('Verification request: ${json.encode(request.toJson())}');

      final response = await http.post(
        url,
        headers: headers,
        body: json.encode(request.toJson()),
      );

      print('Payment verification response status: ${response.statusCode}');
      print('Payment verification response body: ${response.body}');

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        return PaymentVerificationResponse.fromJson(responseData);
      } else {
        final errorData = json.decode(response.body);
        throw Exception(errorData['message'] ?? 'Payment verification failed');
      }
    } catch (e) {
      print('=== ERROR IN PAYMENT VERIFICATION ===');
      print('Error: $e');
      rethrow; // Re-throw the original exception
    }
  }

  // Handle payment failure
  static Future<Map<String, dynamic>> handlePaymentFailure(
      PaymentFailureRequest request) async {
    try {
      final String? accessToken = GetStorage().read('token');
      if (accessToken == null) {
        throw Exception('User not authenticated');
      }

      final Map<String, String> headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      };

      final Uri url = Uri.parse('$appBaseUrl/api/payment/failure');

      print('Handling payment failure at: $url');
      print('Failure request: ${json.encode(request.toJson())}');

      final response = await http.post(
        url,
        headers: headers,
        body: json.encode(request.toJson()),
      );

      print('Payment failure response status: ${response.statusCode}');
      print('Payment failure response body: ${response.body}');

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        final errorData = json.decode(response.body);
        throw Exception(
            errorData['message'] ?? 'Failed to handle payment failure');
      }
    } catch (e) {
      print('Exception in handlePaymentFailure: $e');
      throw Exception('Failed to handle payment failure: $e');
    }
  }

  // Get user data for orders
  static Map<String, dynamic>? getUserData() {
    return AuthService.getCurrentUserData();
  }

  // Get user ID
  static String? getUserId() {
    return AuthService.getCurrentUserId();
  }
}
