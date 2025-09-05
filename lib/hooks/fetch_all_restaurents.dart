import 'package:food_delivery_app/common/constants.dart';
import 'package:food_delivery_app/models/api_error.dart';
import 'package:food_delivery_app/models/hook_models/hook_result.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:food_delivery_app/models/restaurents.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

FetchHook useFetchAllRestaurents(String code) {
  final restaurents = useState<List<RestaurentsModel>?>(null);
  final isLoading = useState<bool>(false);
  final error = useState<Exception?>(null);
  final apiError = useState<ApiError?>(null);

  Future<void> fetchData() async {
    isLoading.value = true;
    try {
      Uri url = Uri.parse('$appBaseUrl/api/restaurent/$code');
      //debugPrint('Fetching restaurants from: $url');

      final response = await http.get(url);
      // debugPrint('Restaurant response status: ${response.statusCode}');
      //debugPrint('Restaurant response body: ${response.body}');

      if (response.statusCode == 200) {
        restaurents.value = restaurentsModelFromJson(response.body);
        // debugPrint(
        //     'Successfully loaded ${restaurents.value?.length} restaurants');
      } else if (response.statusCode == 404) {
        //debugPrint('No restaurants found for code: $code');
        restaurents.value = [];
      } else if (response.statusCode == 400) {
        apiError.value = ApiError.fromJson(json.decode(response.body));
        error.value = null;
        //debugPrint('API Error: ${apiError.value?.message}');
      } else {
        //debugPrint('Error: ${response.statusCode}');
        error.value =
            Exception('Failed to load restaurants: ${response.statusCode}');
      }
    } catch (e) {
      //debugPrint('Exception in fetchAllRestaurents: $e');
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

  return FetchHook(
    data: restaurents.value,
    isLoading: isLoading.value,
    error: error.value,
    refetch: refetch,
  );
}
