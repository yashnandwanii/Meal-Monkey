import 'dart:convert';

PaymentRequest paymentRequestFromJson(String str) =>
    PaymentRequest.fromJson(json.decode(str));

String paymentRequestToJson(PaymentRequest data) => json.encode(data.toJson());

class PaymentRequest {
  final String userId;
  final String orderId;
  final double amount;
  final String currency;
  final String paymentMethod;
  final String razorpayOrderId;
  final String razorpayPaymentId;
  final String paymentStatus;
  final String orderStatus;
  final String restaurantId;
  final String restaurantName;
  final List<PaymentOrderItem> orderItems;
  final double orderTotal;
  final double deliveryFee;
  final double grandTotal;
  final String deliveryAddressId;
  final String deliveryAddress;
  final List<double> restaurantCoords;
  final List<double> recipientCoords;
  final String notes;

  PaymentRequest({
    required this.userId,
    required this.orderId,
    required this.amount,
    required this.currency,
    required this.paymentMethod,
    required this.razorpayOrderId,
    required this.razorpayPaymentId,
    required this.paymentStatus,
    required this.orderStatus,
    required this.restaurantId,
    required this.restaurantName,
    required this.orderItems,
    required this.orderTotal,
    required this.deliveryFee,
    required this.grandTotal,
    required this.deliveryAddressId,
    required this.deliveryAddress,
    required this.restaurantCoords,
    required this.recipientCoords,
    required this.notes,
  });

  factory PaymentRequest.fromJson(Map<String, dynamic> json) => PaymentRequest(
        userId: json["userId"],
        orderId: json["orderId"],
        amount: json["amount"]?.toDouble(),
        currency: json["currency"],
        paymentMethod: json["paymentMethod"],
        razorpayOrderId: json["razorpayOrderId"],
        razorpayPaymentId: json["razorpayPaymentId"],
        paymentStatus: json["paymentStatus"],
        orderStatus: json["orderStatus"],
        restaurantId: json["restaurantId"],
        restaurantName: json["restaurantName"],
        orderItems: List<PaymentOrderItem>.from(
            json["orderItems"].map((x) => PaymentOrderItem.fromJson(x))),
        orderTotal: json["orderTotal"]?.toDouble(),
        deliveryFee: json["deliveryFee"]?.toDouble(),
        grandTotal: json["grandTotal"]?.toDouble(),
        deliveryAddressId: json["deliveryAddressId"],
        deliveryAddress: json["deliveryAddress"],
        restaurantCoords: List<double>.from(
            json["restaurantCoords"].map((x) => x?.toDouble())),
        recipientCoords: List<double>.from(
            json["recipientCoords"].map((x) => x?.toDouble())),
        notes: json["notes"],
      );

  Map<String, dynamic> toJson() => {
        "userId": userId,
        "orderId": orderId,
        "amount": amount,
        "currency": currency,
        "paymentMethod": paymentMethod,
        "razorpayOrderId": razorpayOrderId,
        "razorpayPaymentId": razorpayPaymentId,
        "paymentStatus": paymentStatus,
        "orderStatus": orderStatus,
        "restaurantId": restaurantId,
        "restaurantName": restaurantName,
        "orderItems": List<dynamic>.from(orderItems.map((x) => x.toJson())),
        "orderTotal": orderTotal,
        "deliveryFee": deliveryFee,
        "grandTotal": grandTotal,
        "deliveryAddressId": deliveryAddressId,
        "deliveryAddress": deliveryAddress,
        "restaurantCoords": List<dynamic>.from(restaurantCoords.map((x) => x)),
        "recipientCoords": List<dynamic>.from(recipientCoords.map((x) => x)),
        "notes": notes,
      };
}

class PaymentOrderItem {
  final String foodId;
  final String foodName;
  final int quantity;
  final double price;
  final List<String> additives;
  final String instructions;

  PaymentOrderItem({
    required this.foodId,
    required this.foodName,
    required this.quantity,
    required this.price,
    required this.additives,
    required this.instructions,
  });

  factory PaymentOrderItem.fromJson(Map<String, dynamic> json) =>
      PaymentOrderItem(
        foodId: json["foodId"],
        foodName: json["foodName"],
        quantity: json["quantity"],
        price: json["price"]?.toDouble(),
        additives: List<String>.from(json["additives"].map((x) => x)),
        instructions: json["instructions"],
      );

  Map<String, dynamic> toJson() => {
        "foodId": foodId,
        "foodName": foodName,
        "quantity": quantity,
        "price": price,
        "additives": List<dynamic>.from(additives.map((x) => x)),
        "instructions": instructions,
      };
}
