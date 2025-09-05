import 'package:flutter/material.dart';
import 'package:food_delivery_app/common/color_extension.dart';
import 'package:food_delivery_app/view/auth/login/welcome_view.dart';
import 'package:food_delivery_app/view/main_tabview/main_tabview.dart';
import 'package:food_delivery_app/services/auth_service.dart';
import 'package:get_storage/get_storage.dart';
import 'package:page_transition/page_transition.dart';

class StartupView extends StatefulWidget {
  const StartupView({super.key});

  @override
  State<StartupView> createState() => _StartupViewState();
}

class _StartupViewState extends State<StartupView> {
  final box = GetStorage();
  @override
  void initState() {
    super.initState();
    goWelcomePage();
  }

  void goWelcomePage() async {
    await Future.delayed(const Duration(seconds: 2));

    try {
      print('=== STARTING APP AUTHENTICATION CHECK ===');

      // Perform comprehensive authentication check
      final authStatus = await AuthService.performAuthenticationCheck();

      switch (authStatus) {
        case AuthenticationStatus.authenticated:
          print('User is authenticated - navigating to main app');
          if (mounted) {
            context.pushReplacementTransition(
              type: PageTransitionType.rightToLeft,
              child: const MainTabview(),
            );
          }
          break;

        case AuthenticationStatus.tokenExpired:
          print('Token expired - clearing data and showing login');
          await AuthService.clearUserData();
          if (mounted) {
            welcomePage();
          }
          break;

        case AuthenticationStatus.notAuthenticated:
          print('User not authenticated - showing login');
          if (mounted) {
            welcomePage();
          }
          break;

        case AuthenticationStatus.error:
          print('Authentication error - showing login as fallback');
          if (mounted) {
            welcomePage();
          }
          break;
      }
    } catch (e) {
      print('Error during startup authentication: $e');
      // Fallback to login page on any error
      if (mounted) {
        welcomePage();
      }
    }
  }

  void welcomePage() {
    context.pushReplacementTransition(
      type: PageTransitionType.rightToLeft,
      child: const WelcomeView(),
    );
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Tcolor.white,
      body: Stack(
        alignment: Alignment.center,
        children: [
          Image.asset(
            'assets/iimg/splash_bg.png',
            width: media.width,
            height: media.height,
            fit: BoxFit.cover,
          ),
          Image.asset(
            'assets/iimg/app_logo (1).png',
            width: media.width * 0.7,
            height: media.height * 0.7,
            fit: BoxFit.contain,
          ),
        ],
      ),
    );
  }
}
