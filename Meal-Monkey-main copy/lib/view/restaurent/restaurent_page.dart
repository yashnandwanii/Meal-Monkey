import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:food_delivery_app/common/app_style.dart';
import 'package:food_delivery_app/common/color_extension.dart';
import 'package:food_delivery_app/common/reusable_text.dart';
import 'package:food_delivery_app/models/restaurents.dart';
import 'package:food_delivery_app/view/restaurent/Widgets/restaurent_menu.dart';
import 'package:food_delivery_app/view/restaurent/Widgets/restaurent_rating_widget.dart';
import 'package:food_delivery_app/view/restaurent/Widgets/row_text.dart';
import 'package:food_delivery_app/view/restaurent/Widgets/xplore_widget.dart';
import 'package:food_delivery_app/view/restaurent/directions_page.dart';
import 'package:get/get.dart';

class RestaurentPage extends StatefulHookWidget {
  const RestaurentPage({super.key, required this.restaurent});
  final RestaurentsModel? restaurent;

  @override
  State<RestaurentPage> createState() => _RestaurentPageState();
}

class _RestaurentPageState extends State<RestaurentPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController = TabController(length: 2, vsync: this);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: ListView(
          padding: EdgeInsets.zero,
          children: [
            Stack(
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: 230.h,
                  child: CachedNetworkImage(
                    imageUrl: widget.restaurent?.imageUrl ??
                        'https://plus.unsplash.com/premium_photo-1670601440146-3b33dfcd7e17?w=900&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MTB8fGZvb2R8ZW58MHx8MHx8fDA%3D',
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  bottom: 0,
                  child: RestaurentRatingWidget(widget: widget),
                ),
                Positioned(
                  top: 40.h,
                  left: 0,
                  right: 0,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 12.w),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Get.back();
                          },
                          child: Icon(
                            Ionicons.chevron_back_circle,
                            color: Colors.white,
                            size: 30.w,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Get.to(const DirectionsPage());
                          },
                          child: Icon(
                            Ionicons.location,
                            color: Colors.white,
                            size: 30.w,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.w),
              child: ReusableText(
                text: widget.restaurent?.title ?? 'Restaurant',
                style: appBarTextStyle(
                  18.sp,
                  Colors.black,
                  FontWeight.w600,
                ),
              ),
            ),
            SizedBox(height: 10.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.w),
              child: Column(
                children: [
                  RowText(
                      first: 'Business Hours',
                      second: widget.restaurent?.businessHours ??
                          '9:00 AM - 11:00 PM'),
                  SizedBox(height: 5.h),
                  const RowText(first: 'Estimated Price', second: '₹ 200'),
                  SizedBox(height: 5.h),
                  RowText(
                      first: 'Estimated Time',
                      second: widget.restaurent?.time ?? '30 min'),
                  SizedBox(height: 5.h),
                  const Divider(
                    thickness: 0.7,
                  )
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.w),
              child: Container(
                height: 25.h,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: Colors.grey.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(25.r),
                ),
                child: TabBar(
                  controller: _tabController,
                  labelColor: Colors.white,
                  unselectedLabelColor: Colors.grey,
                  labelPadding: EdgeInsets.zero,
                  indicator: BoxDecoration(
                    color: Tcolor.primary,
                    borderRadius: BorderRadius.circular(25.r),
                  ),
                  labelStyle:
                      appBarTextStyle(12, Colors.white, FontWeight.w600),
                  tabs: [
                    SizedBox(
                      height: 25.h,
                      width: MediaQuery.of(context).size.width / 2,
                      child: const Center(
                        child: Tab(
                          text: 'Menu',
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 25.h,
                      width: MediaQuery.of(context).size.width / 2,
                      child: const Center(
                        child: Tab(
                          text: 'Explore',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 10.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 8.w),
              child: SizedBox(
                height: MediaQuery.of(context).size.height * 0.7,
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    // Restaurent Menu
                    Container(
                      color: Colors.white54,
                      child: widget.restaurent != null
                          ? RestaurentMenu(restaurentId: widget.restaurent!.id)
                          : const Center(
                              child: Text('No Menu Available'),
                            ),
                    ),
                    // Explore Page
                    XploreWidget(code: widget.restaurent?.code),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
