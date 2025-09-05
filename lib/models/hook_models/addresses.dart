import 'package:flutter/material.dart';
import 'package:food_delivery_app/models/addresses_response.dart';

class FetchAddresses {
  final List<AddressResponse>? data;
  final Exception? error;
  final bool isLoading;
  final VoidCallback? refetch;

  FetchAddresses({
    required this.data,
    required this.error,
    required this.isLoading,
    required this.refetch,
  });
}
