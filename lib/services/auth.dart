// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:food_delivery_app/services/database.dart';
// import 'package:food_delivery_app/view/home/homeview.dart';
// import 'package:google_sign_in/google_sign_in.dart';

// class AuthMethods{
//   final FirebaseAuth _auth = FirebaseAuth.instance;
  
//   getCurrentUser() async {
//     return _auth.currentUser;
//   }

//   signInWithGoogle(BuildContext context, )async {
//     final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
//     final GoogleSignIn googleSignIn = GoogleSignIn();

//     final GoogleSignInAccount? googleSignInAccount = await googleSignIn.signIn();


//     final GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount!.authentication;

//     final AuthCredential credential = GoogleAuthProvider.credential(
//       idToken: googleSignInAuthentication.idToken,
//       accessToken: googleSignInAuthentication.accessToken,
//     );

//     UserCredential result = await firebaseAuth.signInWithCredential(credential);

//     User? userdetails = result.user;

//     Map<String, dynamic> userInfoMap = {
//       "email": userdetails!.email,
//       "username": userdetails.displayName,
//       "profilePhoto": userdetails.photoURL,
//       // "address" : "",
//       // "phoneNo" : "",


      
//     };
//     await DatabaseMethods().addUser(userdetails.uid, userInfoMap);
//     Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const Homeview()));
//     }























//   // Future signInWithEmailAndPassword(String email, String password) async {
//   //   try {
//   //     UserCredential result = await _auth.signInWithEmailAndPassword(email: email, password: password);
//   //     User? user = result.user;
//   //     return user;
//   //   } catch(e) {
//   //     print(e.toString());
//   //   }
//   // }

//   // Future signUpWithEmailAndPassword(String email, String password) async {
//   //   try {
//   //     UserCredential result = await _auth.createUserWithEmailAndPassword(email: email, password: password);
//   //     User? user = result.user;
//   //     return user;
//   //   } catch(e) {
//   //     print(e.toString());
//   //   }
//   // }

//   // Future resetPassword(String email) async {
//   //   try {
//   //     return await _auth.sendPasswordResetEmail(email: email);
//   //   } catch(e) {
//   //     print(e.toString());
//   //   }
//   // }

//   // Future signOut() async {
//   //   try {
//   //     return await _auth.signOut();
//   //   } catch(e) {
//   //     print(e.toString());
//   //   }
//   // }
// }