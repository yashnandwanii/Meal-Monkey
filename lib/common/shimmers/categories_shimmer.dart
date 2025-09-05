import 'package:flutter/material.dart';
import 'package:food_delivery_app/common/shimmers/shimmer_widget.dart';

class CategoriesShimmer extends StatelessWidget {
  const CategoriesShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 90, // slightly more than 70 to avoid tight layout
      padding: const EdgeInsets.only(left: 12, top: 10),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 5,
        itemBuilder: (context, index) {
          return const Padding(
            padding: EdgeInsets.only(right: 12), // add spacing
            child: ShimmerWidget(
              shimmerWidth: 70,
              shimmerHeight: 70,
              shimmerRadius: 12,
            ),
          );
        },
      ),
    );
  }
}
