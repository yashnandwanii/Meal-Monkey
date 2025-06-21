import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food_delivery_app/common/color_extension.dart';
import 'package:food_delivery_app/common/constants.dart';

class OrdersTab extends StatelessWidget {
  const OrdersTab({
    super.key,
    required TabController tabController,
  }) : _tabController = tabController;

  final TabController _tabController;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TabBar(
        controller: _tabController,
        isScrollable: true,
        dividerColor: Colors.grey[300],
        labelPadding: const EdgeInsets.symmetric(horizontal: 10),
        indicator: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Tcolor.primary,
        ),
        labelColor: Colors.white,
        indicatorColor: Colors.white,
        unselectedLabelColor: Colors.grey[600],
        labelStyle: TextStyle(
          fontSize: 12.sp,
          fontWeight: FontWeight.bold,
          color: Colors.white70,
        ),
        tabAlignment: TabAlignment.start,
        tabs: List.generate(
          orderList.length,
          (index) {
            return Tab(
              text: orderList[index],
            );
          },
        ),
      ),
    );
  }
}
