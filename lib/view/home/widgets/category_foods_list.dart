import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food_delivery_app/common/shimmers/foodlist_shimmer.dart';
import 'package:food_delivery_app/hooks/fetch_category_foods.dart';
import 'package:food_delivery_app/models/foods.dart';
import 'package:food_delivery_app/view/home/widgets/food_tile.dart';

class CategoryFoodsList extends HookWidget {
  const CategoryFoodsList({super.key});

  @override
  Widget build(BuildContext context) {
    final hookResults = useFetchCategoryFoods('41007428');
    List<FoodItem>? foods = hookResults.data;
    final isLoading = hookResults.isLoading;
    return SizedBox(
      height: 300.h,
      width: double.infinity,
      child: isLoading
          ? const FoodListShimmer()
          : foods == null || foods.isEmpty
              ? Center(
                  child: Column(
                    children: [
                      Icon(
                        Icons.fastfood,
                        size: 50.sp,
                        color: Colors.grey.withValues(alpha: 0.5),
                      ),
                      SizedBox(height: 10.h),
                      Text(
                        'No Foods Available for this Category',
                        style: TextStyle(
                          fontSize: 16.sp,
                          color: Colors.grey.withValues(alpha: 0.5),
                        ),
                      ),
                    ],
                  ),
                )
              : Padding(
                  padding: EdgeInsets.all(12.h),
                  child: ListView(
                    children: List.generate(
                      foods.length,
                      (i) {
                        FoodItem food = foods[i];
                        return FoodTile(
                          color: Colors.lightBlue.withValues(alpha: 0.1),
                          food: food,
                        );
                      },
                    ),
                  ),
                ),
    );
  }
}
