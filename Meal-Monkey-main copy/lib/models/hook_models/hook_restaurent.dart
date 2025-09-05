import 'package:flutter/material.dart';
import 'package:food_delivery_app/models/restaurents.dart';

class FetchRestaurent {
  final RestaurentsModel? data;
  final Exception? error;
  final bool isLoading;
  final VoidCallback? refetch;

  FetchRestaurent({
    required this.data,
    required this.error,
    required this.isLoading,
    required this.refetch,
  });
}
