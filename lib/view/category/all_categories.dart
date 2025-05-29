import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food_delivery_app/common/background_container.dart';
import 'package:food_delivery_app/common/reusable_text.dart';
import 'package:food_delivery_app/common/uidata.dart';
import 'package:food_delivery_app/view/category/category_page.dart';
import 'package:get/get.dart';

class AllCategories extends StatelessWidget {
  const AllCategories({super.key});

  @override
  Widget build(BuildContext context) {
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
          child: ListView(
            scrollDirection: Axis.vertical,
            children: List.generate(
              categories.length,
              (i) {
                var category = categories[i];
                return CategoryTile(category: category);
              },
            ),
          ),
        ),
      ),
    );
  }
}

class CategoryTile extends StatelessWidget {
  const CategoryTile({
    super.key,
    required this.category,
  });

  final dynamic category;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: (){
        Get.to(()=> const CategoryPage(),
        transition: Transition.rightToLeftWithFade,
        duration: const Duration(milliseconds: 900),
        );
      },
      leading: CircleAvatar(
        radius: 18.r,
        backgroundColor: Colors.white54,
        child: Image.network(
          category['imageUrl'],
          fit: BoxFit.contain,
        ),
      ),
      title: ReusableText(
        text: category['title'],
      ),
      contentPadding:
          EdgeInsets.symmetric(vertical: 8.h, horizontal: 12.w),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.r),
      ),
      trailing: Icon(
        Icons.arrow_back,
        color: Colors.grey,
        size: 15.r,
      ),
    );
  }
}
