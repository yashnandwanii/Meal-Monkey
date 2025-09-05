import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:io';

// Platform-aware base URL for development
String get _developmentBaseUrl {
  if (Platform.isAndroid) {
    // Android emulator uses 10.0.2.2 to access host machine
    return 'http://10.0.2.2:6013';
  } else {
    // iOS simulator and other platforms can use localhost
    return 'http://localhost:6013';
  }
}

final String appBaseUrl = dotenv.env['APP_BASE_URL'] ?? _developmentBaseUrl;
final String googleApiKey =
    dotenv.env['GOOGLE_API_KEY'] ?? 'AIzaSyD_IyXT12elpZ2KvqojoAyQjAyeHiTpuVY';
const Color offWhite = Color(0xFFFAF9F6);

final List<String> verificationReasons = [
  'Real-time Updates: Get instant notifications for your order status.',
  'Order Tracking: Easily track your orders from placement to delivery.',
  'Personalized Experience: Receive tailored recommendations based on your preferences.',
  'Exclusive Offers: Access special deals and discounts available only through the app.',
  'Enhanced Security: Enjoy secure transactions and data protection.',
  'User-Friendly Interface: Navigate effortlessly with our intuitive design.',
];

final width =
    // ignore: deprecated_member_use
    MediaQueryData.fromView(WidgetsBinding.instance.window).size.width;

final height =
    // ignore: deprecated_member_use
    MediaQueryData.fromView(WidgetsBinding.instance.window).size.height;

List<String> get orderList => [
      "All Orders",
      "Pending",
      "In Progress",
      "Completed",
      "Cancelled",
    ];
