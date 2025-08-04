import 'package:flutter/material.dart';
import 'package:food_delivery_app/common/color_extension.dart';
import 'package:food_delivery_app/view/auth/login/welcome_view.dart';
import 'package:food_delivery_app/view/main_tabview/main_tabview.dart';
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
    if (box.hasData('token')) {
      print(box.getKeys().toString());
      print(box.read('tempUserData'));
      context.pushReplacementTransition(
        type: PageTransitionType.rightToLeft,
        child: const MainTabview(),
      );
      return;
    }
    welcomePage();
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
