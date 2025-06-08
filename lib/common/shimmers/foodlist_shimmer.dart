import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food_delivery_app/common/shimmers/shimmer_widget.dart';


class FoodListShimmer extends StatelessWidget {
  const FoodListShimmer({super.key, this.scrollDirection = Axis.horizontal});
  final Axis scrollDirection;

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;

    return SizedBox(
      height: 192.h,
      width: width,
      child: ListView.builder(
        scrollDirection: scrollDirection,
        itemCount: 5, // Shimmer placeholders, adjust as needed
        padding: EdgeInsets.only(left: 12.w),
        itemBuilder: (context, index) {
          return Padding(
            padding: EdgeInsets.only(right: 12.w),
            child: Container(
              width: width * 0.75,
              height: 192.h, // This is your card height
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.all(8.w),
                    child: ShimmerWidget(
                      shimmerWidth: width * 0.8,
                      shimmerHeight: 112.h,
                      shimmerRadius: 12,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
