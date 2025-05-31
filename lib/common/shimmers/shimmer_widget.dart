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

  static const Color primaryColor = Color(0xffFC6011);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: shimmerWidth,
      height: shimmerHeight,
      margin: const EdgeInsets.only(right: 12, top: 8),
      child: _buildShimmerEffect(
        width: shimmerWidth,
        height: shimmerHeight,
        radius: shimmerRadius,
      ),
    );
  }

  Widget _buildShimmerEffect({
    required double width,
    required double height,
    required double radius,
  }) {
    return Shimmer.fromColors(
      baseColor: primaryColor.withOpacity(0.3), // Slightly transparent base
      highlightColor: primaryColor.withOpacity(0.7), // Stronger highlight
      period: const Duration(seconds: 2), // Slower shimmer for elegance
      direction: ShimmerDirection.ltr, // Horizontal shimmer direction
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.2), // subtle background
          borderRadius: BorderRadius.circular(radius),
          gradient: LinearGradient(
            colors: [
              Colors.white.withOpacity(0.15),
              primaryColor.withOpacity(0.3),
              Colors.white.withOpacity(0.15),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
      ),
    );
  }
}
