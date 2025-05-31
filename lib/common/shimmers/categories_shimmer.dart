import 'package:flutter/material.dart';
import 'package:food_delivery_app/common/shimmers/shimmer_widget.dart';

class CategoriesShimmer extends StatelessWidget {
  const CategoriesShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 75,
      padding: const EdgeInsets.only(left: 12, top: 10),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 5, // Number of shimmer items
        itemBuilder: (context, index) {
          return const Column(
            children: [
              ShimmerWidget(
                shimmerWidth: 70, // Width of each shimmer item
                shimmerHeight: 70, // Height of each shimmer item
                shimmerRadius: 12, // Border radius for the shimmer item
              ),
            ],
          );
        },
      ),
    );
  }
}
