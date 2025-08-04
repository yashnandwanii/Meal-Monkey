import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:food_delivery_app/common/constants.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:get_storage/get_storage.dart';

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
    position = value;
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
    _postalCode.value = value;
  }

  Future<void> addAddress(String addressData) async {
    try {
      final box = GetStorage();
      String? accessToken = box.read('token');

      Uri uri = Uri.parse('$appBaseUrl/api/address');
      Map<String, String> headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      };

      var response = await http.post(uri, headers: headers, body: addressData);

      if (response.statusCode == 201) {
        Get.back();
        Get.snackbar(
          'Success',
          'Address added successfully',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      } else {
        Get.snackbar(
          'Error',
          'Failed to add address',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'An error occurred while adding address',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  void getUserAddress(LatLng position) async {
    final url = Uri.parse(
      'https://maps.googleapis.com/maps/api/geocode/json?latlng=${position.latitude},${position.longitude}&key=$googleApiKey',
    );

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final responseBody = jsonDecode(response.body);

        if (responseBody['results'] != null &&
            responseBody['results'].isNotEmpty) {
          final result = responseBody['results'][0];

          // Set formatted address
          final formattedAddress = result['formatted_address'];
          if (formattedAddress != null) {
            setAddress = formattedAddress;
          }

          // Extract postal code
          final addressComponents = result['address_components'];
          if (addressComponents != null && addressComponents is List) {
            for (var component in addressComponents) {
              if (component['types'].contains('postal_code')) {
                setPostalCode = component['long_name'];
                break;
              }
            }
          }
        } else {
          debugPrint("No address results found");
          Get.snackbar(
            'Error',
            'Could not fetch address details.',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
        }
      } else {
        debugPrint('Error fetching address: ${response.statusCode}');
        Get.snackbar(
          'Error',
          'Failed to fetch address. Please try again.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      debugPrint("Exception while fetching address: $e");
      Get.snackbar(
        'Exception',
        'Something went wrong while fetching address.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }
}
