// ignore_for_file: constant_identifier_names

import 'package:flutter/material.dart';
import 'package:food_delivery_app/view/home/homeview.dart';
import 'package:food_delivery_app/view/auth/login/login_view.dart';
import 'package:food_delivery_app/view/auth/signup/signup_view.dart';
import 'package:food_delivery_app/view/main_tabview/main_tabview.dart';
import 'package:food_delivery_app/view/on_boarding/on_boarding_view.dart';
import 'package:food_delivery_app/view/on_boarding/startup_view.dart';

class RouteNames {
  static const String startup = '/';
  static const String home = '/home';
  static const String login = '/login';
  static const String signup = '/signup';
  static const String main_tabview = '/main_tabview';
  static const String profile = '/profile';
  static const String on_boarding = '/on_boarding';
}

class AppRoutes {
  static Map<String, WidgetBuilder> routes = {
    RouteNames.startup: (context) => const StartupView(),
    RouteNames.on_boarding: (context) => const OnBoardingView(),
    RouteNames.home: (context) => const Homeview(),
    RouteNames.login: (context) => const LoginView(),
    RouteNames.signup: (context) => const SignupView(),
    RouteNames.main_tabview: (context) => const MainTabview(),
  };
}
