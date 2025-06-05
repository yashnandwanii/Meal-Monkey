import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:food_delivery_app/common/custom_button.dart';
import 'package:food_delivery_app/common/custom_container.dart';
import 'package:food_delivery_app/view/profile/widget/profile_appbar.dart';
import 'package:food_delivery_app/view/profile/widget/profile_tile_widget.dart';
import 'package:food_delivery_app/view/profile/widget/user_info_widget.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(40.h),
        child: const ProfileAppbar(),
      ),
      body: SafeArea(
        child: CustomContainer(
          containerContent: Column(
            children: [
              const UserInfoWidget(),
              SizedBox(
                height: 15.h,
              ),
              Container(
                width: double.infinity,
                height: 175.h,
                decoration: BoxDecoration(
                  color: Colors.grey.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: ListView(
                  padding: EdgeInsets.zero,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    ProfileTileWidget(
                      title: 'My Orders',
                      icon: Ionicons.fast_food_outline,
                      onTap: () {},
                    ),
                    ProfileTileWidget(
                      title: 'My Favorites',
                      icon: Ionicons.heart_outline,
                      onTap: () {},
                    ),
                    ProfileTileWidget(
                      title: 'Reviews',
                      icon: Ionicons.chatbubble_outline,
                      onTap: () {},
                    ),
                    ProfileTileWidget(
                      title: 'Coupons',
                      icon: MaterialCommunityIcons.tag_outline,
                      onTap: () {},
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 15.h,
              ),
              Container(
                width: double.infinity,
                height: 175.h,
                decoration: BoxDecoration(
                  color: Colors.grey.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: ListView(
                  padding: EdgeInsets.zero,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    ProfileTileWidget(
                      title: 'Shipping Address',
                      icon: SimpleLineIcons.location_pin,
                      onTap: () {},
                    ),
                    ProfileTileWidget(
                      title: 'Service Center',
                      icon: AntDesign.customerservice,
                      onTap: () {},
                    ),
                    ProfileTileWidget(
                      title: 'Coupons',
                      icon: MaterialIcons.rss_feed,
                      onTap: () {},
                    ),
                    ProfileTileWidget(
                      title: 'Settings',
                      icon: AntDesign.setting,
                      onTap: () {},
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 20.h,
              ),
              CustomButton(
                text: 'Logout',
                ontap: () {},
                radius: 0,
                color: Colors.red,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
