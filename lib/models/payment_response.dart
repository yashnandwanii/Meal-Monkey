import 'dart:convert';

PaymentResponse paymentResponseFromJson(String str) =>
    PaymentResponse.fromJson(json.decode(str));

String paymentResponseToJson(PaymentResponse data) =>
    json.encode(data.toJson());

class PaymentResponse {
  final bool success;
  final String message;
  final PaymentData? data;
  final String? orderId;
  final String? paymentId;

  PaymentResponse({
    required this.success,
    required this.message,
    this.data,
    this.orderId,
    this.paymentId,
  });

  factory PaymentResponse.fromJson(Map<String, dynamic> json) =>
      PaymentResponse(
        success: json["success"],
        message: json["message"],
        data: json["data"] != null ? PaymentData.fromJson(json["data"]) : null,
        orderId: json["orderId"],
        paymentId: json["paymentId"],
      );

  Map<String, dynamic> toJson() => {
        "success": success,
        "message": message,
        "data": data?.toJson(),
        "orderId": orderId,
        "paymentId": paymentId,
      };
}

class PaymentData {
  final String orderId;
  final String paymentId;
  final String orderStatus;
  final String paymentStatus;
  final double totalAmount;
  final String restaurantName;
  final String deliveryAddress;
  final DateTime orderDate;
  final DateTime estimatedDeliveryTime;

  PaymentData({
    required this.orderId,
    required this.paymentId,
    required this.orderStatus,
    required this.paymentStatus,
    required this.totalAmount,
    required this.restaurantName,
    required this.deliveryAddress,
    required this.orderDate,
    required this.estimatedDeliveryTime,
  });

  factory PaymentData.fromJson(Map<String, dynamic> json) => PaymentData(
        orderId: json["orderId"],
        paymentId: json["paymentId"],
        orderStatus: json["orderStatus"],
        paymentStatus: json["paymentStatus"],
        totalAmount: json["totalAmount"]?.toDouble(),
        restaurantName: json["restaurantName"],
        deliveryAddress: json["deliveryAddress"],
        orderDate: DateTime.parse(json["orderDate"]),
        estimatedDeliveryTime: DateTime.parse(json["estimatedDeliveryTime"]),
      );

  Map<String, dynamic> toJson() => {
        "orderId": orderId,
        "paymentId": paymentId,
        "orderStatus": orderStatus,
        "paymentStatus": paymentStatus,
        "totalAmount": totalAmount,
        "restaurantName": restaurantName,
        "deliveryAddress": deliveryAddress,
        "orderDate": orderDate.toIso8601String(),
        "estimatedDeliveryTime": estimatedDeliveryTime.toIso8601String(),
      };
}
