import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food_delivery_app/common/shimmers/shimmer_widget.dart';

class FoodListShimmer extends StatelessWidget {
  const FoodListShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 184.h,
      width: MediaQuery.of(context).size.width,
      child: ListView.builder(
        scrollDirection: Axis.vertical,
        itemCount: 10,
        padding: EdgeInsets.zero,
        itemBuilder: (context, index) {
          return Padding(
            padding: EdgeInsets.only(bottom: 10.h),
            child: ShimmerWidget(
              shimmerWidth: MediaQuery.of(context).size.width,
              shimmerHeight: 70.h,
              shimmerRadius: 12,
            ),
          );
        },
      ),
    );
  }
}
