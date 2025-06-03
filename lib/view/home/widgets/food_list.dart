import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food_delivery_app/hooks/fetch_foods.dart';
import 'package:food_delivery_app/models/foods.dart';
import 'package:food_delivery_app/view/food/food_page.dart';
import 'package:food_delivery_app/view/home/widgets/food_widget.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

class FoodList extends HookWidget {
  const FoodList({super.key});

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    final hookResults = useFetchFoods('41007428');
    List<FoodItem>? foods = hookResults.data;
    final isLoading = hookResults.isLoading;

    return Container(
      height: 184.h,
      padding: const EdgeInsets.only(left: 12, top: 10),
      child: isLoading
          ? Shimmer.fromColors(
              baseColor: Colors.red,
              highlightColor: Colors.yellow,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 5,
                itemBuilder: (context, index) {
                  return Container(
                    width: width * 0.75,
                    height: 184.h,
                    margin: const EdgeInsets.only(left: 12, top: 10),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                  );
                },
              ),
            )
          : ListView(
              scrollDirection: Axis.horizontal,
              children: List.generate(
                foods!.length,
                (i) {
                  var food = foods[i];
                  //print(food);
                  return FoodWidget(
                    image: food.imageUrl[0],
                    time: food.time,
                    price: food.price.toString(),
                    title: food.title,
                    ontap: () {
                      Get.to(
                        () => FoodPage(food: food),
                        transition: Transition.rightToLeft,
                        duration: const Duration(milliseconds: 500),
                      );
                    },
                  );
                },
              ),
            ),
    );
  }
}
