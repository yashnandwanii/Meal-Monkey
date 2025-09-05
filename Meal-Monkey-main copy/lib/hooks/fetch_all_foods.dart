import 'package:flutter/widgets.dart';
import 'package:food_delivery_app/common/constants.dart';
import 'package:food_delivery_app/models/api_error.dart';
import 'package:food_delivery_app/models/foods.dart';
import 'package:food_delivery_app/models/hook_models/hook_foods.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

FetchFoods useFetchAllFoods(String code) {
  final foods = useState<List<FoodItem>?>(null);
  final isLoading = useState<bool>(false);
  final error = useState<Exception?>(null);
  final apiError = useState<ApiError?>(null);

  Future<void> fetchData() async {
    isLoading.value = true;
    try {
      Uri url = Uri.parse('$appBaseUrl/api/food/code/$code');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        foods.value = foodItemFromJson(response.body);
      } else if (response.statusCode == 404) {
        debugPrint('No foods found for code: $code');
        foods.value = [];
      } else if (response.statusCode == 400) {
        apiError.value = ApiError.fromJson(json.decode(response.body));
        error.value = null;
        foods.value = [];
      } else {
        debugPrint('Error: ${response.statusCode}');
        error.value = Exception('Failed to load foods: ${response.statusCode}');
        foods.value = [];
      }
    } catch (e) {
      debugPrint('Exception in fetchAllFoods: $e');
      error.value = Exception('Failed to fetch foods: $e');
      foods.value = [];
    } finally {
      isLoading.value = false;
    }
  }

  useEffect(() {
    fetchData();
    return null;
  }, []);

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
