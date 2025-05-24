import 'package:flutter/material.dart';
import 'package:food_delivery_app/common/color_extension.dart';
import 'package:food_delivery_app/common_widgets/round_button.dart';
import 'package:food_delivery_app/common_widgets/round_textfield.dart';

import 'package:food_delivery_app/view/login/login_view.dart';
import 'package:page_transition/page_transition.dart';

class SignupView extends StatefulWidget {
  const SignupView({super.key});

  @override
  State<SignupView> createState() => _SignupViewState();
}

class _SignupViewState extends State<SignupView> {
  String email = '';
  String password = '';
  String name = '';

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // * register
  void submit() {
    // if (_formKey.currentState!.validate()) {
    //   // * Register user
    //   _authController.register(
    //     nameController.text,
    //     emailController.text,
    //     passwordController.text,
    //   );
    //   Get.offAllNamed('/onboarding');
    // }
    //showSnackbar("Good,", "You have successfully registered");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Tcolor.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 70),
                Text(
                  'Sign Up',
                  style: TextStyle(
                    fontSize: 30,
                    color: Tcolor.primaryText,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                Text(
                  'Add your details to Sign Up',
                  style: TextStyle(
                    fontSize: 14,
                    color: Tcolor.primaryText,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 45),
                RoundTextfield(
                  hintText: 'Name',
                  controller: nameController,
                  keyboardType: TextInputType.name,
                ),
                const SizedBox(height: 25),
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
                const SizedBox(height: 45),
                RoundButton(
                  onPressed: () {
                    submit();
                  },
                  text: 'Sign Up',
                ),
                const SizedBox(height: 25),
                TextButton(
                  onPressed: () {
                    context.pushReplacementTransition(
                      type: PageTransitionType.rightToLeft,
                      child: const LoginView(),
                    );
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Already have an Account?  ',
                        style: TextStyle(
                          color: Tcolor.secondaryText,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        'Log In',
                        style: TextStyle(
                          color: Tcolor.primary,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      )
                    ],
                  ),
                ),
                const SizedBox(
                  height: 25,
                ),
                RoundButton(
                  type: RoundButtonType.textPrimary,
                  onPressed: () {
                    if (emailController.text.isNotEmpty &&
                        passwordController.text.isNotEmpty) {
                      email = emailController.text;
                      password = passwordController.text;
                      context.pushNamedTransition(
                        routeName: '/otp',
                        type: PageTransitionType.fade,
                      );
                    } else {
                      //showSnackbar("Error", "Please fill all fields");
                    }
                  },
                  text: 'Sign Up with Phone No',
                ),
                const SizedBox(
                  height: 25,
                ),
                RoundButton(
                  onPressed: () {
                    if (nameController.text.isNotEmpty &&
                        emailController.text.isNotEmpty &&
                        passwordController.text.isNotEmpty) {
                      email = emailController.text;
                      password = passwordController.text;
                      name = nameController.text;
                      submit();
                    } else {
                      //showSnackbar("Error", "Please fill all fields");
                    }
                  },
                  text: 'Sign Up with Google',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
