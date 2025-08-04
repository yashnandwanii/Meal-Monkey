import 'package:flutter/material.dart';

class FetchHook {
  final dynamic data;
  final Exception? error;
  final bool isLoading;
  final VoidCallback? refetch;

  FetchHook({
    required this.data,
    required this.error,
    required this.isLoading,
    required this.refetch,
  });
}
