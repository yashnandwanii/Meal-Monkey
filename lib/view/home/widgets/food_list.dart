import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food_delivery_app/common/uidata.dart';
import 'package:food_delivery_app/view/home/widgets/food_widget.dart';

class FoodList extends StatelessWidget {
  const FoodList({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 184.h,
      padding: const EdgeInsets.only(left: 12, top: 10),
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: List.generate(
          foods.length,
          (i) {
            var food = foods[i];
            return FoodWidget(
              image: food['image'],
              time: food['time'],
              price: food['price'],
              title: food['title'],
              ontap: () {
                print('Tapped on ${food['title']}');
              },
            );
          },
        ),
      ),
    );
  }
}
