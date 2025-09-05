import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food_delivery_app/common/background_container.dart';
import 'package:food_delivery_app/common/color_extension.dart';
import 'package:food_delivery_app/common/shimmers/foodlist_shimmer.dart';
import 'package:food_delivery_app/hooks/fetch_all_foods.dart';
import 'package:food_delivery_app/models/foods.dart';
import 'package:food_delivery_app/view/home/widgets/food_tile.dart';

class Recommendations extends HookWidget {
  const Recommendations({super.key});

  @override
  Widget build(BuildContext context) {
    final hookResults = useFetchAllFoods('41007428');
    List<FoodItem>? foods = hookResults.data;
    final isLoading = hookResults.isLoading;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Tcolor.primary,
        title: const Text(
          'Recommendations',
        ),
        centerTitle: true,
      ),
      body: BackgroundContainer(
        color: Colors.white,
        child: isLoading
            ? const FoodListShimmer()
            : foods == null || foods.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.restaurant_menu,
                          size: 64.r,
                          color: Tcolor.placeholder,
                        ),
                        SizedBox(height: 16.h),
                        Text(
                          'No recommendations available',
                          style: TextStyle(
                            fontSize: 16.sp,
                            color: Tcolor.placeholder,
                          ),
                        ),
                      ],
                    ),
                  )
                : Padding(
                    padding: EdgeInsets.all(12.h),
                    child: ListView(
                      children: List.generate(foods.length, (i) {
                        FoodItem food = foods[i];
                        return FoodTile(food: food);
                      }),
                    ),
                  ),
      ),
    );
  }
}
