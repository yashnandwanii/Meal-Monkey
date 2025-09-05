import 'dart:convert';

List<CartResponse> cartResponseFromJson(String str) => List<CartResponse>.from(
    json.decode(str).map((x) => CartResponse.fromJson(x)));

String cartResponseToJson(List<CartResponse> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class CartResponse {
  final String id;
  final ProductId productId;
  final List<String> additives;
  final double totalPrice;
  final int quantity;

  CartResponse({
    required this.id,
    required this.productId,
    required this.additives,
    required this.totalPrice,
    required this.quantity,
  });

  factory CartResponse.fromJson(Map<String, dynamic> json) => CartResponse(
        id: json["_id"] ?? "",
        productId: ProductId.fromJson(json["productId"] ?? {}),
        additives: json["additives"] != null
            ? List<String>.from(
                json["additives"].map((x) => x?.toString() ?? ""))
            : [],
        totalPrice: (json["totalPrice"] as num?)?.toDouble() ?? 0.0,
        quantity: json["quantity"] ?? 0,
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "productId": productId.toJson(),
        "additives": List<dynamic>.from(additives.map((x) => x)),
        "totalPrice": totalPrice,
        "quantity": quantity,
      };
}

class ProductId {
  final String id;
  final String title;
  final List<String> imageUrl;
  final Restaurent restaurent;
  final double rating;
  final int ratingCount;

  ProductId({
    required this.id,
    required this.title,
    required this.imageUrl,
    required this.restaurent,
    required this.rating,
    required this.ratingCount,
  });

  factory ProductId.fromJson(Map<String, dynamic> json) => ProductId(
        id: json["_id"] ?? "",
        title: json["title"] ?? "",
        imageUrl: json["imageUrl"] != null
            ? List<String>.from(
                json["imageUrl"].map((x) => x?.toString() ?? ""))
            : [],
        restaurent: Restaurent.fromJson(json["restaurent"] ?? {}),
        rating: (json["rating"] as num?)?.toDouble() ?? 0.0,
        ratingCount: json["ratingCount"] ?? 0,
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "title": title,
        "imageUrl": List<dynamic>.from(imageUrl.map((x) => x)),
        "restaurent": restaurent.toJson(),
        "rating": rating,
        "ratingCount": ratingCount,
      };
}

class Restaurent {
  final Coords coords;
  final String id;
  final String time;

  Restaurent({
    required this.coords,
    required this.id,
    required this.time,
  });

  factory Restaurent.fromJson(Map<String, dynamic> json) => Restaurent(
        coords: Coords.fromJson(json["coords"] ?? {}),
        id: json["_id"] ?? "",
        time: json["time"] ?? "",
      );

  Map<String, dynamic> toJson() => {
        "coords": coords.toJson(),
        "_id": id,
        "time": time,
      };
}

class Coords {
  final String id;
  final double latitude;
  final double longitude;
  final String address;
  final String title;
  final double latitudeDelta;
  final double longitudeDelta;

  Coords({
    required this.id,
    required this.latitude,
    required this.longitude,
    required this.address,
    required this.title,
    required this.latitudeDelta,
    required this.longitudeDelta,
  });

  factory Coords.fromJson(Map<String, dynamic> json) => Coords(
        id: json["id"] ?? "",
        latitude: (json["latitude"] as num?)?.toDouble() ?? 0.0,
        longitude: (json["longitude"] as num?)?.toDouble() ?? 0.0,
        address: json["address"] ?? "",
        title: json["title"] ?? "",
        latitudeDelta: (json["latitudeDelta"] as num?)?.toDouble() ?? 0.0,
        longitudeDelta: (json["longitudeDelta"] as num?)?.toDouble() ?? 0.0,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "latitude": latitude,
        "longitude": longitude,
        "address": address,
        "title": title,
        "latitudeDelta": latitudeDelta,
        "longitudeDelta": longitudeDelta,
      };
}
