import 'package:flutter/material.dart';
import 'package:food_delivery_app/common/constants.dart';
import 'package:food_delivery_app/models/api_error.dart';
import 'package:food_delivery_app/models/favorites_response.dart';
import 'package:food_delivery_app/models/hook_models/hook_result.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

FetchHook useFetchUserFavorites() {
  final box = GetStorage();
  final favorites = useState<List<FavoriteResponse>?>(null);
  final isLoading = useState<bool>(false);
  final error = useState<Exception?>(null);
  final apiError = useState<ApiError?>(null);

  Future<void> fetchData() async {
    String? accessToken = box.read('token');
    if (accessToken == null) {
      favorites.value = [];
      return;
    }

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $accessToken',
    };

    isLoading.value = true;
    try {
      Uri url = Uri.parse('$appBaseUrl/api/favorites');
      debugPrint('Fetching favorites from: $url');

      final response = await http.get(url, headers: headers);

      debugPrint('Favorites response status: ${response.statusCode}');
      debugPrint('Favorites response body: ${response.body}');

      if (response.statusCode == 200) {
        favorites.value = favoriteResponseFromJson(response.body);
        debugPrint('Successfully loaded ${favorites.value?.length} favorites');
      } else if (response.statusCode == 404) {
        debugPrint('No favorites found');
        favorites.value = [];
      } else if (response.statusCode == 400) {
        apiError.value = ApiError.fromJson(json.decode(response.body));
        error.value = null;
        debugPrint('API Error: ${apiError.value?.message}');
      } else {
        throw Exception('Failed to load favorites: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Exception in fetchUserFavorites: $e');
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
    data: favorites.value,
    isLoading: isLoading.value,
    error: error.value,
    refetch: refetch,
  );
}
