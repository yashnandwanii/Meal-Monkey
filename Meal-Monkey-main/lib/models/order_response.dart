// Models for payment-related API responses

class OrderCreationResponse {
  final bool success;
  final String message;
  final OrderCreationData? data;

  OrderCreationResponse({
    required this.success,
    required this.message,
    this.data,
  });

  factory OrderCreationResponse.fromJson(Map<String, dynamic> json) {
    return OrderCreationResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      data: json['data'] != null
          ? OrderCreationData.fromJson(json['data'])
          : null,
    );
  }
}

class OrderCreationData {
  final String orderId;
  final String razorpayOrderId;
  final double amount;
  final String key;
  final String currency;

  OrderCreationData({
    required this.orderId,
    required this.razorpayOrderId,
    required this.amount,
    required this.key,
    required this.currency,
  });

  factory OrderCreationData.fromJson(Map<String, dynamic> json) {
    return OrderCreationData(
      orderId: json['orderId'] ?? '',
      razorpayOrderId: json['razorpayOrderId'] ?? '',
      amount: (json['amount'] ?? 0).toDouble(),
      key: json['key'] ?? 'rzp_test_1DP5mmOlF5G5ag', // Default Razorpay key
      currency: json['currency'] ?? 'INR',
    );
  }
}

class PaymentVerificationRequest {
  final String orderId;
  final String razorpayOrderId;
  final String razorpayPaymentId;
  final String razorpaySignature;

  PaymentVerificationRequest({
    required this.orderId,
    required this.razorpayOrderId,
    required this.razorpayPaymentId,
    required this.razorpaySignature,
  });

  Map<String, dynamic> toJson() {
    return {
      'orderId': orderId,
      'razorpayOrderId': razorpayOrderId,
      'razorpayPaymentId': razorpayPaymentId,
      'razorpaySignature': razorpaySignature,
    };
  }
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

  Map<String, dynamic> toJson() {
    return {
      'orderId': orderId,
      'razorpayOrderId': razorpayOrderId,
      'razorpayPaymentId': razorpayPaymentId,
      'error': error,
    };
  }
}

class PaymentVerificationResponse {
  final bool success;
  final String message;
  final VerificationData? data;

  PaymentVerificationResponse({
    required this.success,
    required this.message,
    this.data,
  });

  factory PaymentVerificationResponse.fromJson(Map<String, dynamic> json) {
    return PaymentVerificationResponse(
      success: json['status'] ?? false,
      message: json['message'] ?? '',
      data:
          json['data'] != null ? VerificationData.fromJson(json['data']) : null,
    );
  }
}

class VerificationData {
  final String orderId;
  final String paymentStatus;
  final String orderStatus;
  final String paymentId;
  final DateTime orderDate;
  final DateTime estimatedDeliveryTime;

  VerificationData({
    required this.orderId,
    required this.paymentStatus,
    required this.orderStatus,
    required this.paymentId,
    required this.orderDate,
    required this.estimatedDeliveryTime,
  });

  factory VerificationData.fromJson(Map<String, dynamic> json) {
    return VerificationData(
      orderId: json['orderId'] ?? '',
      paymentStatus: json['paymentStatus'] ?? '',
      orderStatus: json['orderStatus'] ?? '',
      paymentId: json['paymentId'] ?? '',
      orderDate:
          DateTime.parse(json['orderDate'] ?? DateTime.now().toIso8601String()),
      estimatedDeliveryTime: DateTime.parse(
          json['estimatedDeliveryTime'] ?? DateTime.now().toIso8601String()),
    );
  }
}

// Models for main order object (for user orders list)

class OrderFoodItem {
  final String title;
  final List<String> imageUrl;

  OrderFoodItem({
    required this.title,
    required this.imageUrl,
  });

  factory OrderFoodItem.fromJson(Map<String, dynamic> json) {
    return OrderFoodItem(
      title: json['title'] ?? json['foodName'] ?? '',
      imageUrl:
          json['imageUrl'] != null ? List<String>.from(json['imageUrl']) : [],
    );
  }
}

class ResponseOrderItem {
  final String foodId;
  final String foodName;
  final int quantity;
  final double price;
  final List<String> additives;
  final String instructions;
  final OrderFoodItem? food;

  ResponseOrderItem({
    required this.foodId,
    required this.foodName,
    required this.quantity,
    required this.price,
    required this.additives,
    required this.instructions,
    this.food,
  });

