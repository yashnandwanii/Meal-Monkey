import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food_delivery_app/common/color_extension.dart';
import 'package:food_delivery_app/common/reusable_text.dart';

class CustomButton extends StatelessWidget {
  const CustomButton(
      {super.key,
      this.ontap,
      this.color,
      this.width,
      this.height,
      this.radius,
      required this.text});
  final VoidCallback? ontap;
  final Color? color;
  final double? width;
  final double? height;
  final double? radius;
  final String text;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ontap,
      child: Container(
        width: width ?? MediaQuery.of(context).size.width,
        height: height ?? 28.h,
        decoration: BoxDecoration(
          color: color ?? Tcolor.primary,
          borderRadius: BorderRadius.circular(radius ?? 9.r),
        ),
        child: Center(
          child: ReusableText(
            text: text,
            style: TextStyle(
              fontSize: 14.sp,
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}
