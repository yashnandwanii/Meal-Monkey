import 'package:food_delivery_app/common/constants.dart';
import 'package:food_delivery_app/models/categories.dart';
import 'package:food_delivery_app/models/api_error.dart';
import 'package:food_delivery_app/models/hook_models/hook_result.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


FetchHook useFetchCategories() {
  final categories = useState<List<CategoriesModel>?>(null);
  final isLoading = useState<bool>(false);
  final error = useState<Exception?>(null);
  final apiError = useState<ApiError?>(null);

  Future<void> fetchData() async {
    isLoading.value = true;
    try {
      Uri url = Uri.parse('$appBaseUrl/api/category/random'); 
      final response = await http.get(url);
      

      if(response.statusCode == 200) {
        categories.value = categoriesModelFromJson(response.body);
      } else if (response.statusCode == 400) {
        apiError.value = ApiError.fromJson(json.decode(response.body));
        error.value = null;
      } else {
        throw Exception('Failed to load categories');
      }

    } catch (e) {
      error.value = e as Exception;
    }
    finally {
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

  return FetchHook(
    data: categories.value,
    isLoading: isLoading.value,
    error: error.value,
    
    refetch: refetch,
  );
}