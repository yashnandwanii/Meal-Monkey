import 'package:flutter/material.dart';
import 'package:food_delivery_app/common/constants.dart';
import 'package:food_delivery_app/models/api_error.dart';
import 'package:food_delivery_app/models/reviews_response.dart';
import 'package:food_delivery_app/models/hook_models/hook_result.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

FetchHook useFetchUserReviews() {
  final box = GetStorage();
  final reviews = useState<List<ReviewResponse>?>(null);
  final isLoading = useState<bool>(false);
  final error = useState<Exception?>(null);
  final apiError = useState<ApiError?>(null);

  Future<void> fetchData() async {
    String? accessToken = box.read('token');
    if (accessToken == null) {
      reviews.value = [];
      return;
    }

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $accessToken',
    };

    isLoading.value = true;
    try {
      Uri url = Uri.parse('$appBaseUrl/api/reviews/user');
      debugPrint('Fetching reviews from: $url');

      final response = await http.get(url, headers: headers);

      debugPrint('Reviews response status: ${response.statusCode}');
      debugPrint('Reviews response body: ${response.body}');

      if (response.statusCode == 200) {
        reviews.value = reviewResponseFromJson(response.body);
        debugPrint('Successfully loaded ${reviews.value?.length} reviews');
      } else if (response.statusCode == 404) {
        debugPrint('No reviews found');
        reviews.value = [];
      } else if (response.statusCode == 400) {
        apiError.value = ApiError.fromJson(json.decode(response.body));
        error.value = null;
        debugPrint('API Error: ${apiError.value?.message}');
      } else {
        throw Exception('Failed to load reviews: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Exception in fetchUserReviews: $e');
      error.value = Exception(e.toString());
      apiError.value = null;
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
    data: reviews.value,
    isLoading: isLoading.value,
    error: error.value,
    refetch: refetch,
  );
}
