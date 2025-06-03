import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:food_delivery_app/models/restaurents.dart';

class RestaurentPage extends StatefulHookWidget {
  const RestaurentPage({super.key, required this.restaurent});
  final RestaurentsModel? restaurent;

  @override
  State<RestaurentPage> createState() => _RestaurentPageState();
}

class _RestaurentPageState extends State<RestaurentPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Restaurant Page'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'Welcome to the Restaurant Page',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
