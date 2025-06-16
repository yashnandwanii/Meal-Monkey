import 'package:fluttertoast/fluttertoast.dart';
import 'package:food_delivery_app/models/addresses_response.dart';
import 'package:food_delivery_app/models/foods.dart';
import 'package:food_delivery_app/models/restaurents.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

Future<void> saveOrderToMongoDB({
  required String paymentId,
  required String orderId,
  required double amount,
  required RestaurentsModel restaurant,
  required FoodItem food,
  required AddressResponse? address,
}) async {
  final url = Uri.parse(
      'http://172.25.240.244:6013/api/orders/save'); // Replace with your actual endpoint

  final body = {
    "paymentId": paymentId,
    "orderId": orderId,
    "amount": amount,
    "restaurantId": restaurant.id,
    "restaurantName": restaurant.title,
    "foodId": food.id,
    "foodName": food.title,
    "additives": food.additives,
    "deliveryAddress": {
      "line1": address?.addressLine1,
      "postalCode": address?.postalCode,
    },
    "timestamp": DateTime.now().toIso8601String(),
  };

  final response = await http.post(
    url,
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode(body),
  );

  if (response.statusCode == 200) {
    Fluttertoast.showToast(msg: "Order saved successfully!");
  } else {
    Fluttertoast.showToast(msg: "Failed to save order: ${response.body}");
  }
}
