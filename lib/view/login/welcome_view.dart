import 'package:flutter/material.dart';
import 'package:food_delivery_app/common/color_extension.dart';
import 'package:food_delivery_app/common_widgets/round_button.dart';
import 'package:food_delivery_app/view/login/login_view.dart';
import 'package:food_delivery_app/view/login/signup_view.dart';
import 'package:page_transition/page_transition.dart';

class WelcomeView extends StatefulWidget {
  const WelcomeView({super.key});

  @override
  State<WelcomeView> createState() => _WelcomeViewState();
}

class _WelcomeViewState extends State<WelcomeView> {
  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Tcolor.white,
      body: Column(
        children: [
          Stack(
            alignment: Alignment.bottomCenter,
            children: [
              Image.asset(
                'assets/iimg/welcome_top_shape1.png',
                width: media.width,
              ),
              Image.asset(
                'assets/iimg/app_logo (1).png',
                width: media.width * 0.55,
                height: media.height * 0.25,
                fit: BoxFit.contain,
              )
            ],
          ),
          SizedBox(height: media.height * 0.05),
          Text(
            'Discover the best foods from over 1000\nrestaurants and fast delivery to your \n doorstep',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Tcolor.secondaryText,
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: media.height * 0.05),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: RoundButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const LoginView(),
                  ),
                );
              },
              text: 'Log In',
            ),
          ),
          SizedBox(height: media.height * 0.02),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: RoundButton(
              onPressed: () {
                Navigator.push(
                  context,
                  PageTransition(
                    type: PageTransitionType.fade,
                    child: const SignupView(),
                  ),
                );
              },
              type: RoundButtonType.textPrimary,
              text: 'Create an Account',
            ),
          ),
        ],
      ),
    );
  }
}
