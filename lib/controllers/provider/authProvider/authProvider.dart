import 'package:flutter/material.dart';

class MobileAuthprovider extends ChangeNotifier{

  String? mobileNumber;
  String? verificationId;

  updateVerificationID(String verification){
    verificationId = verification;
    notifyListeners();
  }

  updateMobileNumber(String phoneNo){
    mobileNumber = phoneNo;
    notifyListeners();
  }


}