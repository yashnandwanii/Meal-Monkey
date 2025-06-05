import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:food_delivery_app/common/shimmers/foodlist_shimmer.dart';
import 'package:food_delivery_app/hooks/fetch_foods.dart';
import 'package:food_delivery_app/models/foods.dart';
import 'package:food_delivery_app/view/home/widgets/food_tile.dart';

class XploreWidget extends HookWidget {
  const XploreWidget({super.key, required this.code});
  final String? code;

  @override
  Widget build(BuildContext context) {
    if (code == null) {
      return const Center(child: Text("Invalid code provided."));
    }

    final hookResult = useFetchFoods(code!);
    final foods = hookResult.data;
    final isLoading = hookResult.isLoading;
    final error = hookResult.error;

    return Scaffold(
      backgroundColor: Colors.white54,
      body: isLoading
          ? const FoodListShimmer()
          : error != null
              ? Center(
                  child: Text(
                    "Failed to load menu.\n${error.toString()}",
                    style: const TextStyle(color: Colors.red),
                    textAlign: TextAlign.center,
                  ),
                )
              : foods == null || foods.isEmpty
                  ? const Center(child: Text("No menu items available."))
                  : SizedBox(
                      height: MediaQuery.of(context).size.height,
                      child: ListView(
                        padding: EdgeInsets.zero,
                        children: List.generate(
                          foods.length,
                          (i) {
                            final FoodItem food = foods[i];
                            return FoodTile(
                              food: food,
                            );
                          },
                        ),
                      ),
                    ),
    );
  }
}
