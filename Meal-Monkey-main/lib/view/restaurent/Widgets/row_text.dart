import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food_delivery_app/common/app_style.dart';

class RowText extends StatelessWidget {
  const RowText({
    super.key,
    required this.first,
    required this.second,
  });
  final String first;
  final String second;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          first,
          style: appBarTextStyle(
            10.sp,
            Colors.grey,
            FontWeight.w500,
          ),
        ),
        Text(
          second,
          style: appBarTextStyle(
            10.sp,
            Colors.black,
            FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
