import 'package:flutter/cupertino.dart';
import 'package:food_delivery_app/common/constants.dart';
import 'package:food_delivery_app/models/addresses_response.dart';
import 'package:food_delivery_app/models/api_error.dart';
import 'package:food_delivery_app/models/hook_models/hook_result.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

FetchHook useFetchDefaultAddress() {
  final box = GetStorage();
  final addresses = useState<List<AddressResponse>?>(null);
  final isLoading = useState<bool>(false);
  final error = useState<Exception?>(null);
  final apiError = useState<ApiError?>(null);

  Future<void> fetchData() async {
    String? accessToken = box.read('token');
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $accessToken',
    };
    isLoading.value = true;
    try {
      Uri url = Uri.parse('$appBaseUrl/api/address/default');
      final response = await http.get(url, headers: headers);
      debugPrint('Response status: ${response.statusCode}');
      debugPrint('Response body: ${response.body}');

      if (response.statusCode == 200) {
        var data = response.body;
        var decoded = jsonDecode(data);
        addresses.value = addressResponseFromJson(decoded);
      } else if (response.statusCode == 400) {
        apiError.value = ApiError.fromJson(json.decode(response.body));
        error.value = null;
      } else {
        throw Exception('Failed to load categories');
      }
    } catch (e) {
      if (e is Exception) {
        error.value = e;
      } else {
        error.value = Exception('Unexpected error: $e');
      }
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
    data: addresses.value,
    isLoading: isLoading.value,
    error: error.value,
    refetch: refetch,
  );
}
