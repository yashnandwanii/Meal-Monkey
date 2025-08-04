import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food_delivery_app/controllers/search_controller.dart';
import 'package:food_delivery_app/models/foods.dart';
import 'package:food_delivery_app/view/home/widgets/food_tile.dart';
import 'package:get/get.dart';

class SearchResults extends StatelessWidget {
  const SearchResults({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(SearchFoodController());
    return Container(
      padding: EdgeInsets.fromLTRB(12.w, 10.h, 12.h, 0),
      height: MediaQuery.of(context).size.height,
      child: ListView.builder(
        itemCount: controller.searchResults?.length ?? 0,
        itemBuilder: (context, i) {
          FoodItem food = controller.searchResults![i];
          return FoodTile(food: food);
        },
      ),
    );
  }
}
