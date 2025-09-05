import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food_delivery_app/common/background_container.dart';
import 'package:food_delivery_app/common/color_extension.dart';
import 'package:food_delivery_app/common/constants.dart';
import 'package:food_delivery_app/hooks/fetch_user_orders.dart';
import 'package:food_delivery_app/models/order_response.dart';
import 'package:food_delivery_app/view/orders/widgets/order_tile.dart';
import 'package:food_delivery_app/view/orders/widgets/orders_tab.dart';

class UserOrders extends HookWidget {
  const UserOrders({super.key});

  @override
  Widget build(BuildContext context) {
    final selectedTabIndex = useState(0);
    final orderStatus = useState<String?>(null);
    final paymentStatus = useState<String?>(null);

    // Map tab indices to order statuses
    final statusMap = {
      0: null, // All Orders
      1: 'Placed', // Pending
      2: 'Preparing', // In Progress
      3: 'Delivered', // Completed
      4: 'Cancelled', // Cancelled
    };

    final hookResults = useFetchUserOrders(
      orderStatus: orderStatus.value,
      paymentStatus: paymentStatus.value,
    );

    List<OrderResponse>? orders = hookResults.data;
    bool isLoading = hookResults.isLoading;
    Exception? error = hookResults.error;

    // Update order status when tab changes
    useEffect(() {
      orderStatus.value = statusMap[selectedTabIndex.value];
      return null;
    }, [selectedTabIndex.value]);

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
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Tcolor.primary),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: BackgroundContainer(
        color: Colors.white70,
        child: Column(
          children: [
            SizedBox(height: 10.h),
            OrdersTab(
              selectedIndex: selectedTabIndex.value,
              onTabSelected: (index) {
                selectedTabIndex.value = index;
              },
            ),
            SizedBox(height: 10.h),
            Expanded(
              child: _buildOrdersList(
                  orders, isLoading, error, () => hookResults.refetch!()),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrdersList(
    List<OrderResponse>? orders,
    bool isLoading,
    Exception? error,
    VoidCallback refetch,
  ) {
    if (isLoading) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(color: Tcolor.primary),
            SizedBox(height: 16.h),
            Text(
              'Loading your orders...',
              style: TextStyle(
                fontSize: 16.sp,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      );
    }

    if (error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64.sp,
              color: Colors.red[300],
            ),
            SizedBox(height: 16.h),
            Text(
              'Failed to load orders',
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
                color: Colors.grey[800],
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              error.toString(),
              style: TextStyle(
                fontSize: 14.sp,
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 24.h),
            ElevatedButton(
              onPressed: refetch,
              style: ElevatedButton.styleFrom(
                backgroundColor: Tcolor.primary,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
              ),
              child: Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (orders == null || orders.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.receipt_long,
              size: 64.sp,
              color: Colors.grey[400],
            ),
            SizedBox(height: 16.h),
            Text(
              'No orders found',
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
                color: Colors.grey[800],
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              'You haven\'t placed any orders yet.',
              style: TextStyle(
                fontSize: 14.sp,
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () async => refetch(),
      child: ListView.builder(
        padding: EdgeInsets.symmetric(vertical: 8.h),
        itemCount: orders.length,
        itemBuilder: (context, index) {
          final order = orders[index];
          return OrderTile(
            order: order,
            onTap: () {
              // TODO: Navigate to order details page
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Order details coming soon!'),
                  backgroundColor: Tcolor.primary,
                ),
              );
            },
          );
        },
      ),
    );
  }
}
