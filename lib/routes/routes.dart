import 'package:flutter/material.dart';
import 'package:food_delivery_app/view/home/homeview.dart';
import 'package:food_delivery_app/view/auth/login/login_view.dart';
import 'package:food_delivery_app/view/auth/signup/signup_view.dart';
import 'package:food_delivery_app/view/main_tabview/main_tabview.dart';
import 'package:food_delivery_app/view/on_boarding/on_boarding_view.dart';
import 'package:food_delivery_app/view/on_boarding/startup_view.dart';
import 'package:food_delivery_app/view/orders/order_success_page.dart';
import 'package:food_delivery_app/view/orders/order_tracking_page.dart';
import 'package:food_delivery_app/view/orders/cart_order_page.dart';
import 'package:food_delivery_app/view/orders/user_orders.dart';
import 'package:food_delivery_app/view/profile/profile_page.dart';

class RouteNames {
  static const String startup = '/';
  static const String home = '/home';
  static const String login = '/login';
  static const String signup = '/signup';
  static const String main_tabview = '/main_tabview';
  static const String profile = '/profile';
  static const String on_boarding = '/on_boarding';
  static const String orderSuccess = '/order-success';
  static const String orderTracking = '/order-tracking';
  static const String cartCheckout = '/cart-checkout';
  static const String userOrders = '/user-orders';
}

class AppRoutes {
  static Map<String, WidgetBuilder> routes = {
    RouteNames.startup: (context) => const StartupView(),
    RouteNames.on_boarding: (context) => const OnBoardingView(),
    RouteNames.home: (context) => const Homeview(),
    RouteNames.login: (context) => const LoginView(),
    RouteNames.signup: (context) => const SignupView(),
    RouteNames.main_tabview: (context) => const MainTabview(),
    RouteNames.orderSuccess: (context) => const OrderSuccessPage(),
    RouteNames.orderTracking: (context) => const OrderTrackingPage(),
    RouteNames.cartCheckout: (context) {
      final arguments = ModalRoute.of(context)?.settings.arguments;
      if (arguments is List) {
        // For now, we'll pass an empty list and handle data differently
        // In a real app, you'd want proper serialization
        return const CartOrderPage(cartItems: []);
      }
      return const CartOrderPage(cartItems: []);
    },
    RouteNames.userOrders: (context) => const UserOrders(),
    RouteNames.profile: (context) => const ProfilePage(),
  };
}
