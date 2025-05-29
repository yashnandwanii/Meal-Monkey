import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food_delivery_app/common/uidata.dart';
import 'package:food_delivery_app/view/home/widgets/restaurent_widget.dart';

class NearbyRestaurents extends StatelessWidget {
  const NearbyRestaurents({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 190.h,
      padding: EdgeInsets.only(left: 12.w, top: 10.h),
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: List.generate(restaurents.length, (i) {
          var restaurent = restaurents[i];
          return RestaurentWidget(
            image: restaurent['imageUrl'],
            logo: restaurent['logoUrl'],
            title: restaurent['title'],
            time: restaurent['time'],
            rating: restaurent['ratingCount'],
          );
        }),
      ),
    );
  }
}
