import 'package:flutter/material.dart';
import 'package:food_delivery_app/common/constants.dart';
import 'package:food_delivery_app/models/additives_obs.dart';
import 'package:food_delivery_app/models/api_error.dart';
import 'package:food_delivery_app/models/foods.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;

class FoodsController extends GetxController {
  final box = GetStorage();

  RxBool _isLoading = false.obs;
  bool get isLoading => _isLoading.value;
  set setLoading(bool value) => _isLoading.value = value;

  RxInt currentIndex = 0.obs;
  bool initialCheckValue = false;
  var additivesList = <ObsAdditives>[].obs;
  RxDouble _totalPrice = 0.0.obs;

  void changeIndex(int index) {
    currentIndex.value = index;
  }

  RxInt count = 1.obs;
  void incrementCount() {
    count.value++;
  }

  void decrementCount() {
    if (count.value > 1) {
      count.value--;
    }
  }

  void addToCart(String cart) async {
    setLoading = true;
    String token = box.read('token');
    var uri = Uri.parse('${appBaseUrl}api/cart');
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
    };

    try {
      var response = await http.post(
        uri,
        headers: headers,
        body: cart,
      );

      if (response.statusCode == 201) {
        setLoading = false;
        Get.snackbar(
          'Added to Cart',
          'Enjoy your awesome experience.',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.green,
          colorText: Colors.white,
          icon: const Icon(Icons.check_circle_outline, color: Colors.white),
          duration: const Duration(seconds: 2),
        );
      } else {
        Get.snackbar(
          'Error',
          'Failed to add product to cart',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          icon: const Icon(Icons.error, color: Colors.white),
          duration: const Duration(seconds: 2),
        );
      }
    } catch (e) {
      ApiError error = apiErrorFromJson(e.toString());
      debugPrint('Exception: $error');
      setLoading = false;
      Get.snackbar(
        'Error',
        'Failed to add product to cart: ${error.message}',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        icon: const Icon(Icons.error, color: Colors.white),
        duration: const Duration(seconds: 3),
      );
    }
  }

  void removeFromCart(String productId) async {
    setLoading = true;
    String token = box.read('token');

    var uri = Uri.parse('${appBaseUrl}api/cart/delete/$productId');
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
    };

    try {
      var response = await http.delete(
        uri,
        headers: headers,
      );

      if (response.statusCode == 200) {
        setLoading = false;
        Get.snackbar(
          'Removed from Cart',
          'Product has been removed from your cart.',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.green,
          colorText: Colors.white,
          icon: const Icon(Icons.check_circle_outline, color: Colors.white),
          duration: const Duration(seconds: 2),
        );
      } else {
        Get.snackbar(
          'Error',
          'Failed to remove product from cart',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white,
          icon: const Icon(Icons.error, color: Colors.white),
          duration: const Duration(seconds: 2),
        );
      }
    } catch (e) {
      ApiError error = apiErrorFromJson(e.toString());
      debugPrint('Exception: $error');
      setLoading = false;
      Get.snackbar(
        'Error',
        'Error Occured in deleting the item : ${error.message}',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        icon: const Icon(Icons.error, color: Colors.white),
        duration: const Duration(seconds: 3),
      );
    }
  }

  double get totalAdditivesPrice => _totalPrice.value;

  set setTotalAdditivesPrice(double price) {
    _totalPrice.value = price;
  }

  void loadAdditives(List<Additive> additives) {
    additivesList.clear();

    final newList = additives
        .map((additiveInfo) => ObsAdditives(
              id: additiveInfo.id,
              title: additiveInfo.title,
              price: additiveInfo.price,
              checked: initialCheckValue,
            ))
        .toList();

    additivesList.assignAll(newList);
  }

  double getTotalPrice() {
    double totalPrice = 0.0;
    for (var additive in additivesList) {
      if (additive.isChecked.value) {
        totalPrice += double.tryParse(additive.price) ?? 0.0;
      }
    }
    //print('Total Price: $totalPrice');
    _totalPrice.value = totalPrice;
    return totalPrice;
  }
}
