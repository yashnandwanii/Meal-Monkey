import 'dart:convert';

ApiError apiErrorFromJson(String str) => ApiError.fromJson(json.decode(str));

String apiErrorToJson(ApiError data) => json.encode(data.toJson());

class ApiError {
    bool status;
    String error;

    ApiError({
        required this.status,
        required this.error,
    });

    factory ApiError.fromJson(Map<String, dynamic> json) => ApiError(
        status: json["status"],
        error: json["error"],
    );

    Map<String, dynamic> toJson() => {
        "status": status,
        "error": error,
    };
}
