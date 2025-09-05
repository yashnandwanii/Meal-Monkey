import 'dart:convert';

List<ReviewResponse> reviewResponseFromJson(String str) =>
    List<ReviewResponse>.from(
        json.decode(str).map((x) => ReviewResponse.fromJson(x)));

String reviewResponseToJson(List<ReviewResponse> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ReviewResponse {
  final String id;
  final String userId;
  final String foodId;
  final String foodName;
  final String restaurantId;
  final String restaurantName;
  final double rating;
  final String comment;
  final List<String> images;
  final DateTime createdAt;
  final DateTime updatedAt;

  ReviewResponse({
    required this.id,
    required this.userId,
    required this.foodId,
    required this.foodName,
    required this.restaurantId,
    required this.restaurantName,
    required this.rating,
    required this.comment,
    required this.images,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ReviewResponse.fromJson(Map<String, dynamic> json) => ReviewResponse(
        id: json["_id"],
        userId: json["userId"],
        foodId: json["foodId"],
        foodName: json["foodName"],
        restaurantId: json["restaurantId"],
        restaurantName: json["restaurantName"],
        rating: json["rating"]?.toDouble(),
        comment: json["comment"],
        images: List<String>.from(json["images"].map((x) => x)),
        createdAt: DateTime.parse(json["createdAt"]),
        updatedAt: DateTime.parse(json["updatedAt"]),
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "userId": userId,
        "foodId": foodId,
        "foodName": foodName,
        "restaurantId": restaurantId,
        "restaurantName": restaurantName,
        "rating": rating,
        "comment": comment,
        "images": List<dynamic>.from(images.map((x) => x)),
        "createdAt": createdAt.toIso8601String(),
        "updatedAt": updatedAt.toIso8601String(),
      };
}
