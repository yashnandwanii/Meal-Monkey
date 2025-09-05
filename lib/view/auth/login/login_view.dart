import 'package:flutter/material.dart';
import 'package:food_delivery_app/common/color_extension.dart';
import 'package:food_delivery_app/common_widgets/input_field.dart';
import 'package:food_delivery_app/common_widgets/round_button.dart';
import 'package:food_delivery_app/common_widgets/round_icon_button.dart';
import 'package:food_delivery_app/controllers/login_controller.dart';
import 'package:food_delivery_app/models/login_model.dart';
import 'package:food_delivery_app/view/auth/login/reset_password.dart';
import 'package:food_delivery_app/view/auth/password_field.dart';
import 'package:food_delivery_app/view/auth/signup/signup_view.dart';
import 'package:food_delivery_app/view/on_boarding/on_boarding_view.dart';
import 'package:get/get.dart';

// import 'package:otp_pin_field/otp_pin_field.dart';
import 'package:lottie/lottie.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(LoginController());
    return Scaffold(
      backgroundColor: Tcolor.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
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
                'Welcome Back!',
                style: TextStyle(
                  fontSize: 14,
                  color: Tcolor.primaryText,
                  fontWeight: FontWeight.w500,
                ),
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
              const SizedBox(height: 25),
              RoundButton(
                onPressed: () async {
                  if (emailController.text.isEmpty ||
                      passwordController.text.isEmpty) {
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
                    LoginModel model = LoginModel(
                      email: emailController.text.trim(),
                      password: passwordController.text.trim(),
                    );
                    String data = loginModelToJson(model);
                    bool loginSuccess = await controller.loginFunction(data);
                    
                    // Only proceed if login was successful
                    if (loginSuccess) {
                      final user = controller.getUserInfo();
                      
                      if (user != null) {
                        debugPrint('User Info: ${user.username}, ${user.email}');
                        
                        Get.showSnackbar(
                          GetSnackBar(
                            title: 'Login Successful',
                            message: 'Welcome back, ${user.username}!',
                            duration: const Duration(seconds: 2),
                            snackPosition: SnackPosition.TOP,
                            backgroundColor: Tcolor.primary,
                            borderColor: Colors.white,
                          ),
                        );
                        
                        Get.offAll(
                          () => const OnBoardingView(),
                          transition: Transition.rightToLeft,
                        );
                      }
                    }
                  }
                },
                text: controller.isLoading ? 'Loading...' : 'L O G I N',
              ),
              const SizedBox(height: 15),
              TextButton(
                onPressed: () {
                  Get.off(
                    const ResetPassword(),
                    transition: Transition.rightToLeft,
                  );
                },
                child: Text(
                  'Forgot Password?',
                  style: TextStyle(
                    color: Tcolor.secondaryText,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 15),
              Text(
                'Or Login With',
                style: TextStyle(
                  color: Tcolor.secondaryText,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 15),
              RoundIconButton(
                onPressed: () {
                  //_showPhoneNumberBottomSheet();
                },
                title: 'Login with Phone Number',
                icon: 'assets/iimg/phone.png',
                color: const Color(0xff367FC0),
              ),
              const SizedBox(height: 15),
              RoundIconButton(
                onPressed: () {
                  // AuthMethods().signInWithGoogle(context);
                },
                title: 'Login with Google',
                icon: 'assets/iimg/google_log.png',
                color: const Color(0xddE74F50),
              ),
              const SizedBox(height: 30),
              TextButton(
                onPressed: () {
                  Get.offAll(
                    const SignupView(),
                    transition: Transition.rightToLeft,
                  );
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Don\'t have an account? ',
                      style: TextStyle(
                        color: Tcolor.secondaryText,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      'Sign Up',
                      style: TextStyle(
                        color: Tcolor.primary,
                        fontSize: 16,
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
