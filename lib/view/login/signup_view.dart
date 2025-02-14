// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:food_delivery_app/common/color_extension.dart';
import 'package:food_delivery_app/common_widgets/round_button.dart';
import 'package:food_delivery_app/common_widgets/round_textfield.dart';
import 'package:food_delivery_app/view/login/login_view.dart';

class SignupView extends StatefulWidget {
  const SignupView({super.key});

  @override
  State<SignupView> createState() => _SignupViewState();
}

class _SignupViewState extends State<SignupView> {
  String email = '';
  String password = '';
  String confirmPassword = '';
  String phoneNo = '';
  String name = '';
  String address = '';

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  TextEditingController phoneNoController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController addressController = TextEditingController();

  // registration() async {
  //   if (emailController.text.isNotEmpty &&
  //       passwordController.text.isNotEmpty &&
  //       confirmPasswordController.text.isNotEmpty &&
  //       phoneNoController.text.isNotEmpty &&
  //       nameController.text.isNotEmpty &&
  //       addressController.text.isNotEmpty) {
  //     if (passwordController.text == confirmPasswordController.text) {
  //       try {
  //         UserCredential userCredential = await FirebaseAuth.instance
  //             .createUserWithEmailAndPassword(
  //                 email: emailController.text,
  //                 password: passwordController.text);
  //         SharedPreferences prefs = await SharedPreferences.getInstance();
  //         prefs.setBool('isLoggedIn', true); // Store login status
  //         prefs.setString('email', userCredential.user!.email ?? "");

  //         print("Login successful: ${userCredential.user?.email}");

  //         Navigator.pushReplacement(context,
  //             MaterialPageRoute(builder: (context) => const OnBoardingView()));

  //         ScaffoldMessenger.of(context).showSnackBar(
  //           const SnackBar(
  //             backgroundColor: Colors.green,
  //             content: Text(
  //               'Registration Success',
  //               style: TextStyle(
  //                 color: Colors.white,
  //                 fontWeight: FontWeight.w800,
  //                 fontSize: 14,
  //               ),
  //             ),
  //           ),
  //         );
  //       } on FirebaseAuthException catch (e) {
  //         if (e.code == 'weak-password') {
  //           ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
  //               content: Text('The password provided is too weak')));
  //         } else if (e.code == 'email-already-in-use') {
  //           ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
  //               content: Text('The account already exists for that email')));
  //         }
  //       } catch (e) {
  //         ScaffoldMessenger.of(context)
  //             .showSnackBar(const SnackBar(content: Text('Error occured')));
  //       }
  //     } else {
  //       ScaffoldMessenger.of(context).showSnackBar(
  //           const SnackBar(content: Text('Password does not match')));
  //     }
  //   } else {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //         const SnackBar(content: Text('Please fill all the fields')));
  //   }
  // }

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
              const SizedBox(height: 25),
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
                hintText: 'Phone Number',
                controller: phoneNoController,
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 25),
              RoundTextfield(
                hintText: 'Address',
                controller: addressController,
                keyboardType: TextInputType.name,
              ),
              const SizedBox(height: 25),
              RoundTextfield(
                hintText: 'Password',
                controller: passwordController,
                obscureText: true,
              ),
              const SizedBox(height: 25),
              RoundTextfield(
                hintText: 'Confirm Password',
                controller: confirmPasswordController,
                obscureText: true,
              ),
              const SizedBox(height: 25),
              RoundButton(
                onPressed: () {
                  if (nameController.text.isNotEmpty &&
                      emailController.text.isNotEmpty &&
                      phoneNoController.text.isNotEmpty &&
                      addressController.text.isNotEmpty &&
                      passwordController.text.isNotEmpty &&
                      confirmPasswordController.text.isNotEmpty) {
                    email = emailController.text;
                    password = passwordController.text;
                    confirmPassword = confirmPasswordController.text;
                    phoneNo = phoneNoController.text;
                    name = nameController.text;
                    address = addressController.text;

                    // registration();
                    // Navigator.push(context,
                    //     MaterialPageRoute(builder: (context) => const OTPView()));
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text('Please fill all the fields')));
                  }
                },
                text: 'Sign Up',
              ),
              const SizedBox(height: 15),
              TextButton(
                onPressed: () {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const LoginView()));
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
            ],
          ),
        ),
      ),
    );
  }
}
