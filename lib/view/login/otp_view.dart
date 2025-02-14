// import 'package:flutter/material.dart';
// import 'package:food_delivery_app/common/color_extension.dart';
// import 'package:food_delivery_app/common_widgets/round_button.dart';
// import 'package:otp_pin_field/otp_pin_field.dart';

// class OTPView extends StatefulWidget {
//   const OTPView({super.key});

//   @override
//   State<OTPView> createState() => _OTPViewState();
// }

// class _OTPViewState extends State<OTPView> {
//   final _otpPinFieldController = GlobalKey<OtpPinFieldState>();
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Tcolor.white,
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 25),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               const SizedBox(height: 70),
//               Text(
//                 'We have sent an OTP to your mobile',
//                 textAlign: TextAlign.center,
//                 style: TextStyle(
//                   fontSize: 30,
//                   color: Tcolor.primaryText,
//                   fontWeight: FontWeight.w800,
//                 ),
//               ),
//               const SizedBox(
//                 height: 45,
//               ),
//               Text(
//                 'Please check your mobile number 07*******23\n continue to reset your password.',
//                 style: TextStyle(
//                   fontSize: 14,
//                   color: Tcolor.secondaryText,
//                   fontWeight: FontWeight.w500,
//                 ),
//                 textAlign: TextAlign.center,
//               ),
//               const SizedBox(
//                 height: 40,
//               ),
//               SizedBox(
//                 height: 60,
//                 child: OtpPinField(
//                   key: _otpPinFieldController,

//                   ///in case you want to enable autoFill
//                   autoFillEnable: false,

//                   ///for Ios it is not needed as the SMS autofill is provided by default, but not for Android, that's where this key is useful.
//                   textInputAction: TextInputAction.done,

//                   ///in case you want to change the action of keyboard
//                   /// to clear the Otp pin Controller
//                   onSubmit: (text) {
//                     FocusScope.of(context).requestFocus(FocusNode());

//                     /// return the entered pin
//                   },
//                   onChange: (text) {
//                     debugPrint('Enter on change pin is $text');

//                     /// return the entered pin
//                   },
//                   onCodeChanged: (code) {
//                     debugPrint('onCodeChanged  is $code');
//                   },

//                   /// to decorate your Otp_Pin_Field
//                   otpPinFieldStyle: OtpPinFieldStyle(
//                     /// bool to show hints in pin field or not
//                     showHintText: true,

//                     /// to set the color of hints in pin field or not
//                     // hintTextColor: Colors.red,

//                     /// to set the text  of hints in pin field
//                     // hintText: '1',

//                     /// border color for inactive/unfocused Otp_Pin_Field
//                     defaultFieldBorderColor: Tcolor.secondaryText,

//                     /// border color for active/focused Otp_Pin_Field
//                     activeFieldBorderColor: Tcolor.primary,

//                     /// Background Color for inactive/unfocused Otp_Pin_Field
//                     defaultFieldBackgroundColor: Tcolor.textfield,

//                     /// Background Color for active/focused Otp_Pin_Field
//                     activeFieldBackgroundColor: Tcolor.textfield,

//                     /// Background Color for filled field pin box
//                     // filledFieldBackgroundColor: Colors.green,

//                     /// border Color for filled field pin box
//                     // filledFieldBorderColor: Colors.green,
//                     //
//                     /// gradient border Color for field pin box
//                     // gradientFieldBorderColor: [Colors.red, Colors.blue],
//                   ),
//                   maxLength: 4,

//                   /// no of pin field
//                   showCursor: true,

//                   /// bool to show cursor in pin field or not
//                   cursorColor: Colors.indigo,

//                   /// to choose cursor color
//                   upperChild: const Column(
//                     children: [
//                       SizedBox(height: 30),
//                       Icon(Icons.flutter_dash_outlined, size: 150),
//                       SizedBox(height: 20),
//                     ],
//                   ),
//                   // 123456

//                   ///bool which manage to show custom keyboard
//                   // showCustomKeyboard: true,

//                   /// Widget which help you to show your own custom keyboard in place if default custom keyboard
//                   // customKeyboard: Container(),
//                   ///bool which manage to show default OS keyboard
//                   showDefaultKeyboard: true,

//                   /// to select cursor width
//                   cursorWidth: 3,

//                   /// place otp pin field according to yourself
//                   mainAxisAlignment: MainAxisAlignment.center,

//                   /// predefine decorate of pinField use  OtpPinFieldDecoration.defaultPinBoxDecoration||OtpPinFieldDecoration.underlinedPinBoxDecoration||OtpPinFieldDecoration.roundedPinBoxDecoration
//                   ///use OtpPinFieldDecoration.custom  (by using this you can make Otp_Pin_Field according to yourself like you can give fieldBorderRadius,fieldBorderWidth and etc things)
//                   otpPinFieldDecoration:
//                       OtpPinFieldDecoration.defaultPinBoxDecoration,
//                 ),
//               ),
//               const SizedBox(
//                 height: 40,
//               ),
//               RoundButton(
//                 onPressed: () {
//                   FocusScope.of(context).requestFocus(FocusNode());
//                 },
//                 text: 'Proceed',
//               ),
//               TextButton(
//                 onPressed: () {},
//                 child: Row(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     Text(
//                       "Didn't Receieved?  ",
//                       style: TextStyle(
//                         color: Tcolor.secondaryText,
//                         fontSize: 14,
//                         fontWeight: FontWeight.w500,
//                       ),
//                     ),
//                     Text(
//                       'Click here',
//                       style: TextStyle(
//                         color: Tcolor.primary,
//                         fontSize: 14,
//                         fontWeight: FontWeight.w500,
//                       ),
//                     )
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
