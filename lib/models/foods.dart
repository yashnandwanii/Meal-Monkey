import 'dart:convert';

FoodsModel foodsModelFromJson(String str) => FoodsModel.fromJson(json.decode(str));

String foodsModelToJson(FoodsModel data) => json.encode(data.toJson());

class FoodsModel {
    bool status;
    List<RandomFoodList> randomFoodList;

    FoodsModel({
        required this.status,
        required this.randomFoodList,
    });

    factory FoodsModel.fromJson(Map<String, dynamic> json) => FoodsModel(
        status: json["status"],
        randomFoodList: List<RandomFoodList>.from(json["randomFoodList"].map((x) => RandomFoodList.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "randomFoodList": List<dynamic>.from(randomFoodList.map((x) => x.toJson())),
    };
}

class RandomFoodList {
    String id;
    String title;
    String time;
    List<String> foodTags;
    List<String> imageUrl;
    String category;
    List<String> foodType;
    String code;
    bool isAvailable;
    String restaurent;
    double price;
    String description;
    double rating;
    int ratingCount;
    List<Additive> additives;

    RandomFoodList({
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

    factory RandomFoodList.fromJson(Map<String, dynamic> json) => RandomFoodList(
        id: json["_id"],
        title: json["title"],
        time: json["time"],
        foodTags: List<String>.from(json["foodTags"].map((x) => x)),
        imageUrl: List<String>.from(json["imageUrl"].map((x) => x)),
        category: json["category"],
        foodType: List<String>.from(json["foodType"].map((x) => x)),
        code: json["code"],
        isAvailable: json["isAvailable"],
        restaurent: json["restaurent"],
        price: json["price"]?.toDouble(),
        description: json["description"],
        rating: json["rating"]?.toDouble(),
        ratingCount: json["ratingCount"],
        additives: List<Additive>.from(json["additives"].map((x) => Additive.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "_id": id,
        "title": title,
        "time": time,
        "foodTags": List<dynamic>.from(foodTags.map((x) => x)),
        "imageUrl": List<dynamic>.from(imageUrl.map((x) => x)),
        "category": category,
        "foodType": List<dynamic>.from(foodType.map((x) => x)),
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
    int id;
    String title;
    String price;

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
