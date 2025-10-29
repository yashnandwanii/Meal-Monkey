import 'package:flutter/cupertino.dart';
import 'package:food_delivery_app/common/constants.dart';
import 'package:food_delivery_app/models/api_error.dart';
import 'package:food_delivery_app/models/foods.dart';
import 'package:food_delivery_app/models/hook_models/hook_foods.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

FetchFoods useFetchFoods(String code, {String type = 'recommendation'}) {
  final foods = useState<List<FoodItem>?>(null);
  final isLoading = useState<bool>(false);
  final error = useState<Exception?>(null);
  final apiError = useState<ApiError?>(null);

  Future<void> fetchData() async {
    isLoading.value = true;
    try {
      Uri url = Uri.parse('$appBaseUrl/api/food/$type/$code');
      debugPrint('Fetching foods from: $url');

      final response = await http.get(url);
      debugPrint('Response status: ${response.statusCode}');
      debugPrint('Response body preview: ${response.body.substring(0, response.body.length > 100 ? 100 : response.body.length)}');

      if (response.statusCode == 200) {
        foods.value = foodItemFromJson(response.body);
        debugPrint('Successfully loaded ${foods.value?.length} foods for type: $type');
      } else if (response.statusCode == 404) {
        debugPrint('No foods found for code: $code, type: $type');
        foods.value = [];
      } else if (response.statusCode == 400) {
        apiError.value = ApiError.fromJson(json.decode(response.body));
        error.value = null;
        debugPrint('API Error: ${apiError.value?.message}');
      } else {
        debugPrint('Error: ${response.statusCode}');
        error.value = Exception('Failed to load foods: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Exception in fetchFoods [$type]: $e');
      error.value = Exception('Failed to fetch foods: $e');
      foods.value = [];
    } finally {
      isLoading.value = false;
    }
  }

  useEffect(() {
    fetchData();
    return null;
  }, [code, type]);

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
