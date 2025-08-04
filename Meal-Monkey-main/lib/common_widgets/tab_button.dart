import 'package:flutter/material.dart';
import 'package:food_delivery_app/common/color_extension.dart';

class TabButton extends StatelessWidget {
  final VoidCallback onTap;
  final String title;
  final bool isSelected;
  final String icon;
  const TabButton(
      {super.key,
      required this.icon,
      required this.title,
      required this.onTap,
      required this.isSelected});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(
            'assets/iimg/$icon.png',
            width: 20,
            height: 20,
            color: isSelected ? Tcolor.primary : Tcolor.placeholder,
          ),
          const SizedBox(height: 5),
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              color: isSelected ? Tcolor.primary : Tcolor.placeholder,
              fontWeight: FontWeight.w500,
            ),
          )
        ],
      ),
    );
  }
}
