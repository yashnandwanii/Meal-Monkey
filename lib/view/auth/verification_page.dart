import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food_delivery_app/common/app_style.dart';
import 'package:food_delivery_app/common/color_extension.dart';
import 'package:food_delivery_app/common/custom_button.dart';
import 'package:food_delivery_app/common/custom_container.dart';
import 'package:food_delivery_app/common/reusable_text.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

class VerificationPage extends StatelessWidget {
  const VerificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: ReusableText(
          text: 'Please Verify Your Account',
          style: appBarTextStyle(
            12,
            Colors.grey,
            FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white54,
        elevation: 0,
      ),
      backgroundColor: Colors.white,
      body: CustomContainer(
        containerContent: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: ListView(
            padding: EdgeInsets.zero,
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
              SizedBox(height: 10.h),
              ReusableText(
                text: 'Verify your account to continue',
                style: appBarTextStyle(
                  20,
                  Tcolor.primary,
                  FontWeight.w600,
                ),
              ),
              SizedBox(height: 10.h),
              Text(
                'Enter the 6-digit code sent to your email address, if you did not receive the code, please check your spam folder or request a new code.',
                style: appBarTextStyle(
                  10,
                  Colors.grey,
                  FontWeight.normal,
                ),
                textAlign: TextAlign.justify,
              ),
              SizedBox(height: 20.h),
              CustomButton(
                text: 'V E R I F Y  A C C O U N T',
                ontap: () {
                  // Add verification logic here
                  Get.snackbar(
                    'Verification',
                    'Verification successful!',
                    snackPosition: SnackPosition.BOTTOM,
                    backgroundColor: Tcolor.primary,
                    colorText: Colors.white,
                    icon: const Icon(Icons.check_circle, color: Colors.white),
                    duration: const Duration(seconds: 2),
                  );
                },
                height: 35.h,
                width: double.infinity,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
