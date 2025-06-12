import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:food_delivery_app/common/app_style.dart';
import 'package:food_delivery_app/common/reusable_text.dart';
import 'package:food_delivery_app/view/auth/login/welcome_view.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class ProfileAppbar extends StatelessWidget {
  const ProfileAppbar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white54,
      elevation: 0,
      leading: GestureDetector(
        onTap: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                titleTextStyle: appBarTextStyle(
                  18,
                  Colors.black,
                  FontWeight.bold,
                ),
                contentTextStyle: appBarTextStyle(
                  16,
                  Colors.black54,
                  FontWeight.normal,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.r),
                ),
                backgroundColor: Colors.white,
                iconColor: Colors.black,
                actionsAlignment: MainAxisAlignment.center,
                actionsPadding: EdgeInsets.symmetric(vertical: 10.h),
                title: const Text("Logout"),
                content: const Text("Are you sure you want to logout?"),
                actions: [
                  TextButton(
                    onPressed: () {
                      Get.back();
                    },
                    child: const Text(
                      "Cancel",
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      GetStorage().remove('token');
                      Get.offAll(() => const WelcomeView());
                    },
                    child: const Text(
                      "Logout",
                      style: TextStyle(color: Colors.green),
                    ),
                  ),
                ],
              );
            },
          );
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
