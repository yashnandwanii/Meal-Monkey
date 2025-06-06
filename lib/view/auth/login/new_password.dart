import 'package:flutter/material.dart';
import 'package:food_delivery_app/common/color_extension.dart';
import 'package:food_delivery_app/common_widgets/round_button.dart';
import 'package:food_delivery_app/common_widgets/round_textfield.dart';

class NewPassword extends StatefulWidget {
  const NewPassword({super.key});

  @override
  State<NewPassword> createState() => _NewPasswordState();
}

class _NewPasswordState extends State<NewPassword> {
  TextEditingController txtPasswordController = TextEditingController();
  TextEditingController txtConfirmPasswordController = TextEditingController();

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
                'New Password',
                style: TextStyle(
                  fontSize: 30,
                  color: Tcolor.primaryText,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              Text(
                'Please enter your new password and confirm password.',
                style: TextStyle(
                  fontSize: 14,
                  color: Tcolor.primaryText,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 60),
              RoundTextfield(
                hintText: 'New Password',
                controller: txtPasswordController,
              ),
              const SizedBox(height: 25),
              RoundTextfield(
                hintText: 'Confirm Password',
                controller: txtConfirmPasswordController,
              ),
              const SizedBox(
                height: 40,
              ),
              RoundButton(
                onPressed: () {},
                text: 'Proceed',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
