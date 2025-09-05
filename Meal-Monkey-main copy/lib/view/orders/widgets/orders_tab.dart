import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food_delivery_app/common/color_extension.dart';
import 'package:food_delivery_app/common/constants.dart';

class OrdersTab extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onTabSelected;

  const OrdersTab({
    super.key,
    required this.selectedIndex,
    required this.onTabSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: List.generate(
          orderList.length,
          (index) {
            final isSelected = index == selectedIndex;
            return Expanded(
              child: GestureDetector(
                onTap: () => onTabSelected(index),
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 4.w),
                  padding:
                      EdgeInsets.symmetric(vertical: 12.h, horizontal: 8.w),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.r),
                    color: isSelected ? Tcolor.primary : Colors.transparent,
                    border: Border.all(
                      color: isSelected ? Tcolor.primary : Colors.grey[300]!,
                      width: 1,
                    ),
                  ),
                  child: Text(
                    orderList[index],
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.bold,
                      color: isSelected ? Colors.white : Colors.grey[600],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
