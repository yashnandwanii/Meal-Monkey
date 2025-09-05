import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food_delivery_app/common/color_extension.dart';
import 'package:food_delivery_app/common/constants.dart';
import 'package:food_delivery_app/hooks/fetch_user_coupons.dart';
import 'package:food_delivery_app/models/coupons_response.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class CouponsPage extends HookWidget {
  const CouponsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final hookResults = useFetchUserCoupons();
    List<CouponResponse>? coupons = hookResults.data;
    bool isLoading = hookResults.isLoading;
    Exception? error = hookResults.error;

    return Scaffold(
      backgroundColor: offWhite,
      appBar: AppBar(
        backgroundColor: offWhite,
        elevation: 0,
        title: Text(
          'My Coupons',
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
        actions: [
          IconButton(
            icon: Icon(Icons.add, color: Tcolor.primary),
            onPressed: () {
              _showAddCouponDialog(context);
            },
          ),
        ],
      ),
      body: _buildCouponsList(
          context, coupons, isLoading, error, hookResults.refetch),
    );
  }

  Widget _buildCouponsList(
    BuildContext context,
    List<CouponResponse>? coupons,
    bool isLoading,
    Exception? error,
    VoidCallback? refetch,
  ) {
    if (isLoading) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(color: Tcolor.primary),
            SizedBox(height: 16.h),
            Text(
              'Loading your coupons...',
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
              'Failed to load coupons',
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

    if (coupons == null || coupons.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.local_offer,
              size: 64.sp,
              color: Colors.grey[400],
            ),
            SizedBox(height: 16.h),
            Text(
              'No coupons available',
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.w600,
                color: Colors.grey[800],
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              'You don\'t have any coupons yet.',
              style: TextStyle(
                fontSize: 14.sp,
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 24.h),
            ElevatedButton(
              onPressed: () => _showAddCouponDialog(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: Tcolor.primary,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
              ),
              child: Text('Add Coupon Code'),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () async => refetch?.call(),
      child: ListView.builder(
        padding: EdgeInsets.all(16.w),
        itemCount: coupons.length,
        itemBuilder: (context, index) {
          final coupon = coupons[index];
          return _buildCouponTile(coupon);
        },
      ),
    );
  }

  Widget _buildCouponTile(CouponResponse coupon) {
    final isExpired = coupon.isExpired;
    final isValid = coupon.isValid;
    final isAvailable = coupon.isAvailable;

    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(
          color: isExpired
              ? Colors.red.withOpacity(0.3)
              : isValid && isAvailable
                  ? Tcolor.primary.withOpacity(0.3)
                  : Colors.grey.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: isExpired
                  ? Colors.red.withOpacity(0.1)
                  : isValid && isAvailable
                      ? Tcolor.primary.withOpacity(0.1)
                      : Colors.grey.withOpacity(0.1),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12.r),
                topRight: Radius.circular(12.r),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        coupon.title,
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                          color: isExpired ? Colors.red : Colors.black87,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        coupon.description,
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: Colors.grey[600],
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                  decoration: BoxDecoration(
                    color: isExpired
                        ? Colors.red
                        : isValid && isAvailable
                            ? Tcolor.primary
                            : Colors.grey,
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: Text(
                    isExpired
                        ? 'EXPIRED'
                        : isValid && isAvailable
                            ? 'VALID'
                            : 'UNAVAILABLE',
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Code: ${coupon.code}',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                        color: Tcolor.primary,
                        fontFamily: 'monospace',
                      ),
                    ),
                    if (isValid && isAvailable)
                      IconButton(
                        icon: Icon(Icons.copy, color: Tcolor.primary),
                        onPressed: () {
                          _copyCouponCode(coupon.code);
                        },
                      ),
                  ],
                ),
                SizedBox(height: 12.h),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${coupon.discountPercentage}% OFF',
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.bold,
                              color: Tcolor.primary,
                            ),
                          ),
                          Text(
                            'Max: \$${coupon.maxDiscount.toStringAsFixed(2)}',
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            'Min Order: \$${coupon.minOrderAmount.toStringAsFixed(2)}',
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: Colors.grey[600],
                            ),
                          ),
                          Text(
                            'Used: ${coupon.usedCount}/${coupon.usageLimit}',
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Valid until: ${DateFormat('MMM dd, yyyy').format(coupon.validUntil)}',
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: Colors.grey[500],
                      ),
                    ),
                    if (isValid && isAvailable)
                      ElevatedButton(
                        onPressed: () {
                          _useCoupon(coupon);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Tcolor.primary,
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(
                              horizontal: 16.w, vertical: 8.h),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.r),
                          ),
                        ),
                        child: Text('Use Now'),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showAddCouponDialog(BuildContext context) {
    // TODO: Implement add coupon dialog
    Get.snackbar(
      'Add Coupon',
      'Add coupon functionality coming soon!',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Tcolor.primary.withOpacity(0.8),
      colorText: Colors.white,
    );
  }

  void _copyCouponCode(String code) {
    // TODO: Implement copy to clipboard
    Get.snackbar(
      'Copied!',
      'Coupon code copied to clipboard',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green.withOpacity(0.8),
      colorText: Colors.white,
    );
  }

  void _useCoupon(CouponResponse coupon) {
    // TODO: Implement use coupon functionality
    Get.snackbar(
      'Use Coupon',
      'Use coupon functionality coming soon!',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Tcolor.primary.withOpacity(0.8),
      colorText: Colors.white,
    );
  }
}
