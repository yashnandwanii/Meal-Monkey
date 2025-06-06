import 'package:flutter/material.dart';
import 'package:food_delivery_app/common/app_style.dart';
import 'package:food_delivery_app/view/cart/cart.dart';
import 'package:get/get.dart';

class GeneralAppBar extends StatelessWidget {
  const GeneralAppBar({super.key, required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white54,
      elevation: 0,
      automaticallyImplyLeading: false,
      title: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Text(
          title,
          style: appBarTextStyle(
            20,
            Colors.black,
            FontWeight.bold,
          ),
        ),
      ),
      centerTitle: false,
      actions: [
        IconButton(
          onPressed: () {
            Get.to(
              const MyOrderView(),
            );
          },
          icon: Image.asset(
            "assets/iimg/shopping_cart.png",
            width: 25,
            height: 25,
          ),
        ),
      ],
    );
  }
}
