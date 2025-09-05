import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food_delivery_app/common/color_extension.dart';
import 'package:food_delivery_app/common/constants.dart';
import 'package:food_delivery_app/common/custom_button.dart';
import 'package:get/get.dart';

class OrderSuccessPage extends StatelessWidget {
  const OrderSuccessPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Get order details from arguments
    final orderDetails = Get.arguments as Map<String, dynamic>?;

    final orderId = orderDetails?['orderId'] ?? 'N/A';
    final paymentId = orderDetails?['paymentId'] ?? 'N/A';
    final orderDate = orderDetails?['orderDate'] as DateTime? ?? DateTime.now();
    final restaurant = orderDetails?['restaurant'] ?? 'N/A';
    final food = orderDetails?['food'] ?? 'N/A';
    final quantity = orderDetails?['quantity'] ?? 1;
    final totalAmount = orderDetails?['totalAmount'] ?? 0.0;
    final address = orderDetails?['address'];
    final additives = orderDetails?['additives'] as List<String>? ?? [];
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(24.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Success Icon
              Container(
                width: 120.w,
                height: 120.w,
                decoration: BoxDecoration(
                  color: Colors.green.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.check_circle_outline,
                  size: 80.sp,
                  color: Colors.green,
                ),
              ),
              SizedBox(height: 32.h),

              // Success Message
              Text(
                'Order Placed Successfully!',
                style: TextStyle(
                  fontSize: 24.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 16.h),

              Text(
                'Your order has been confirmed and is being prepared.',
                style: TextStyle(
                  fontSize: 16.sp,
                  color: Colors.grey[600],
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 24.h),

              // Order Details Card
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(20.w),
                decoration: BoxDecoration(
                  color: offWhite,
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(color: Colors.green.withOpacity(0.3)),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Icon(Icons.receipt_long,
                            color: Colors.green, size: 24.sp),
                        SizedBox(width: 12.w),
                        Text(
                          'Order Details',
                          style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16.h),
                    _buildDetailRow('Order ID', orderId, Colors.blue),
                    _buildDetailRow('Payment ID', paymentId, Colors.green),
                    _buildDetailRow('Restaurant', restaurant, Colors.black87),
                    _buildDetailRow('Food Item', food, Colors.black87),
                    _buildDetailRow(
                        'Quantity', quantity.toString(), Colors.black87),
                    _buildDetailRow('Total Amount',
                        '₹${totalAmount.toStringAsFixed(2)}', Tcolor.primary),
                    _buildDetailRow(
                        'Order Date',
                        '${orderDate.day}/${orderDate.month}/${orderDate.year}',
                        Colors.grey[600]!),
                    _buildDetailRow(
                        'Order Time',
                        '${orderDate.hour}:${orderDate.minute.toString().padLeft(2, '0')}',
                        Colors.grey[600]!),
                    _buildDetailRow('Order Status', 'Confirmed', Colors.green),
                    _buildDetailRow('Payment Status', 'Paid', Colors.green),
                    _buildDetailRow(
                        'Estimated Delivery', '25-30 minutes', Colors.blue),
                  ],
                ),
              ),
              SizedBox(height: 32.h),

              // Action Buttons
              CustomButton(
                text: 'Track My Order',
                ontap: () {
                  Get.offAllNamed('/user-orders');
                },
                color: Tcolor.primary,
                height: 50.h,
              ),
              SizedBox(height: 16.h),

              Container(
                width: double.infinity,
                height: 50.h,
                child: ElevatedButton(
                  onPressed: () {
                    Get.offAllNamed('/home');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey[300],
                    foregroundColor: Colors.black87,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                  ),
                  child: Text(
                    'Continue Shopping',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 16.h),

              TextButton(
                onPressed: () {
                  Get.offAllNamed('/profile');
                },
                child: Text(
                  'Go to Profile',
                  style: TextStyle(
                    fontSize: 16.sp,
                    color: Tcolor.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, Color valueColor) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 14.sp,
              color: Colors.grey[600],
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              color: valueColor,
            ),
          ),
        ],
      ),
    );
  }
}
