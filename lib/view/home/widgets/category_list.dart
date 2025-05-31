import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food_delivery_app/common/shimmers/categories_shimmer.dart';
import 'package:food_delivery_app/common_widgets/category_widget.dart';
import 'package:food_delivery_app/hooks/fetch_categories.dart';
import 'package:food_delivery_app/models/categories.dart';

class CategoryList extends HookWidget {
  const CategoryList({super.key});

  @override
  Widget build(BuildContext context) {
    final hookResult = useFetchCategories();
    List<CategoriesModel>? categories = hookResult.data ?? [];

    final isLoading = hookResult.isLoading;
    //final error = hookResult.error;
    return Container(
      height: 80.h,
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.only(left: 12.w, top: 10.h),
      child: isLoading == true
          ? const CategoriesShimmer()
          : ListView(
              scrollDirection: Axis.horizontal,
              children: List.generate(
                categories!.length,
                (i) {
                  var category = categories[i];
                  return CategoryWidget(category: category);
                },
              ),
            ),
    );
  }
}
