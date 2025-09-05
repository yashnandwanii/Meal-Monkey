// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food_delivery_app/controllers/category_controller.dart';
import 'package:food_delivery_app/models/categories.dart';
import 'package:food_delivery_app/view/category/all_categories.dart';
import 'package:get/get.dart';

class CategoryWidget extends StatelessWidget {
  CategoryWidget({
    super.key,
    required this.category,
  });

  CategoriesModel category;

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(CategoryController());
    return GestureDetector(
      onTap: () {
        debugPrint(
            'Category tapped: ${category.title} (id: ${category.id}, value: ${category.value})');
        if (controller.categoryValue != category.value) {
          controller.updateCategory = category.value;
          controller.updateTitle = category.title;
          debugPrint('Category updated to: ${category.value}');
        } else if (category.value == 'more') {
          Get.to(
            () => const AllCategories(),
            transition: Transition.rightToLeft,
            duration: const Duration(milliseconds: 500),
          );
        } else {
          controller.updateCategory = '';
          controller.updateTitle = '';
          debugPrint('Category cleared');
        }
      },
      child: Obx(
        () => Container(
          margin: EdgeInsets.only(right: 5.w),
          padding: EdgeInsets.only(top: 4.h),
          width: MediaQuery.of(context).size.width * 0.19,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.r),
            border: Border.all(
              color: controller.categoryValue == category.value
                  ? Colors.orange
                  : const Color(0xFFBDBDBD),
              width: 1.w,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.network(
                category.imageUrl,
                height: 35.h,
                fit: BoxFit.cover,
              ),
              SizedBox(height: 4.h),
              Text(
                category.title,
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
