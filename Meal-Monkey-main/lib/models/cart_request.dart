import 'dart:convert';

CartRequest cartRequestFromJson(String str) =>
    CartRequest.fromJson(json.decode(str));

String cartRequestToJson(CartRequest data) => json.encode(data.toJson());

class CartRequest {
  final String productId;
  final List<String> additives;
  final int quantity;
  final double totalPrice;

  CartRequest({
    required this.productId,
    required this.additives,
    required this.quantity,
    required this.totalPrice,
  });

  factory CartRequest.fromJson(Map<String, dynamic> json) => CartRequest(
        productId: json["productId"] ?? "",
        additives: json["additives"] != null
            ? List<String>.from(
                json["additives"].map((x) => x?.toString() ?? ""))
            : [],
        quantity: json["quantity"] ?? 0,
        totalPrice: (json["totalPrice"] as num?)?.toDouble() ?? 0.0,
      );

  Map<String, dynamic> toJson() => {
        "productId": productId,
        "additives": List<dynamic>.from(additives.map((x) => x)),
        "quantity": quantity,
        "totalPrice": totalPrice,
      };
}
