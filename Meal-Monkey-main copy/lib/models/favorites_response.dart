import 'dart:convert';
import 'package:food_delivery_app/models/foods.dart';

List<FavoriteResponse> favoriteResponseFromJson(String str) =>
    List<FavoriteResponse>.from(
        json.decode(str).map((x) => FavoriteResponse.fromJson(x)));

String favoriteResponseToJson(List<FavoriteResponse> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class FavoriteResponse {
  final String id;
  final String userId;
  final FoodItem food;
  final DateTime createdAt;

  FavoriteResponse({
    required this.id,
    required this.userId,
    required this.food,
    required this.createdAt,
  });

  factory FavoriteResponse.fromJson(Map<String, dynamic> json) =>
      FavoriteResponse(
        id: json["_id"],
        userId: json["userId"],
        food: FoodItem.fromJson(json["food"]),
        createdAt: DateTime.parse(json["createdAt"]),
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "userId": userId,
        "food": food.toJson(),
        "createdAt": createdAt.toIso8601String(),
      };
}
