import 'package:flutter/material.dart';
import 'package:food_delivery_app/common/color_extension.dart';
import 'package:food_delivery_app/controllers/phone_verification_controller.dart';
import 'package:food_delivery_app/services/verification_services.dart';
import 'package:food_delivery_app/view/cart/cart_page.dart';
import 'package:get/get.dart';
import 'package:phone_otp_verification/phone_verification.dart';

class PhoneVerificationPage extends StatefulWidget {
  const PhoneVerificationPage({super.key});

  @override
  State<PhoneVerificationPage> createState() => _PhoneVerificationPageState();
}

class _PhoneVerificationPageState extends State<PhoneVerificationPage> {
  String _verificationId = '';
  VerificationServices _verificationServices = VerificationServices();

  void _verifyPhoneNumber(String phoneNumber) async {
    final controller = Get.put(PhoneVerificationController());

    await _verificationServices.verifyPhoneNumber(
      controller.phone,
      codeSent: (String verificationId, int? resendToken) {
        _verificationId = verificationId;
        controller.setLoading = false;
      },
    );
  }

  void _submitVerificationCode(String code) async {
    await _verificationServices.verifySmsCode(
      _verificationId,
      code,
    );
    Get.to(
      () => const CartPage(),
      transition: Transition.rightToLeft,
      duration: const Duration(milliseconds: 500),
    );
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(PhoneVerificationController());
    return PhoneVerification(
      isFirstPage: false,
      enableLogo: false,
      themeColor: Tcolor.primary,
      backgroundColor: Colors.white,
      initialPageText: "Enter your phone number",
      initialPageTextStyle: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Tcolor.primary,
      ),
      textColor: Colors.black,
      onSend: (String value) {
        controller.setPhoneNo = value;
        debugPrint("Phone number sent: $value");
        _verifyPhoneNumber(value);
      },
      onVerification: (String value) {
        // Handle the verification action here, e.g., verify the OTP
        debugPrint("OTP verified: $value");
        _submitVerificationCode(value);
      },
    );
  }
}
