import 'package:flutter/material.dart';
import 'package:food_delivery_app/common/color_extension.dart';
import 'package:food_delivery_app/common_widgets/round_button.dart';
import 'package:food_delivery_app/common_widgets/round_icon_button.dart';
import 'package:food_delivery_app/common_widgets/round_textfield.dart';
import 'package:food_delivery_app/services/auth.dart';
import 'package:food_delivery_app/view/login/reset_password.dart';
import 'package:food_delivery_app/view/login/signup_view.dart';
import 'package:food_delivery_app/view/on_boarding/on_boarding_view.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  String email = '';
  String password = '';

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  // userLogin() async {
  //   try {
  //     await FirebaseAuth.instance
  //         .signInWithEmailAndPassword(
  //             email: emailController.text, password: passwordController.text)
  //         .then((value) {
  //       Navigator.pushReplacement(context,
  //           MaterialPageRoute(builder: (context) => const OnBoardingView()));
  //       print("tapped");
  //     });
  //     ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
  //         backgroundColor: Colors.green,
  //         content: Text(
  //           'Login Success',
  //           style: TextStyle(
  //             color: Colors.white,
  //             fontWeight: FontWeight.w800,
  //             fontSize: 14,
  //           ),
  //         )));
  //   } on FirebaseAuthException catch (e) {
  //     if (e.code == 'user-not-found') {
  //       ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
  //           backgroundColor: Colors.red,
  //           content: Text(
  //             'No user found for that email.',
  //             style: TextStyle(
  //               color: Colors.white,
  //               fontWeight: FontWeight.w800,
  //               fontSize: 14,
  //             ),
  //           )));
  //     } else if (e.code == 'wrong-password') {
  //       ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
  //           backgroundColor: Colors.red,
  //           content: Text(
  //             'Wrong password provided for that user.',
  //             style: TextStyle(
  //               color: Colors.white,
  //               fontWeight: FontWeight.w800,
  //               fontSize: 14,
  //             ),
  //           )));
  //     }
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    // var media = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Tcolor.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 70),
              Text(
                'Log In',
                style: TextStyle(
                  fontSize: 30,
                  color: Tcolor.primaryText,
                  fontWeight: FontWeight.w800,
                ),
              ),
              Text(
                'Add your details to login',
                style: TextStyle(
                  fontSize: 14,
                  color: Tcolor.primaryText,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 45),
              RoundTextfield(
                hintText: 'Email',
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 25),
              RoundTextfield(
                hintText: 'Password',
                controller: passwordController,
                obscureText: true,
              ),
              const SizedBox(height: 25),
              RoundButton(
                onPressed: () {
                  if (emailController.text.isEmpty ||
                      passwordController.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        backgroundColor: Colors.red,
                        content: Text(
                          'Please fill all the fields',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w800,
                            fontSize: 14,
                          ),
                        )));
                  } else {
                    // userLogin();
                  }
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const OnBoardingView()),
                  );
                },
                text: 'Log In',
              ),
              const SizedBox(height: 15),
              TextButton(
                onPressed: () {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const ResetPassword()));
                },
                child: Text(
                  'Forgot Password?',
                  style: TextStyle(
                    color: Tcolor.secondaryText,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(height: 25),
              TextButton(
                onPressed: () {},
                child: Text(
                  'Or Login With',
                  style: TextStyle(
                    color: Tcolor.secondaryText,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(height: 15),
              RoundIconButton(
                onPressed: () {},
                title: 'Login with Facebook',
                icon: 'assets/iimg/facebook_logo.png',
                color: const Color(0xff367FC0),
              ),
              const SizedBox(height: 25),
              RoundIconButton(
                onPressed: () {
                  // AuthMethods().signInWithGoogle(context);
                },
                title: 'Login with Google',
                icon: 'assets/iimg/google_log.png',
                color: const Color(0xddE74F50),
              ),
              const SizedBox(height: 80),
              TextButton(
                onPressed: () {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const SignupView()));
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Don\'t have an account? ',
                      style: TextStyle(
                        color: Tcolor.secondaryText,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      'Sign Up',
                      style: TextStyle(
                        color: Tcolor.primary,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
