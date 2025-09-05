import 'dart:convert';

OrderRequest orderRequestFromJson(String str) =>
    OrderRequest.fromJson(json.decode(str));

String orderRequestToJson(OrderRequest data) => json.encode(data.toJson());

class OrderRequest {
  final String userId;
  final String restaurantId;
  final String restaurantName;
  final List<OrderItem> orderItems;
  final double orderTotal;
  final double deliveryFee;
  final double grandTotal;
  final String deliveryAddressId;
  final String deliveryAddress;
  final List<double> restaurantCoords;
  final List<double> recipientCoords;
  final String notes;
  final String currency;

  OrderRequest({
    required this.userId,
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
    this.notes = '',
    this.currency = 'INR',
  });

  factory OrderRequest.fromJson(Map<String, dynamic> json) => OrderRequest(
        userId: json["userId"],
        restaurantId: json["restaurantId"],
        restaurantName: json["restaurantName"],
        orderItems: List<OrderItem>.from(
            json["orderItems"].map((x) => OrderItem.fromJson(x))),
        orderTotal: json["orderTotal"]?.toDouble(),
        deliveryFee: json["deliveryFee"]?.toDouble(),
        grandTotal: json["grandTotal"]?.toDouble(),
        deliveryAddressId: json["deliveryAddressId"],
        deliveryAddress: json["deliveryAddress"],
        restaurantCoords: List<double>.from(
            json["restaurantCoords"].map((x) => x?.toDouble())),
        recipientCoords: List<double>.from(
            json["recipientCoords"].map((x) => x?.toDouble())),
        notes: json["notes"] ?? '',
        currency: json["currency"] ?? 'INR',
      );

  Map<String, dynamic> toJson() => {
        "userId": userId,
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
        "currency": currency,
      };
}

class OrderItem {
  final String foodId;
  final String foodName;
  final int quantity;
  final double price;
  final List<String> additives;
  final String instructions;

  OrderItem({
    required this.foodId,
    required this.foodName,
    required this.quantity,
    required this.price,
    required this.additives,
    this.instructions = '',
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) => OrderItem(
        foodId: json["foodId"],
        foodName: json["foodName"],
        quantity: json["quantity"],
        price: json["price"]?.toDouble(),
        additives: List<String>.from(json["additives"].map((x) => x)),
        instructions: json["instructions"] ?? '',
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
