import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food_delivery_app/common/app_style.dart';

class CustomSearchField extends StatelessWidget {
  const CustomSearchField({
    super.key,
    this.controller,
    this.onEditingComplete,
    this.keyboardType,
    this.obscureText,
    this.suffixIcon,
    this.prefixIcon,
    this.validator,
    this.hintText,
  });

  final TextEditingController? controller;
  final VoidCallback? onEditingComplete;
  final TextInputType? keyboardType;
  final bool? obscureText;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final String? hintText;
  final String? Function(String?)? validator;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(6.h),
      padding: EdgeInsets.only(left: 6.h),
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.grey.withValues(alpha: 0.8),
          width: 1.w,
        ),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Center(
        child: TextFormField(
          controller: controller,
          onEditingComplete: onEditingComplete,
          keyboardType: keyboardType,
          style: appBarTextStyle(11, Colors.black54, FontWeight.normal),
          validator: validator,
          obscureText: obscureText ?? false,
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: hintText,
            hintStyle: TextStyle(
              fontSize: 11.sp,
              color: Colors.black.withValues(alpha: 0.7),
            ),
            suffixIcon: suffixIcon,
            prefixIcon: prefixIcon,
          ),
        ),
      ),
    );
  }
}
