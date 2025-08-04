import 'package:flutter/material.dart';
import 'package:food_delivery_app/common/constants.dart';
import 'package:food_delivery_app/models/foods.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class SearchFoodController extends GetxController {
  RxBool _isLoading = false.obs;

  bool get isLoading => _isLoading.value;
  set setLoading(bool value) {
    _isLoading.value = value;
  }

  RxBool _isTrigger = false.obs;

  bool get isTrigger => _isTrigger.value;
  set setTrigger(bool value) {
    _isTrigger.value = value;
  }

  List<FoodItem>? searchResults;

  void searchFoods(String query) async {
    setLoading = true;
    // Simulate a network call
    Uri uri = Uri.parse('$appBaseUrl/api/food/search/$query');

    try {
      // Assuming you have a method to fetch data from the A
      var response = await http.get(uri);
      if (response.statusCode == 200) {
        searchResults = foodItemFromJson(response.body);
        setLoading = false;
      } else {
        debugPrint('Failed to load search results: ${response.statusCode}');
        searchResults = [];
        setLoading = false;
      }
    } catch (e) {
      debugPrint('Error occurred while searching: $e');
      searchResults = [];
    } finally {
      setLoading = false;
    }
  }
}
