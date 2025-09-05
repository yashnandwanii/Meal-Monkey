import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:food_delivery_app/common/custom_button.dart';
import 'package:food_delivery_app/common/custom_container.dart';
import 'package:food_delivery_app/common/color_extension.dart';
import 'package:food_delivery_app/controllers/login_controller.dart';
import 'package:food_delivery_app/models/login_response.dart';
import 'package:food_delivery_app/view/auth/verification_page.dart';
import 'package:food_delivery_app/view/orders/user_orders.dart';
import 'package:food_delivery_app/view/profile/addresses_page.dart';
import 'package:food_delivery_app/view/profile/coupons_page.dart';
import 'package:food_delivery_app/view/profile/favorites_page.dart';
import 'package:food_delivery_app/view/profile/reviews_page.dart';
import 'package:food_delivery_app/view/profile/widget/profile_appbar.dart';
import 'package:food_delivery_app/view/profile/widget/profile_tile_widget.dart';
import 'package:food_delivery_app/view/profile/widget/user_info_widget.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage>
    with AutomaticKeepAliveClientMixin {
  late LoginController controller;
  bool _isInitialized = false;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _initializeController();
  }

  void _initializeController() {
    if (!_isInitialized) {
      controller = Get.put(LoginController());
      _isInitialized = true;
      print('ProfilePage: Controller initialized and data loaded');
    } else {
      controller = Get.find<LoginController>();
      print('ProfilePage: Using existing controller - data preserved');
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // Required for AutomaticKeepAliveClientMixin

    LoginResponse? user;
    final box = GetStorage();
    String? token = box.read('token');

    // Debug storage contents
    controller.debugGetStorage();

    user = controller.getUserInfo();
    debugPrint('User Info: ${user?.username}, ${user?.email}');
    debugPrint('Token: $token');
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
                      onTap: () {
                        Get.to(
                          () => const FavoritesPage(),
                          transition: Transition.rightToLeft,
                          duration: const Duration(milliseconds: 500),
                        );
                      },
                    ),
                    ProfileTileWidget(
                      title: 'Reviews',
                      icon: Ionicons.chatbubble_outline,
                      onTap: () {
                        Get.to(
                          () => const ReviewsPage(),
                          transition: Transition.rightToLeft,
                          duration: const Duration(milliseconds: 500),
                        );
                      },
                    ),
                    ProfileTileWidget(
                      title: 'Coupons',
                      icon: MaterialCommunityIcons.tag_outline,
                      onTap: () {
                        Get.to(
                          () => const CouponsPage(),
                          transition: Transition.rightToLeft,
                          duration: const Duration(milliseconds: 500),
                        );
                      },
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
                      onTap: () {
                        _showServiceCenterDialog(context);
                      },
                    ),
                    ProfileTileWidget(
                      title: 'Help & Support',
                      icon: MaterialIcons.rss_feed,
                      onTap: () {
                        _showHelpSupportDialog(context);
                      },
                    ),
                    ProfileTileWidget(
                      title: 'Settings',
                      icon: AntDesign.setting,
                      onTap: () {
                        _showSettingsDialog(context);
                      },
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
                  _showLogoutDialog(context, controller);
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

  void _showServiceCenterDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Service Center'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Contact our customer service:'),
              SizedBox(height: 16.h),
              Row(
                children: [
                  Icon(Icons.phone, color: Tcolor.primary),
                  SizedBox(width: 8.w),
                  Text('+1 (555) 123-4567'),
                ],
              ),
              SizedBox(height: 8.h),
              Row(
                children: [
                  Icon(Icons.email, color: Tcolor.primary),
                  SizedBox(width: 8.w),
                  Text('support@mealmonkey.com'),
                ],
              ),
              SizedBox(height: 8.h),
              Row(
                children: [
                  Icon(Icons.access_time, color: Tcolor.primary),
                  SizedBox(width: 8.w),
                  Text('24/7 Support'),
                ],
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }

  void _showHelpSupportDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Help & Support'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHelpItem('How to place an order?', Icons.shopping_cart),
              _buildHelpItem('How to track my order?', Icons.location_on),
              _buildHelpItem('How to cancel an order?', Icons.cancel),
              _buildHelpItem('Payment methods', Icons.payment),
              _buildHelpItem('Refund policy', Icons.money_off),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildHelpItem(String title, IconData icon) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4.h),
      child: Row(
        children: [
          Icon(icon, color: Tcolor.primary, size: 20.sp),
          SizedBox(width: 8.w),
          Expanded(
            child: Text(
              title,
              style: TextStyle(fontSize: 14.sp),
            ),
          ),
        ],
      ),
    );
  }

  void _showSettingsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Settings'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(Icons.notifications, color: Tcolor.primary),
                title: Text('Notifications'),
                trailing: Switch(
                  value: true,
                  onChanged: (value) {
                    // TODO: Implement notification toggle
                  },
                ),
              ),
              ListTile(
                leading: Icon(Icons.language, color: Tcolor.primary),
                title: Text('Language'),
                trailing: Text('English'),
                onTap: () {
                  // TODO: Implement language selection
                },
              ),
              ListTile(
                leading: Icon(Icons.security, color: Tcolor.primary),
                title: Text('Privacy Policy'),
                onTap: () {
                  // TODO: Navigate to privacy policy
                },
              ),
              ListTile(
                leading: Icon(Icons.description, color: Tcolor.primary),
                title: Text('Terms of Service'),
                onTap: () {
                  // TODO: Navigate to terms of service
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }

  void _showLogoutDialog(BuildContext context, LoginController controller) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Logout'),
          content: Text('Are you sure you want to logout?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                controller.logout();
              },
              child: Text(
                'Logout',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }
}
