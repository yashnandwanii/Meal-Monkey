import 'dart:convert';

List<FoodItem> foodItemFromJson(String str) =>
    List<FoodItem>.from(json.decode(str).map((x) => FoodItem.fromJson(x)));

String foodItemToJson(List<FoodItem> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class FoodItem {
  final String id;
  final String title;
  final String time;
  final List<String> foodTags;
  final List<String> imageUrl;
  final String category;
  final List<String> foodType;
  final String code;
  final bool isAvailable;
  final String restaurent;
  final double price;
  final String description;
  final double rating;
  final int ratingCount;
  final List<Additive> additives;

  FoodItem({
    required this.id,
    required this.title,
    required this.time,
    required this.foodTags,
    required this.imageUrl,
    required this.category,
    required this.foodType,
    required this.code,
    required this.isAvailable,
    required this.restaurent,
    required this.price,
    required this.description,
    required this.rating,
    required this.ratingCount,
    required this.additives,
  });

  factory FoodItem.fromJson(Map<String, dynamic> json) => FoodItem(
        id: json["_id"],
        title: json["title"],
        time: json["time"],
        foodTags: List<String>.from(json["foodTags"]),
        imageUrl: List<String>.from(json["imageUrl"]),
        category: json["category"],
        foodType: List<String>.from(json["foodType"]),
        code: json["code"],
        isAvailable: json["isAvailable"],
        restaurent: json["restaurent"],
        price: (json["price"] as num).toDouble(),
        description: json["description"],
        rating: (json["rating"] as num).toDouble(),
        ratingCount: json["ratingCount"],
        additives: List<Additive>.from(
            json["additives"].map((x) => Additive.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "title": title,
        "time": time,
        "foodTags": foodTags,
        "imageUrl": imageUrl,
        "category": category,
        "foodType": foodType,
        "code": code,
        "isAvailable": isAvailable,
        "restaurent": restaurent,
        "price": price,
        "description": description,
        "rating": rating,
        "ratingCount": ratingCount,
        "additives": List<dynamic>.from(additives.map((x) => x.toJson())),
      };
}

class Additive {
  final int id;
  final String title;
  final String price;

  Additive({
    required this.id,
    required this.title,
    required this.price,
  });

  factory Additive.fromJson(Map<String, dynamic> json) => Additive(
        id: json["id"],
        title: json["title"],
        price: json["price"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "price": price,
      };
}