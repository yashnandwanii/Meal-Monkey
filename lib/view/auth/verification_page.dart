import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food_delivery_app/common/app_style.dart';
import 'package:food_delivery_app/common/color_extension.dart';
import 'package:food_delivery_app/common/custom_button.dart';
import 'package:food_delivery_app/common/custom_container.dart';
import 'package:food_delivery_app/common/reusable_text.dart';
import 'package:food_delivery_app/controllers/verification_controller.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';

class VerificationPage extends StatelessWidget {
  const VerificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(VerificationController());
    
    return Scaffold(
      appBar: AppBar(
        title: ReusableText(
          text: 'Please Verify Your Account',
          style: appBarTextStyle(
            14,
            Colors.black54,
            FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white54,
        elevation: 0,
      ),
      backgroundColor: Colors.white,
      body: CustomContainer(
        containerContent: Container(
          padding: EdgeInsets.symmetric(horizontal: 25.w, vertical: 20.h),
          height: MediaQuery.of(context).size.height,
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              Container(
                width: 200.w,
                height: 200.h,
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
                'Enter the 6-digit code sent to your email address. If you did not receive the code, please check your spam folder or request a new code.',
                style: appBarTextStyle(
                  10,
                  Colors.grey,
                  FontWeight.normal,
                ),
                textAlign: TextAlign.justify,
              ),
              SizedBox(height: 20.h),
              OtpTextField(
                numberOfFields: 6,
                borderWidth: 2.0,
                borderColor: Tcolor.primary,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                showFieldAsBox: true,
                onCodeChanged: (String code) {},
                onSubmit: (String verificationCode) {
                  controller.setCode = verificationCode;
                  debugPrint('Verification code entered: $verificationCode');
                },
                textStyle: appBarTextStyle(
                  17,
                  Colors.black,
                  FontWeight.w600,
                ),
              ),
              SizedBox(height: 20.h),
              Obx(() => CustomButton(
                text: controller.isLoading 
                  ? 'VERIFYING...'
                  : 'V E R I F Y  A C C O U N T',
                ontap: () {
                  if (controller.code.length != 6) {
                    Get.snackbar(
                      'Invalid Code',
                      'Please enter the complete 6-digit code',
                      snackPosition: SnackPosition.BOTTOM,
                      backgroundColor: Colors.red,
                      colorText: Colors.white,
                      duration: const Duration(seconds: 2),
                    );
                    return;
                  }

                  if (!controller.isLoading) {
                    controller.verificationFunction(controller.code);
                  }
                },
                height: 35.h,
                width: double.infinity,
                color: controller.isLoading 
                  ? Colors.grey
                  : Tcolor.primary,
              )),
              SizedBox(height: 15.h),
              TextButton(
                onPressed: () {
                  if (!controller.isLoading) {
                    controller.resendVerificationCode();
                  }
                },
                child: Text(
                  'Resend Verification Code',
                  style: appBarTextStyle(
                    12,
                    controller.isLoading ? Colors.grey : Tcolor.primary,
                    FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
