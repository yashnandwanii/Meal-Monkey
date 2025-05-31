import 'package:flutter/material.dart';
import 'package:food_delivery_app/common/color_extension.dart';
import 'package:food_delivery_app/common_widgets/round_button.dart';
import 'package:food_delivery_app/common_widgets/round_icon_button.dart';
import 'package:food_delivery_app/common_widgets/round_textfield.dart';
import 'package:food_delivery_app/controllers/provider/authProvider/auth_provider.dart';
import 'package:food_delivery_app/view/login/reset_password.dart';
import 'package:food_delivery_app/view/login/signup_view.dart';
import 'package:food_delivery_app/view/on_boarding/on_boarding_view.dart';

import 'package:otp_pin_field/otp_pin_field.dart';
import 'package:provider/provider.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  String email = '';
  String password = '';
  var selectedCountry = '+91';
  bool recieveOtpButtonPressed = false;

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final GlobalKey<OtpPinFieldState> _otpPinFieldController =
      GlobalKey<OtpPinFieldState>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        recieveOtpButtonPressed = false;
      });
    });
  }

  void _showPhoneNumberBottomSheet() {
    showModalBottomSheet(
      backgroundColor: Colors.white,
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            left: 25,
            right: 25,
            top: 20,
            bottom: MediaQuery.of(context).viewInsets.bottom + 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Enter your phone number',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Tcolor.primaryText,
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  hintText: 'Enter phone number',
                  prefixIcon: Icon(Icons.phone, color: Tcolor.primary),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Tcolor.secondaryText),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              RoundButton(
                onPressed: () {
                  if (_phoneController.text.isNotEmpty) {
                    setState(() {
                      recieveOtpButtonPressed = true;
                    });
                    context.read<MobileAuthprovider>().updateMobileNumber(
                          '$selectedCountry${_phoneController.text.trim()}',
                        );
                    // Mobileauthservices.receiveOtp(
                    //   context: context,
                    //   phoneNo:
                    //       '$selectedCountry${_phoneController.text.trim()}',
                    // );
                    Navigator.pop(context);
                    setState(() {
                      recieveOtpButtonPressed = false;
                    }); // Close phone number sheet
                    _showOtpBottomSheet();
                    // Open OTP sheet
                  } else {
                    setState(() {
                      recieveOtpButtonPressed = false;
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Please enter a phone number')),
                    );
                  }
                },
                text: recieveOtpButtonPressed ? 'Loading...' : 'Next',
              ),
            ],
          ),
        );
      },
    );
  }

  /// Show bottom sheet for OTP verification
  void _showOtpBottomSheet() {
    showModalBottomSheet(
      backgroundColor: Colors.white,
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            left: 25,
            right: 25,
            top: 20,
            bottom: MediaQuery.of(context).viewInsets.bottom + 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Enter OTP',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Tcolor.primaryText,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'We have sent an OTP to +91${_phoneController.text}',
                style: TextStyle(
                  fontSize: 14,
                  color: Tcolor.secondaryText,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              SizedBox(
                height: 60,
                child: OtpPinField(
                  onChange: (text) => print(text),
                  key: _otpPinFieldController,
                  autoFillEnable: false,
                  textInputAction: TextInputAction.done,
                  onSubmit: (text) {
                    // Handle OTP submission
                  },
                  otpPinFieldStyle: OtpPinFieldStyle(
                    showHintText: true,
                    defaultFieldBorderColor: Tcolor.secondaryText,
                    activeFieldBorderColor: Tcolor.primary,
                    defaultFieldBackgroundColor: Tcolor.textfield,
                    activeFieldBackgroundColor: Tcolor.textfield,
                  ),
                  maxLength: 4,
                  showCursor: true,
                  cursorColor: Colors.indigo,
                  showDefaultKeyboard: true,
                  cursorWidth: 3,
                  mainAxisAlignment: MainAxisAlignment.center,
                  otpPinFieldDecoration:
                      OtpPinFieldDecoration.defaultPinBoxDecoration,
                ),
              ),
              const SizedBox(height: 20),
              RoundButton(
                onPressed: () {
                  // Handle OTP verification
                  // Mobileauthservices.verifyOtp(
                  //   context: context,
                  //   otp: _otpPinFieldController.toString(),
                  // );
                },
                text: 'Verify OTP',
              ),
              const SizedBox(height: 10),
              TextButton(
                onPressed: () {
                  // Handle resend OTP
                },
                child: Text(
                  'Resend OTP',
                  style: TextStyle(
                    color: Tcolor.primary,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void userLogin() async {
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
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
    }
    //await AuthController().login(emailController.text, passwordController.text);
  }

  @override
  Widget build(BuildContext context) {
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
                onPressed: () {
                  _showPhoneNumberBottomSheet();
                },
                title: 'Login with Phone Number',
                icon: 'assets/iimg/phone.png',
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
