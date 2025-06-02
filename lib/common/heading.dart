import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:food_delivery_app/common/app_style.dart';
import 'package:food_delivery_app/common/color_extension.dart';
import 'package:food_delivery_app/common/reusable_text.dart';

class Heading extends StatelessWidget {
  const Heading({super.key, required this.title, this.onTap, this.moreButton});
  final String title;
  final VoidCallback? onTap;
  final bool? moreButton;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: EdgeInsets.only(top: 10.h),
            child: ReusableText(
              text: title,
              style: appBarTextStyle(16, Colors.black, FontWeight.bold),
            ),
          ),
          moreButton == null
              ? GestureDetector(
                  onTap: onTap,
                  child: Icon(
                    AntDesign.appstore1,
                    size: 20.sp,
                    color: Tcolor.primary,
                  ),
                )
              : const SizedBox.shrink()
        ],
      ),
    );
  }
}
