import 'package:flutter/cupertino.dart';
import 'package:food_delivery_app/common/constants.dart';
import 'package:food_delivery_app/models/api_error.dart';
import 'package:food_delivery_app/models/foods.dart';
import 'package:food_delivery_app/models/hook_models/hook_foods.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

FetchFoods useFetchFoods(String code) {
  final foods = useState<List<FoodItem>?>(null);
  final isLoading = useState<bool>(false);
  final error = useState<Exception?>(null);
  final apiError = useState<ApiError?>(null);

  Future<void> fetchData() async {
    isLoading.value = true;
    try {
      Uri url = Uri.parse('$appBaseUrl/api/food/recommendation/$code');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        //foods.value = foodsModelFromJson(response.body);
        foods.value = foodItemFromJson(response.body);
      } else if (response.statusCode == 400) {
        apiError.value = ApiError.fromJson(json.decode(response.body));
        error.value = null;
      } else {
        debugPrint('Error: ${response.statusCode}');
      }
    } catch (e) {
      //print('Exception: $e');
      error.value = e as Exception;
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
