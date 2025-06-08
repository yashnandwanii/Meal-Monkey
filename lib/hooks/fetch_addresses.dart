import 'package:food_delivery_app/common/constants.dart';
import 'package:food_delivery_app/models/addresses_response.dart';
import 'package:food_delivery_app/models/api_error.dart';
import 'package:food_delivery_app/models/hook_models/hook_result.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

FetchHook useFetchAllAddresses() {
  final box = GetStorage();
  final addresses = useState<List<AddressResponse>?>(null);
  final isLoading = useState<bool>(false);
  final error = useState<Exception?>(null);
  final apiError = useState<ApiError?>(null);

  Future<void> fetchData() async {
    String? accessToken = box.read('token');
    if (accessToken == null) {
      error.value = Exception('User is not authenticated');
      isLoading.value = false;
      return;
    }
    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $accessToken',
    };
    isLoading.value = true;
    try {
      Uri url = Uri.parse('$appBaseUrl/api/address/all');
      final response = await http.get(url, headers: headers);

      if (response.statusCode == 200) {
        addresses.value = addressResponseFromJson(response.body);
      } else if (response.statusCode == 400) {
        apiError.value = ApiError.fromJson(json.decode(response.body));
        error.value = null;
      } else {
        throw Exception('Failed to load categories');
      }
    } catch (e) {
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
    data: addresses.value,
    isLoading: isLoading.value,
    error: error.value,
    refetch: refetch,
  );
}
