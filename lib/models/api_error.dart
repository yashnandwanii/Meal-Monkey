import 'dart:convert';

ApiError apiErrorFromJson(String str) => ApiError.fromJson(json.decode(str));

String apiErrorToJson(ApiError data) => json.encode(data.toJson());

class ApiError {
  bool status;
  String message;

  ApiError({
    required this.status,
    required this.message,
  });

  factory ApiError.fromJson(Map<String, dynamic> json) => ApiError(
        status: json["status"] ?? false,
        message: json["message"] as String,
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
      };
}
