import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:food_delivery_app/models/addresses_response.dart';
import 'package:food_delivery_app/models/foods.dart';
import 'package:food_delivery_app/models/restaurents.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:get_storage/get_storage.dart';
import 'package:food_delivery_app/common/constants.dart';

Future<void> saveOrderToMongoDB({
  required String paymentId,
  required String orderId,
  required double amount,
  required RestaurentsModel restaurant,
  required FoodItem food,
  required AddressResponse? address,
}) async {
  try {
    final box = GetStorage();
    String? accessToken = box.read('token');

    if (accessToken == null) {
      throw Exception('User not authenticated');
    }

    if (address == null) {
      throw Exception('Delivery address is required');
    }

    // Create order data
    final orderData = {
      "orderItems": [
        {
          "foodId": food.id,
          "quantity": 1,
          "price": food.price,
          "additives": food.additives.map((a) => a.title).toList(),
          "instructions": ""
        }
      ],
      "orderTotal": food.price,
      "deliveryFee": 20.0,
      "grandTotal": food.price + 20.0,
      "deliveryAddress": address.id,
      "restaurantAddress": restaurant.coords.address,
      "restaurantId": restaurant.id,
      "paymentMethod": "Razorpay",
      "paymentStatus": "Completed",
      "orderStatus": "Placed",
      "restaurantCoords": [
        restaurant.coords.longitude,
        restaurant.coords.latitude
      ],
      "recipientCoords": [address.longitude, address.latitude],
      "promoCode": null,
      "discountAmount": 0,
      "notes": "Order placed via mobile app"
    };

    // Send order to backend
    final response = await http.post(
      Uri.parse('$appBaseUrl/api/order'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
      body: jsonEncode(orderData),
    );

    if (response.statusCode == 201) {
      final responseData = jsonDecode(response.body);
      Fluttertoast.showToast(
        msg: "Order saved successfully! Order ID: ${responseData['orderId']}",
        backgroundColor: Colors.green,
        textColor: Colors.white,
      );
    } else if (response.statusCode == 400) {
      final errorData = jsonDecode(response.body);
      throw Exception(errorData['message'] ?? 'Failed to save order');
    } else if (response.statusCode == 401) {
      throw Exception('Authentication failed. Please login again.');
    } else if (response.statusCode == 500) {
      throw Exception('Server error. Please try again later.');
    } else {
      throw Exception('Failed to save order: ${response.statusCode}');
    }
  } catch (e) {
    debugPrint('Error saving order: $e');
    Fluttertoast.showToast(
      msg: "Failed to save order: ${e.toString()}",
      backgroundColor: Colors.red,
      textColor: Colors.white,
    );
    rethrow;
  }
}

// Additional order service functions
Future<Map<String, dynamic>> getOrderStatus(String orderId) async {
  try {
    final box = GetStorage();
    String? accessToken = box.read('token');

    if (accessToken == null) {
      throw Exception('User not authenticated');
    }

    final response = await http.get(
      Uri.parse('$appBaseUrl/api/order/$orderId'),
      headers: {
        'Authorization': 'Bearer $accessToken',
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to get order status');
    }
  } catch (e) {
    debugPrint('Error getting order status: $e');
    rethrow;
  }
}

Future<void> cancelOrder(String orderId) async {
  try {
    final box = GetStorage();
    String? accessToken = box.read('token');

    if (accessToken == null) {
      throw Exception('User not authenticated');
    }

    final response = await http.put(
      Uri.parse('$appBaseUrl/api/order/$orderId/cancel'),
      headers: {
        'Authorization': 'Bearer $accessToken',
      },
    );

    if (response.statusCode == 200) {
      Fluttertoast.showToast(
        msg: "Order cancelled successfully",
        backgroundColor: Colors.orange,
        textColor: Colors.white,
      );
    } else {
      throw Exception('Failed to cancel order');
    }
  } catch (e) {
    debugPrint('Error cancelling order: $e');
    Fluttertoast.showToast(
      msg: "Failed to cancel order: ${e.toString()}",
      backgroundColor: Colors.red,
      textColor: Colors.white,
    );
    rethrow;
  }
}

Future<void> rateOrder(String orderId, double rating, String? feedback) async {
  try {
    final box = GetStorage();
    String? accessToken = box.read('token');

    if (accessToken == null) {
      throw Exception('User not authenticated');
    }

    final ratingData = {
      "rating": rating,
      "feedback": feedback ?? "",
    };

    final response = await http.post(
      Uri.parse('$appBaseUrl/api/order/$orderId/rate'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
      body: jsonEncode(ratingData),
    );

    if (response.statusCode == 200) {
      Fluttertoast.showToast(
        msg: "Thank you for your rating!",
        backgroundColor: Colors.green,
        textColor: Colors.white,
      );
    } else {
      throw Exception('Failed to submit rating');
    }
  } catch (e) {
    debugPrint('Error rating order: $e');
    Fluttertoast.showToast(
      msg: "Failed to submit rating: ${e.toString()}",
      backgroundColor: Colors.red,
      textColor: Colors.white,
    );
    rethrow;
  }
}
