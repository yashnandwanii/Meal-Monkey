import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerWidget extends StatelessWidget {
  const ShimmerWidget({
    super.key,
    required this.shimmerWidth,
    required this.shimmerHeight,
    required this.shimmerRadius,
  });

  final double shimmerWidth;
  final double shimmerHeight;
  final double shimmerRadius;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: shimmerWidth,
      height: shimmerHeight,
      padding: const EdgeInsets.only(right: 12, top: 8),
      child: _buildShimmerEffect(
        height: shimmerHeight - 20,
        width: shimmerWidth - 15,
        radius: shimmerRadius - 5,
      ),
    );
  }

  Widget _buildShimmerEffect({
    required double width,
    required double height,
    required double radius,
  }) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Colors.white24,
          borderRadius: BorderRadius.circular(radius),
        ),
      ),
    );
  }
}
