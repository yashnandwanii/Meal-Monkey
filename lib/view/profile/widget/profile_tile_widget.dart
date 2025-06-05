import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:food_delivery_app/common/app_style.dart';
import 'package:food_delivery_app/common/reusable_text.dart';

class ProfileTileWidget extends StatelessWidget {
  const ProfileTileWidget(
      {super.key, required this.title, required this.icon, this.onTap});
  final String title;
  final IconData icon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      visualDensity: VisualDensity.compact,
      onTap: onTap,
      leading: Icon(
        icon,
        size: 20,
      ),
      title: ReusableText(
        text: title,
        style: appBarTextStyle(
          11,
          Colors.black,
          FontWeight.w400,
        ),
      ),
      trailing: title != 'Settings'
          ? const Icon(AntDesign.right)
          : Image.asset(
              'assets/iimg/india-flag-icon.png',
              width: 20,
              height: 20,
              fit: BoxFit.cover,
            ),
    );
  }
}
