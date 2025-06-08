import 'dart:convert';

import 'package:food_delivery_app/common/constants.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

class UserLocationController extends GetxController {
  RxInt _tabIndex = 0.obs;
  int get tabIndex => _tabIndex.value;
  set tabIndex(int value) {
    _tabIndex.value = value;
  }

  RxBool _isDefault = false.obs;
  bool get isDefault => _isDefault.value;
  set isDefault(bool value) {
    _isDefault.value = value;
  }

  LatLng position = const LatLng(0, 0);
  void setPosition(LatLng value) {
    value = position;
    update();
  }

  RxString _address = ''.obs;
  String get address => _address.value;

  set setAddress(String value) {
    _address.value = value;
  }

  RxString _postalCode = ''.obs;
  String get postalCode => _postalCode.value;

  set setPostalCode(String value) {
    _address.value = value;
  }

  void getUserAddress(LatLng position) async {
    final url = Uri.parse(
      'https://maps.googleapis.com/maps/api/geocode/json?latlng=${position.latitude},${position.longitude}&key=$googleApiKey',
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final responseBody = jsonDecode(response.body);

      final address = responseBody['results'][0]['formatted_address'];
      setAddress = address;

      final addressComponents =
          responseBody['results'][0]['address_components'];

      for (var component in addressComponents) {
        if (component['types'].contains('postal_code')) {
          setPostalCode = component['long_name'];
        }
      }
    } else {
      print('Failed to fetch address: ${response.statusCode}');
    }
  }
}
