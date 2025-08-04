import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food_delivery_app/common/background_container.dart';
import 'package:food_delivery_app/common/color_extension.dart';
import 'package:food_delivery_app/common/shimmers/foodlist_shimmer.dart';
import 'package:food_delivery_app/hooks/fetch_all_restaurents.dart';
import 'package:food_delivery_app/models/restaurents.dart';
import 'package:food_delivery_app/view/home/widgets/restaurent_tile.dart';

class AllNearbyRestaurents extends HookWidget {
  const AllNearbyRestaurents({super.key});

  @override
  Widget build(BuildContext context) {
    final hookResults = useFetchAllRestaurents('41007428');
    List<RestaurentsModel>? restaurents = hookResults.data;
    final isLoading = hookResults.isLoading;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Nearby Restaurants',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20.0,
          ),
        ),
        centerTitle: true,
        elevation: 0.3,
        backgroundColor: Tcolor.primary,
      ),
      body: BackgroundContainer(
        color: Colors.white,
        child: isLoading
            ? const FoodListShimmer()
            : Padding(
                padding: EdgeInsets.all(12.h),
                child: ListView(
                  scrollDirection: Axis.vertical,
                  children: List.generate(
                    restaurents!.length,
                    (index) {
                      RestaurentsModel restaurant = restaurents[index];
                      return RestaurentTile(
                        restaurant: restaurant,
                      );
                    },
                  ),
                ),
              ),
      ),
    );
  }
}
