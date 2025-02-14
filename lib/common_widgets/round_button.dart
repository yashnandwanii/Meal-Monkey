import 'package:flutter/material.dart';
import 'package:food_delivery_app/common/color_extension.dart';

enum RoundButtonType { bgprimary, textPrimary }

class RoundButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;
  final RoundButtonType type;
  const RoundButton(
      {super.key,
      required this.onPressed,
      required this.text,
      this.type = RoundButtonType.bgprimary});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        height: 56,
        decoration: BoxDecoration(
          border: type == RoundButtonType.bgprimary
              ? null
              : Border.all(color: Tcolor.primary, width: 1),
          color:
              type == RoundButtonType.bgprimary ? Tcolor.primary : Colors.white,
          borderRadius: BorderRadius.circular(28),
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              color: type == RoundButtonType.bgprimary
                  ? Colors.white
                  : Tcolor.primary,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}
