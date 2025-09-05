import 'package:flutter/material.dart';
import 'package:food_delivery_app/common/constants.dart';
import 'package:food_delivery_app/models/api_error.dart';
import 'package:food_delivery_app/models/order_response.dart';
import 'package:food_delivery_app/models/hook_models/hook_result.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

FetchHook useFetchUserOrders({String? orderStatus, String? paymentStatus}) {
  final box = GetStorage();
  final orders = useState<List<OrderResponse>?>(null);
  final isLoading = useState<bool>(false);
  final error = useState<Exception?>(null);
  final apiError = useState<ApiError?>(null);

  Future<void> fetchData() async {
    String? accessToken = box.read('token');
    if (accessToken == null) {
      orders.value = [];
      return;
    }

    Map<String, String> headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $accessToken',
    };

    isLoading.value = true;
    try {
      // Build query parameters
      Map<String, String> queryParams = {};
      if (orderStatus != null) queryParams['orderStatus'] = orderStatus;
      if (paymentStatus != null) queryParams['paymentStatus'] = paymentStatus;

      Uri url = Uri.parse('$appBaseUrl/api/order')
          .replace(queryParameters: queryParams);
      debugPrint('Fetching orders from: $url');

      final response = await http.get(url, headers: headers);

      debugPrint('Orders response status: ${response.statusCode}');
      debugPrint('Orders response body: ${response.body}');

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        if (responseData['success'] == true) {
          final ordersJson = responseData['orders'] as List;
          orders.value =
              ordersJson.map((order) => OrderResponse.fromJson(order)).toList();
          debugPrint('Successfully loaded ${orders.value?.length} orders');
        } else {
          orders.value = [];
        }
      } else if (response.statusCode == 404) {
        debugPrint('No orders found');
        orders.value = [];
      } else if (response.statusCode == 400) {
        apiError.value = ApiError.fromJson(json.decode(response.body));
        error.value = null;
        debugPrint('API Error: ${apiError.value?.message}');
      } else {
        throw Exception('Failed to load orders: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Exception in fetchUserOrders: $e');
      error.value = Exception(e.toString());
      apiError.value = null;
    } finally {
      isLoading.value = false;
    }
  }

  useEffect(() {
    fetchData();
    return null;
  }, [orderStatus, paymentStatus]);

  void refetch() {
    isLoading.value = true;
    fetchData();
  }

  return FetchHook(
    data: orders.value,
    isLoading: isLoading.value,
    error: error.value,
    refetch: refetch,
  );
}