  factory ResponseOrderItem.fromJson(Map<String, dynamic> json) {
    return ResponseOrderItem(
      foodId: json['foodId'] ?? '',
      foodName: json['foodName'] ?? '',
      quantity: json['quantity'] ?? 0,
      price: (json['price'] ?? 0).toDouble(),
      additives: List<String>.from(json['additives'] ?? []),
      instructions: json['instructions'] ?? '',
      food: OrderFoodItem(
        title: json['foodName'] ?? '',
        imageUrl: [], // Empty for now, can be populated if backend includes it
      ),
    );
  }
}

class OrderResponse {
  final String id;
  final String userId;
  final List<ResponseOrderItem> orderItems;
  final double orderTotal;
  final double deliveryFee;
  final double grandTotal;
  final String deliveryAddress;
  final String restaurantAddress;
  final String restaurantId;
  final String paymentMethod;
  final String paymentStatus;
  final String orderStatus;
  final String restaurantName;
  final List<double> restaurantCoords;
  final List<double> recipientCoords;
  final String? razorpayOrderId;
  final String? razorpayPaymentId;
  final DateTime? paymentDate;
  final String? paymentError;
  final String? promoCode;
  final double discountAmount;
  final String notes;
  final DateTime orderDate;
  final DateTime estimatedDeliveryTime;
  final DateTime? actualDeliveryTime;
  final DateTime? cancelledAt;
  final String? cancellationReason;
  final double? rating;

  OrderResponse({
    required this.id,
    required this.userId,
    required this.orderItems,
    required this.orderTotal,
    required this.deliveryFee,
    required this.grandTotal,
    required this.deliveryAddress,
    required this.restaurantAddress,
    required this.restaurantId,
    required this.paymentMethod,
    required this.paymentStatus,
    required this.orderStatus,
    required this.restaurantName,
    required this.restaurantCoords,
    required this.recipientCoords,
    this.razorpayOrderId,
    this.razorpayPaymentId,
    this.paymentDate,
    this.paymentError,
    this.promoCode,
    required this.discountAmount,
    required this.notes,
    required this.orderDate,
    required this.estimatedDeliveryTime,
    this.actualDeliveryTime,
    this.cancelledAt,
    this.cancellationReason,
    this.rating,
  });

  factory OrderResponse.fromJson(Map<String, dynamic> json) {
    return OrderResponse(
      id: json['_id'] ?? '',
      userId: json['userId'] ?? '',
      orderItems: (json['orderItems'] as List?)
              ?.map((item) => ResponseOrderItem.fromJson(item))
              .toList() ??
          [],
      orderTotal: (json['orderTotal'] ?? 0).toDouble(),
      deliveryFee: (json['deliveryFee'] ?? 0).toDouble(),
      grandTotal: (json['grandTotal'] ?? 0).toDouble(),
      deliveryAddress: json['deliveryAddress'] ?? '',
      restaurantAddress: json['restaurantAddress'] ?? '',
      restaurantId: json['restaurantId'] ?? '',
      paymentMethod: json['paymentMethod'] ?? '',
      paymentStatus: json['paymentStatus'] ?? '',
      orderStatus: json['orderStatus'] ?? '',
      restaurantName: json['restaurantName'] ?? '',
      restaurantCoords: List<double>.from(json['restaurantCoords'] ?? []),
      recipientCoords: List<double>.from(json['recipientCoords'] ?? []),
      razorpayOrderId: json['razorpayOrderId'],
      razorpayPaymentId: json['razorpayPaymentId'],
      paymentDate: json['paymentDate'] != null
          ? DateTime.parse(json['paymentDate'])
          : null,
      paymentError: json['paymentError'],
      promoCode: json['promoCode'],
      discountAmount: (json['discountAmount'] ?? 0).toDouble(),
      notes: json['notes'] ?? '',
      orderDate:
          DateTime.parse(json['orderDate'] ?? DateTime.now().toIso8601String()),
      estimatedDeliveryTime: DateTime.parse(
          json['estimatedDeliveryTime'] ?? DateTime.now().toIso8601String()),
      actualDeliveryTime: json['actualDeliveryTime'] != null
          ? DateTime.parse(json['actualDeliveryTime'])
          : null,
      cancelledAt: json['cancelledAt'] != null
          ? DateTime.parse(json['cancelledAt'])
          : null,
      cancellationReason: json['cancellationReason'],
      rating: json['rating']?.toDouble(),
    );
  }
}
