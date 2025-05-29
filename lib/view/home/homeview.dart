import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food_delivery_app/common/custom_container.dart';
import 'package:food_delivery_app/common/heading.dart';
import 'package:food_delivery_app/common_widgets/category_list.dart';
import 'package:food_delivery_app/common_widgets/custom_appbar.dart';
import 'package:food_delivery_app/common_widgets/popular_restaurent_row.dart';
import 'package:food_delivery_app/common_widgets/recent_item_row.dart';
import 'package:food_delivery_app/view/home/all_fastest_foods.dart';
import 'package:food_delivery_app/view/home/all_nearby_restaurents.dart';
import 'package:food_delivery_app/view/home/recommendations.dart';
import 'package:food_delivery_app/view/home/widgets/nearby_restaurents.dart';
import 'package:get/get.dart';

class Homeview extends StatefulWidget {
  const Homeview({super.key});
  @override
  State<Homeview> createState() => _HomeviewState();
}

class _HomeviewState extends State<Homeview> {
  TextEditingController txtController = TextEditingController();
  List popArr = [
    {
      'image': 'assets/iimg/res_1.png',
      'name': 'Minute by Tuk Tuk',
      'rate': '4.9',
      'rating': '124',
      'type': 'Cafa',
      "food_type": "Western Food"
    },
    {
      'image': 'assets/iimg/res_2.png',
      'name': 'Cafe de Noir',
      'rate': '4.9',
      'rating': '124',
      'type': 'Cafa',
      "food_type": "Western Food"
    },
    {
      'image': 'assets/iimg/res_3.png',
      'name': 'Bakes by Tella',
      'rate': '4.9',
      'rating': '124',
      'type': 'Cafa',
      "food_type": "Western Food"
    },
  ];

  List recentArr = [
    {
      'image': 'assets/iimg/item_1.png',
      'name': 'Mulberry Pizza by Josh',
      'rate': '4.9',
      'rating': '124',
      'type': 'Cafa',
      "food_type": "Western Food"
    },
    {
      'image': 'assets/iimg/item_2.png',
      'name': 'Barita',
      'rate': '4.9',
      'rating': '124',
      'type': 'Cafa',
      "food_type": "Western Food"
    },
    {
      'image': 'assets/iimg/item_3.png',
      'name': 'Pizza Rush Hour',
      'rate': '4.9',
      'rating': '124',
      'type': 'Cafa',
      "food_type": "Western Food"
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(130.h),
        child: const CustomAppbar(),
      ),
      body: SafeArea(
        child: CustomContainer(
          containerContent: Column(
            children: [
              const CategoryList(),
              Heading(
                title: 'Nearby Restaurants',
                onTap: () {
                  Get.to(
                    () => const AllNearbyRestaurents(),
                    transition: Transition.rightToLeft,
                    duration: const Duration(milliseconds: 500),
                  );
                },
              ),
              const NearbyRestaurents(),
              Heading(
                title: 'Try Something New',
                onTap: () {
                  Get.to(
                    () => const Recommendations(),
                    transition: Transition.rightToLeft,
                    duration: const Duration(milliseconds: 500),
                  );
                },
              ),
              ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                padding: EdgeInsets.zero,
                itemCount: popArr.length,
                itemBuilder: ((context, index) {
                  var pObj = popArr[index] as Map? ?? {};
                  return PopularRestaurentRow(
                    pObj: pObj,
                    onTap: () {},
                  );
                }),
              ),
              Heading(
                title: 'Food Closer to you',
                onTap: () {
                  Get.to(
                    () => const AllFastestFoods(),
                    transition: Transition.rightToLeft,
                    duration: const Duration(milliseconds: 500),
                  );
                },
              ),
              ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                padding: const EdgeInsets.symmetric(horizontal: 15),
                itemCount: recentArr.length,
                itemBuilder: ((context, index) {
                  var rObj = recentArr[index] as Map? ?? {};
                  return RecentItemRow(
                    rObj: rObj,
                    onTap: () {},
                  );
                }),
              )
            ],
          ),
        ),
      ),
    );
  }
}
