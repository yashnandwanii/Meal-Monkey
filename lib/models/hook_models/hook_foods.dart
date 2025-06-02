import 'package:flutter/material.dart';
import 'package:food_delivery_app/models/foods.dart';

class FetchFoods {
  final List<FoodItem>? data;
  final Exception? error;
  final bool isLoading;
  final VoidCallback? refetch;

  FetchFoods({
    required this.data,
    required this.error,
    required this.isLoading,
    required this.refetch,
  });
}
