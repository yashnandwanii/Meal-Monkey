import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:food_delivery_app/common/app_style.dart';
import 'package:food_delivery_app/common/color_extension.dart';
import 'package:food_delivery_app/common/reusable_text.dart';
import 'package:food_delivery_app/models/addresses_response.dart';

class AddressTile extends StatelessWidget {
  const AddressTile({super.key, required this.address});
  final AddressResponse
      address; // Uncomment this line when AddressResponse is defined

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {},
      visualDensity: VisualDensity.compact,
      leading: Icon(
        SimpleLineIcons.location_pin,
        color: Tcolor.primary,
        size: 28.h,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.r),
      ),
      title: ReusableText(
        text: address.addressLine1,
        style: appBarTextStyle(
          12,
          Colors.black87,
          FontWeight.w500,
        ),
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ReusableText(
            text: address.postalCode,
            style: appBarTextStyle(
              10,
              Colors.black87,
              FontWeight.w400,
            ),
          ),
          ReusableText(
            text: 'Tap to set as default',
            style: appBarTextStyle(
              8,
              Colors.black87,
              FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}
