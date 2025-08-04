import 'dart:convert';

List<CouponResponse> couponResponseFromJson(String str) =>
    List<CouponResponse>.from(
        json.decode(str).map((x) => CouponResponse.fromJson(x)));

String couponResponseToJson(List<CouponResponse> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class CouponResponse {
  final String id;
  final String code;
  final String title;
  final String description;
  final double discountPercentage;
  final double maxDiscount;
  final double minOrderAmount;
  final DateTime validFrom;
  final DateTime validUntil;
  final bool isActive;
  final int usageLimit;
  final int usedCount;
  final List<String> applicableCategories;
  final DateTime createdAt;

  CouponResponse({
    required this.id,
    required this.code,
    required this.title,
    required this.description,
    required this.discountPercentage,
    required this.maxDiscount,
    required this.minOrderAmount,
    required this.validFrom,
    required this.validUntil,
    required this.isActive,
    required this.usageLimit,
    required this.usedCount,
    required this.applicableCategories,
    required this.createdAt,
  });

  factory CouponResponse.fromJson(Map<String, dynamic> json) => CouponResponse(
        id: json["_id"],
        code: json["code"],
        title: json["title"],
        description: json["description"],
        discountPercentage: json["discountPercentage"]?.toDouble(),
        maxDiscount: json["maxDiscount"]?.toDouble(),
        minOrderAmount: json["minOrderAmount"]?.toDouble(),
        validFrom: DateTime.parse(json["validFrom"]),
        validUntil: DateTime.parse(json["validUntil"]),
        isActive: json["isActive"],
        usageLimit: json["usageLimit"],
        usedCount: json["usedCount"],
        applicableCategories:
            List<String>.from(json["applicableCategories"].map((x) => x)),
        createdAt: DateTime.parse(json["createdAt"]),
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "code": code,
        "title": title,
        "description": description,
        "discountPercentage": discountPercentage,
        "maxDiscount": maxDiscount,
        "minOrderAmount": minOrderAmount,
        "validFrom": validFrom.toIso8601String(),
        "validUntil": validUntil.toIso8601String(),
        "isActive": isActive,
        "usageLimit": usageLimit,
        "usedCount": usedCount,
        "applicableCategories":
            List<dynamic>.from(applicableCategories.map((x) => x)),
        "createdAt": createdAt.toIso8601String(),
      };

  bool get isValid =>
      DateTime.now().isAfter(validFrom) &&
      DateTime.now().isBefore(validUntil) &&
      isActive;
  bool get isExpired => DateTime.now().isAfter(validUntil);
  bool get isAvailable => usedCount < usageLimit;
}
