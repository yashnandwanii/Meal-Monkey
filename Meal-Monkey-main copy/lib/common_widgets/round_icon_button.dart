import 'package:flutter/material.dart';

class RoundIconButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String title;
  final String icon;
  final Color color;
  final double fontSize;

  const RoundIconButton({
    super.key,
    required this.onPressed,
    required this.title,
    required this.icon,
    required this.color,
    this.fontSize = 14,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed, // Use the provided callback
      child: Container(
        height: 56,
        padding: const EdgeInsets.symmetric(
            horizontal: 16), // Adjust padding for better layout
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: color, // Use the dynamic color
          borderRadius: BorderRadius.circular(28), // Circular shape
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              icon, // Use the dynamic icon path
              width: 20, // Adjusted size
              height: 20,
              fit: BoxFit.contain,
            ),
            const SizedBox(width: 8),
            Text(
              title, // Use the dynamic title
              style: const TextStyle(
                fontSize: 14, // Slightly larger font for better visibility
                fontWeight: FontWeight.w500,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
