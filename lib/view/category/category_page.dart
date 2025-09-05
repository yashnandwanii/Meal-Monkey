import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food_delivery_app/common/app_style.dart';
import 'package:food_delivery_app/common/background_container.dart';
import 'package:food_delivery_app/common/reusable_text.dart';
import 'package:food_delivery_app/common/shimmers/foodlist_shimmer.dart';
import 'package:food_delivery_app/controllers/category_controller.dart';
import 'package:food_delivery_app/hooks/fetch_category_foods.dart';
import 'package:food_delivery_app/models/foods.dart';
import 'package:food_delivery_app/view/home/widgets/food_tile.dart';
import 'package:get/get.dart';

class CategoryPage extends HookWidget {
  const CategoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(CategoryController());
    final hookResults = useFetchCategoryFoods();
    List<FoodItem>? foods = hookResults.data;
    final isLoading = hookResults.isLoading;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: ReusableText(
          text: '${controller.titleValue} Category',
          style: appBarTextStyle(
            13,
            Colors.black.withValues(alpha: 0.8),
            FontWeight.w500,
          ),
        ),
        leading: IconButton(
          onPressed: () {
            controller.updateCategory = '';
            controller.updateTitle = '';
            Get.back();
          },
          icon: Icon(
            Icons.arrow_back_ios_new,
            color: Colors.black.withValues(alpha: 0.8),
            size: 20.r,
          ),
        ),
      ),
      body: BackgroundContainer(
        color: Colors.white,
        child: SizedBox(
          //padding: EdgeInsets.only(left: 12.w, top: 10.h),
          height: MediaQuery.of(context).size.height,
          child: isLoading
              ? const FoodListShimmer()
              : foods!.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
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
                              food: food,
                            );
                          },
                        ),
                      ),
                    ),
        ),
      ),
    );
  }
}
