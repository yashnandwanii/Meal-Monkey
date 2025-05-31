import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food_delivery_app/common/shimmers/shimmer_widget.dart';

class NearbyShimmer extends StatelessWidget {
  const NearbyShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 75,
      padding: const EdgeInsets.only(left: 12, top: 10),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 5, // Number of shimmer items
        itemBuilder: (context, index) {
          return Column(
            children: [
              ShimmerWidget(
                shimmerWidth: MediaQuery.of(context).size.width * 0.8,
                shimmerHeight: 180.h,
                shimmerRadius: 12,
              ),
            ],
          );
        },
      ),
    );
  }
}
