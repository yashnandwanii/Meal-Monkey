import 'dart:convert';

// Order creation response (after creating order and Razorpay order)
class OrderCreationResponse {
  final bool success;
  final String message;
  final OrderCreationData? data;

  OrderCreationResponse({
    required this.success,
    required this.message,
    this.data,
  });

  factory OrderCreationResponse.fromJson(Map<String, dynamic> json) =>
      OrderCreationResponse(
        success: json['success'] ?? false,
        message: json['message'] ?? '',
        data: json['data'] != null
            ? OrderCreationData.fromJson(json['data'])
            : null,
      );
}

class OrderCreationData {
  final String orderId;
  final String razorpayOrderId;
  final int amount;
  final String currency;
  final String key;

  OrderCreationData({
    required this.orderId,
    required this.razorpayOrderId,
    required this.amount,
    required this.currency,
    required this.key,
  });

  factory OrderCreationData.fromJson(Map<String, dynamic> json) =>
      OrderCreationData(
        orderId: json['orderId'] ?? '',
        razorpayOrderId: json['razorpayOrderId'] ?? '',
        amount: json['amount']?.toInt() ?? 0,
        currency: json['currency'] ?? '',
        key: json['key'] ?? '',
      );
}

// Payment verification request models
class PaymentVerificationRequest {
  final String razorpayOrderId;
  final String razorpayPaymentId;
  final String razorpaySignature;
  final String orderId;

  PaymentVerificationRequest({
    required this.razorpayOrderId,
    required this.razorpayPaymentId,
    required this.razorpaySignature,
    required this.orderId,
  });

  Map<String, dynamic> toJson() => {
        'razorpay_order_id': razorpayOrderId,
        'razorpay_payment_id': razorpayPaymentId,
        'razorpay_signature': razorpaySignature,
        'orderId': orderId,
      };
}

class PaymentFailureRequest {
  final String orderId;
  final String? razorpayOrderId;
  final String? razorpayPaymentId;
  final Map<String, dynamic>? error;

  PaymentFailureRequest({
    required this.orderId,
    this.razorpayOrderId,
    this.razorpayPaymentId,
    this.error,
  });

  Map<String, dynamic> toJson() => {
        'orderId': orderId,
        'razorpay_order_id': razorpayOrderId,
        'razorpay_payment_id': razorpayPaymentId,
        'error': error,
      };
}

// Payment verification response
class PaymentVerificationResponse {
  final bool success;
  final String message;
  final VerificationData? data;

  PaymentVerificationResponse({
    required this.success,
    required this.message,
    this.data,
  });

  factory PaymentVerificationResponse.fromJson(Map<String, dynamic> json) =>
      PaymentVerificationResponse(
        success: json['success'] ?? false,
        message: json['message'] ?? '',
        data: json['data'] != null
            ? VerificationData.fromJson(json['data'])
            : null,
      );
}

class VerificationData {
  final String orderId;
  final String paymentId;
  final String orderStatus;
  final String paymentStatus;
  final double totalAmount;
  final String restaurantName;
  final DateTime orderDate;
  final DateTime estimatedDeliveryTime;
  final List<dynamic> orderItems;

  VerificationData({
    required this.orderId,
    required this.paymentId,
    required this.orderStatus,
    required this.paymentStatus,
    required this.totalAmount,
    required this.restaurantName,
    required this.orderDate,
    required this.estimatedDeliveryTime,
    required this.orderItems,
  });

  factory VerificationData.fromJson(Map<String, dynamic> json) =>
      VerificationData(
        orderId: json['orderId'] ?? '',
        paymentId: json['paymentId'] ?? '',
        orderStatus: json['orderStatus'] ?? '',
        paymentStatus: json['paymentStatus'] ?? '',
        totalAmount: json['totalAmount']?.toDouble() ?? 0.0,
        restaurantName: json['restaurantName'] ?? '',
        orderDate: DateTime.parse(json['orderDate']),
        estimatedDeliveryTime: DateTime.parse(json['estimatedDeliveryTime']),
        orderItems: List<dynamic>.from(json['orderItems'] ?? []),
      );
}
