import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:food_delivery_app/common/app_style.dart';
import 'package:food_delivery_app/common/reusable_text.dart';

class ProfileAppbar extends StatelessWidget {
  const ProfileAppbar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white54,
      elevation: 0,
      leading: GestureDetector(
        onTap: () {
          // logout Function
        },
        child: Icon(
          AntDesign.logout,
          color: Colors.black,
          size: 18.h,
        ),
      ),
      actions: [
        GestureDetector(
          onTap: () {},
          child: Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: Row(
              children: [
                Image.asset(
                  "assets/iimg/india-flag-icon.png",
                  width: 15.w,
                  height: 25.h,
                ),
                SizedBox(width: 5.w),
                Container(
                  width: 1.w,
                  height: 15.h,
                  color: Colors.grey.withValues(alpha: 0.5),
                ),
                SizedBox(width: 5.w),
                ReusableText(
                  text: "India",
                  style: appBarTextStyle(
                    16,
                    Colors.black,
                    FontWeight.bold,
                  ),
                ),
                SizedBox(width: 5.w),
                GestureDetector(
                  onTap: () {
                    // Navigate to help page
                  },
                  child: Padding(
                    padding: EdgeInsets.only(bottom: 4.h),
                    child: Icon(
                      SimpleLineIcons.settings,
                      size: 16.h,
                    ),
                  ),
                )
              ],
            ),
          ),
        )
      ],
    );
  }
}
