import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food_delivery_app/common/background_container.dart';
import 'package:food_delivery_app/common/color_extension.dart';
import 'package:food_delivery_app/common/constants.dart';
import 'package:food_delivery_app/view/orders/widgets/orders_tab.dart';

class UserOrders extends StatefulWidget {
  const UserOrders({super.key});

  @override
  State<UserOrders> createState() => _UserOrdersState();
}

class _UserOrdersState extends State<UserOrders> with TickerProviderStateMixin {
  late final TabController _tabController =
      TabController(length: orderList.length, vsync: this);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: offWhite,
      appBar: AppBar(
        backgroundColor: offWhite,
        elevation: 0,
        title: Text(
          'My Orders',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Tcolor.primary,
          ),
        ),
        centerTitle: true,
      ),
      body: BackgroundContainer(
        color: Colors.white70,
        child: Column(
          children: [
            SizedBox(
              height: 10.h,
            ),
            OrdersTab(tabController: _tabController),
            SizedBox(
              height: 10.h,
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.7,
              width: MediaQuery.of(context).size.width,
              child: TabBarView(
                controller: _tabController,
                children: List.generate(
                  orderList.length,
                  (index) {
                    return Center(
                      child: Text(
                        orderList[index],
                        style: TextStyle(
                          fontSize: 16.sp,
                          color: Colors.black54,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
