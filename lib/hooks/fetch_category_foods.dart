import 'package:flutter/cupertino.dart';
import 'package:food_delivery_app/common/constants.dart';
import 'package:food_delivery_app/controllers/category_controller.dart';
import 'package:food_delivery_app/models/api_error.dart';
import 'package:food_delivery_app/models/foods.dart';
import 'package:food_delivery_app/models/hook_models/hook_foods.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

FetchFoods useFetchCategoryFoods() {
  final controller = Get.put(CategoryController());
  final foods = useState<List<FoodItem>?>(null);
  final isLoading = useState<bool>(false);
  final error = useState<Exception?>(null);
  final apiError = useState<ApiError?>(null);

  Future<void> fetchData() async {
    if (controller.categoryValue.isEmpty) {
      foods.value = [];
      //debugPrint('Category value is empty, returning empty list');
      return;
    }

    isLoading.value = true;
    //debugPrint('Fetching foods for category: ${controller.categoryValue}');

    try {
      // Use the new category-only endpoint
      Uri url = Uri.parse(
          '$appBaseUrl/api/food/category/${controller.categoryValue}');
      //debugPrint('Requesting URL: $url');

      final response = await http.get(url);

      // debugPrint('Response status: ${response.statusCode}');
      // debugPrint('Response body: ${response.body}');

      if (response.statusCode == 200) {
        foods.value = foodItemFromJson(response.body);
        //debugPrint('Category foods: ${foods.value?.length} items found');
        if (foods.value != null) {
          for (var food in foods.value!) {
            // debugPrint(
            //     'Found food: ${food.title} (category: ${food.category})');
          }
        }
      } else if (response.statusCode == 404) {
        // No foods found for this category
        foods.value = [];
        //debugPrint('No foods found for category: ${controller.categoryValue}');
      } else if (response.statusCode == 400) {
        apiError.value = ApiError.fromJson(json.decode(response.body));
        error.value = null;
        debugPrint('API Error: ${apiError.value?.message}');
      } else {
        throw Exception(
            'Failed to load category foods: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Exception in fetchCategoryFoods: $e');
      error.value = e as Exception;
    } finally {
      isLoading.value = false;
    }
  }

  useEffect(() {
    fetchData();
    return null;
  }, [controller.categoryValue]);

  void refetch() {
    isLoading.value = true;
    fetchData();
  }

  return FetchFoods(
    data: foods.value,
    isLoading: isLoading.value,
    error: error.value,
    refetch: refetch,
  );
}
