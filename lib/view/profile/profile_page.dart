import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:food_delivery_app/common/custom_button.dart';
import 'package:food_delivery_app/common/custom_container.dart';
import 'package:food_delivery_app/controllers/login_controller.dart';
import 'package:food_delivery_app/models/login_response.dart';
import 'package:food_delivery_app/view/auth/verification_page.dart';
import 'package:food_delivery_app/view/orders/user_orders.dart';
import 'package:food_delivery_app/view/profile/addresses_page.dart';
import 'package:food_delivery_app/view/profile/widget/profile_appbar.dart';
import 'package:food_delivery_app/view/profile/widget/profile_tile_widget.dart';
import 'package:food_delivery_app/view/profile/widget/user_info_widget.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    LoginResponse? user;
    final controller = Get.put(LoginController());

    final box = GetStorage();
    String? token = box.read('token');

    if (token != null) {
      user = controller.getUserInfo();
      //debugPrint('User Info: ${user?.username}, ${user?.email}');
    }
    if (token == null) {
      return Scaffold(
        backgroundColor: Colors.white,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(40.h),
          child: const ProfileAppbar(),
        ),
        body: Center(
          child: Text(
            'Please log in to view your profile',
            style: TextStyle(fontSize: 16.sp, color: Colors.black54),
          ),
        ),
      );
    }

    if (user != null && user.verification == false) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Get.offAll(() => const VerificationPage());
      });
    }

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
              UserInfoWidget(user: user),
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
                      onTap: () {
                        Get.to(
                          () => const UserOrders(),
                          transition: Transition.rightToLeft,
                          duration: const Duration(milliseconds: 500),
                        );
                      },
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
                      onTap: () {
                        Get.to(() => const AddressPage());
                      },
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
                ontap: () {
                  controller.logout();
                },
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
