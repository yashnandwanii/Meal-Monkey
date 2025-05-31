import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food_delivery_app/common/background_container.dart';
import 'package:food_delivery_app/common/reusable_text.dart';
import 'package:food_delivery_app/common/shimmers/foodlist_shimmer.dart';
import 'package:food_delivery_app/hooks/fetch_all_categories.dart';
import 'package:food_delivery_app/models/categories.dart';
import 'package:food_delivery_app/view/category/widgets/category_tile.dart';

class AllCategories extends HookWidget {
  const AllCategories({super.key});

  @override
  Widget build(BuildContext context) {
    final hookResult = useFetchAllCategories();
    List<CategoriesModel>? categories = hookResult.data ?? [];
    final isLoading = hookResult.isLoading;
    return Scaffold(
      appBar: AppBar(
        title: const ReusableText(text: 'All Categories'),
        elevation: 0,
        backgroundColor: Colors.white54,
      ),
      body: BackgroundContainer(
        color: Colors.white,
        child: Container(
          padding: EdgeInsets.only(left: 12.w, top: 10.h),
          height: MediaQuery.of(context).size.height,
          child: isLoading
              ? const FoodListShimmer()
              : ListView.builder(
                  itemCount: categories!.length,
                  itemBuilder: (context, index) {
                    CategoriesModel category = categories[index];
                    return CategoryTile(category: category);
                  },
                ),
        ),
      ),
    );
  }
}
