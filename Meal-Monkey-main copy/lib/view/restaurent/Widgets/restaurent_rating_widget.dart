import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food_delivery_app/common/color_extension.dart';
import 'package:food_delivery_app/common/custom_button.dart';
import 'package:food_delivery_app/view/restaurent/rating_page.dart';
import 'package:food_delivery_app/view/restaurent/restaurent_page.dart';
import 'package:get/get.dart';

class RestaurentRatingWidget extends StatelessWidget {
  const RestaurentRatingWidget({
    super.key,
    required this.widget,
  });

  final RestaurentPage widget;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w),
      width: MediaQuery.of(context).size.width,
      height: 40.h,
      decoration: BoxDecoration(
        color: Tcolor.primary.withValues(alpha: 0.6),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10.r),
          topRight: Radius.circular(10.r),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          RatingBarIndicator(
            itemBuilder: (context, index) {
              return const Icon(
                Icons.star,
                color: Colors.amber,
              );
            },
            itemCount: 5,
            rating: widget.restaurent?.rating.toDouble() ?? 0.0,
          ),
          CustomButton(
            text: 'Rate Restaurant',
            color: Colors.amber,
            width: MediaQuery.of(context).size.width / 3,
            ontap: () {
              Get.to(
                const RatingPage(),
              );
            },
          ),
        ],
      ),
    );
  }
}
