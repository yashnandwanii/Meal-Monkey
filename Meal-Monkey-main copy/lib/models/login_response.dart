// To parse this JSON data, do
//
//     final loginResponse = loginResponseFromJson(jsonString);

import 'dart:convert';

LoginResponse loginResponseFromJson(String str) =>
    LoginResponse.fromJson(json.decode(str));

// Safe version that handles null input
LoginResponse? loginResponseFromJsonSafe(String? str) {
  if (str == null || str.isEmpty) {
    return null;
  }
  try {
    return LoginResponse.fromJson(json.decode(str));
  } catch (e) {
    return null;
  }
}

String loginResponseToJson(LoginResponse data) => json.encode(data.toJson());

class LoginResponse {
  String id;
  String username;
  String email;
  String fcm;
  bool verification;
  String phone;
  bool phoneVerification;
  String userType;
  String profile;
  String token;

  LoginResponse({
    required this.id,
    required this.username,
    required this.email,
    required this.fcm,
    required this.verification,
    required this.phone,
    required this.phoneVerification,
    required this.userType,
    required this.profile,
    required this.token,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) => LoginResponse(
        id: json["_id"],
        username: json["username"],
        email: json["email"],
        fcm: json["fcm"],
        verification: json["verification"],
        phone: json["phone"],
        phoneVerification: json["phoneVerification"],
        userType: json["userType"],
        profile: json["profile"],
        token: json["token"],
      );

  Map<String, dynamic> toJson() => {
        "_id": id,
        "username": username,
        "email": email,
        "fcm": fcm,
        "verification": verification,
        "phone": phone,
        "phoneVerification": phoneVerification,
        "userType": userType,
        "profile": profile,
        "token": token,
      };
}
