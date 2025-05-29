// import 'dart:developer';

// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:food_delivery_app/controllers/provider/authProvider/authProvider.dart';
// import 'package:food_delivery_app/view/login/signup_view.dart';
// import 'package:food_delivery_app/view/login/welcome_view.dart';
// import 'package:food_delivery_app/view/on_boarding/on_boarding_view.dart';
// import 'package:page_transition/page_transition.dart';
// import 'package:provider/provider.dart';

// final FirebaseAuth auth = FirebaseAuth.instance;

// class Mobileauthservices {
//   static bool checkAuthentication(BuildContext context) {
//     User? user = auth.currentUser;
//     if (user != null) {
//       Navigator.pushAndRemoveUntil(
//           context,
//           MaterialPageRoute(builder: (context) => const OnBoardingView()),
//           (route) => false);
//       return true;
//     } else {
//       Navigator.pushAndRemoveUntil(
//           context,
//           MaterialPageRoute(builder: (context) => const WelcomeView()),
//           (route) => true);

//       return false;
//     }
//   }

//   static receiveOtp(
//       {required BuildContext context, required String phoneNo}) async {
//     try {
//       await auth.verifyPhoneNumber(
//         phoneNumber: phoneNo,
//         verificationCompleted: (PhoneAuthCredential credentials) {
//           log(credentials.toString());
//         },
//         verificationFailed: (FirebaseAuthException e) {
//           log(e.message.toString());
//           throw Exception(e);
//         },
//         codeSent: (String verificationId, int? resendToken) {
//           context
//               .read<MobileAuthprovider>()
//               .updateVerificationID(verificationId);
//           Navigator.push(
//             context,
//             PageTransition(
//               child: const SignupView(),
//               type: PageTransitionType.rightToLeft,
//             ),
//           );
//         },
//         codeAutoRetrievalTimeout: (String verificationID) {},
//       );
//     } catch (e) {
//       log(e.toString());
//       throw Exception(e);
//     }
//   }

//   static verifyOtp({required BuildContext context, required String otp}) async {
//     try {
//       AuthCredential cred = PhoneAuthProvider.credential(
//         verificationId: context.read<MobileAuthprovider>().verificationId!,
//         smsCode: otp,
//       );
//       await auth.signInWithCredential(cred);

//       Navigator.push(
//         context,
//         PageTransition(
//           child: const OnBoardingView(),
//           type: PageTransitionType.rightToLeft,
//         ),
//       );
//     } catch (e) {
//       log(e.toString());
//       throw Exception(e);
//     }
//   }
// }
