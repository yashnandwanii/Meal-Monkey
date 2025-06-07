import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery_app/common/constants.dart';
import 'package:food_delivery_app/controllers/phone_verification_controller.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

class VerificationServices {
  final controller = Get.put(PhoneVerificationController());
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> verifyPhoneNumber(
    String phoneNumber, {
    required Null Function(
      String verificationId,
      int? resendToken,
    ) codeSent,
  }) async {
    try {
      // Format phone number if it doesn't have country code
      if (!phoneNumber.startsWith('+')) {
        phoneNumber = '+91$phoneNumber'; // Default to US/Canada
      }

      await _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        timeout: const Duration(seconds: 60),
        verificationCompleted: (PhoneAuthCredential credentials) {
          debugPrint('Auto verification completed');
          controller.verifyPhoneNumber();
        },
        verificationFailed: (FirebaseAuthException e) {
          debugPrint('Phone verification failed: ${e.message}');
          controller.setLoading = false;
          Get.snackbar(
            'Verification Failed',
            e.message ?? 'Please check your phone number and try again',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            colorText: Colors.white,
            duration: const Duration(seconds: 3),
          );
        },
        codeSent: (String verificationId, int? resendToken) {
          debugPrint('SMS code has been sent');
          codeSent(verificationId, resendToken);
          Get.snackbar(
            'Code Sent',
            'Please check your phone for the verification code',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green,
            colorText: Colors.white,
            duration: const Duration(seconds: 2),
          );
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          debugPrint('Auto retrieval timeout');
          Get.snackbar(
            'Timeout',
            'Verification code request timed out. Please try again.',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.orange,
            colorText: Colors.white,
            duration: const Duration(seconds: 2),
          );
        },
      );
      controller.setLoading = true; // Set loading state to true
    } catch (e) {
      debugPrint('Error during phone verification: $e');
      controller.setLoading = false; // Set loading state to false on error
      Get.snackbar(
        'Error',
        'Failed to verify phone number: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        icon: const Icon(Icons.error, color: Colors.white),
        duration: const Duration(seconds: 3),
      );
    }
  }

  Future<void> verifySmsCode(String verificationId, String smsCode) async {
    PhoneAuthCredential credential = PhoneAuthProvider.credential(
      verificationId: verificationId,
      smsCode: smsCode,
    );

    try {
      final userCredential = await _auth.signInWithCredential(credential);
      if (userCredential.user != null) {
        // Get user token from storage
        final box = GetStorage();
        final token = box.read('token');

        if (token != null) {
          // Update phone verification status in backend
          final uri = Uri.parse(
              '$appBaseUrl/api/users/verifyPhone/${userCredential.user!.phoneNumber}');
          final response = await http.post(
            uri,
            headers: {
              'Content-Type': 'application/json',
              'Authorization': 'Bearer $token',
            },
          );

          if (response.statusCode == 200) {
            // Update local storage
            final userId = box.read('userId');
            if (userId != null) {
              final userData = box.read(userId);
              if (userData != null) {
                final Map<String, dynamic> updatedData = json.decode(userData);
                updatedData['phoneVerification'] = true;
                box.write(userId, json.encode(updatedData));
              }
            }

            controller.setLoading = false;
            Get.snackbar(
              'Success',
              'Phone number verified successfully!',
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: Colors.green,
              colorText: Colors.white,
              icon: const Icon(Icons.check_circle, color: Colors.white),
              duration: const Duration(seconds: 2),
            );

            Get.back(); // Close verification page
          }
        } else {
          Get.snackbar(
            'Error',
            'Failed to update phone verification status. Please try again.',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            colorText: Colors.white,
            icon: const Icon(Icons.error, color: Colors.white),
            duration: const Duration(seconds: 3),
          );
        }
      }
    } catch (e) {
      controller.setLoading = false;
      Get.snackbar(
        'Error',
        'Failed to sign in with phone number: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        icon: const Icon(Icons.error, color: Colors.white),
        duration: const Duration(seconds: 3),
      );
    }
  }
}
