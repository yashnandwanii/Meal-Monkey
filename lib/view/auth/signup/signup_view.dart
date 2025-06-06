import 'package:flutter/material.dart';
import 'package:food_delivery_app/common/color_extension.dart';
import 'package:food_delivery_app/common_widgets/input_field.dart';
import 'package:food_delivery_app/common_widgets/round_button.dart';
import 'package:food_delivery_app/controllers/registration_controller.dart';
import 'package:food_delivery_app/models/registration_model.dart';

import 'package:food_delivery_app/view/auth/login/login_view.dart';
import 'package:food_delivery_app/view/auth/password_field.dart';
import 'package:food_delivery_app/view/on_boarding/on_boarding_view.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:page_transition/page_transition.dart';

class SignupView extends StatefulWidget {
  const SignupView({super.key});

  @override
  State<SignupView> createState() => _SignupViewState();
}

class _SignupViewState extends State<SignupView> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(RegistrationController());
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
                Container(
                  width: 250,
                  height: 250,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                  ),
                  child: Lottie.asset(
                    'assets/login.json',
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
                InputField(
                  controller: nameController,
                  hintText: 'Name',
                  suffixicon: false,
                  leadingIcon: Icons.person_outline,
                ),
                const SizedBox(height: 25),
                InputField(
                  controller: emailController,
                  hintText: 'Email',
                  suffixicon: false,
                  leadingIcon: Icons.email_outlined,
                ),
                const SizedBox(height: 25),
                PasswordField(
                  controller: passwordController,
                  isObscure: true.obs,
                ),
                const SizedBox(height: 45),
                RoundButton(
                  onPressed: () {
                    if (emailController.text.isEmpty ||
                        passwordController.text.isEmpty ||
                        nameController.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          backgroundColor: Colors.red,
                          content: Text(
                            'Please fill all the fields',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w800,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      );
                    } else if (passwordController.text.length < 8) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          backgroundColor: Colors.red,
                          content: Text(
                            'Password must be at least 8 characters',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w800,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      );
                    } else {
                      RegistrationModel model = RegistrationModel(
                        username: nameController.text.trim(),
                        email: emailController.text.trim(),
                        password: passwordController.text.trim(),
                      );
                      String data = registrationModelToJson(model);
                      controller.registrationFunction(data);

                      Get.offAll(
                        () => const OnBoardingView(),
                        transition: Transition.rightToLeft,
                        duration: const Duration(milliseconds: 500),
                      );
                    }
                  },
                  text: controller.isLoading ? 'Loading...' : 'S I G N  U P',
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
                  onPressed: () {},
                  text: 'Sign Up with Phone No',
                ),
                const SizedBox(
                  height: 25,
                ),
                RoundButton(
                  onPressed: () {},
                  nColor: const Color(0xddE74F50),
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
