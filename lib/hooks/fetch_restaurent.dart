import 'package:flutter/widgets.dart';
import 'package:food_delivery_app/common/constants.dart';
import 'package:food_delivery_app/models/api_error.dart';
import 'package:food_delivery_app/models/hook_models/hook_restaurent.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:food_delivery_app/models/restaurents.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

FetchRestaurent usefetchRestaurent(String code) {
  final restaurents = useState<RestaurentsModel?>(null);
  final isLoading = useState<bool>(false);
  final error = useState<Exception?>(null);
  final apiError = useState<ApiError?>(null);

  Future<void> fetchData() async {
    isLoading.value = true;
    try {
      Uri url = Uri.parse('$appBaseUrl/api/restaurent/byId/$code');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        restaurents.value =
            RestaurentsModel.fromJson(json.decode(response.body));
      } else if (response.statusCode == 400) {
        apiError.value = ApiError.fromJson(json.decode(response.body));
        error.value = null;
      } else {
        throw Exception('Failed to load categories');
      }
    } catch (e) {
      debugPrint('Error fetching restaurents: $e');
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

  return FetchRestaurent(
    data: restaurents.value,
    isLoading: isLoading.value,
    error: error.value,
    refetch: refetch,
  );
}
