import 'package:flutter/material.dart';

const String appBaseUrl = 'http://localhost:6013';
String googleApiKey = 'AIzaSyD_IyXT12elpZ2KvqojoAyQjAyeHiTpuVY';
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
