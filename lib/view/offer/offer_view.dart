// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food_delivery_app/common/color_extension.dart';
import 'package:food_delivery_app/common/shimmers/nearby_shimmer.dart';
import 'package:food_delivery_app/common_widgets/round_button.dart';
import 'package:food_delivery_app/hooks/fetch_all_restaurents.dart';
import 'package:food_delivery_app/models/restaurents.dart';
import 'package:food_delivery_app/view/more/my_order_view.dart';
import 'package:food_delivery_app/view/offer/offer_widget.dart';

class OfferView extends HookWidget {
  OfferView({super.key});

  TextEditingController txtSearch = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final hookResults = useFetchAllRestaurents('41007428');
    List<RestaurentsModel>? restaurents = hookResults.data;
    final isLoading = hookResults.isLoading;
    return Scaffold(
      backgroundColor: Tcolor.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 46,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Latest Offers",
                      style: TextStyle(
                          color: Tcolor.primaryText,
                          fontSize: 20,
                          fontWeight: FontWeight.w800),
                    ),
                    IconButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const MyOrderView()));
                      },
                      icon: Image.asset(
                        "assets/iimg/shopping_cart.png",
                        width: 25,
                        height: 25,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Find discounts, Offers special\nmeals and more!",
                      style: TextStyle(
                          color: Tcolor.secondaryText,
                          fontSize: 14,
                          fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: SizedBox(
                  width: 140,
                  height: 30,
                  child: RoundButton(text: "check Offers", onPressed: () {}),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              isLoading
                  ? const NearbyShimmer()
                  : Container(
                      height: MediaQuery.of(context).size.height * 0.75,
                      padding: EdgeInsets.only(left: 12.w, top: 10.h),
                      width: double.infinity,
                      child: ListView(
                        scrollDirection: Axis.vertical,
                        children: List.generate(
                          restaurents!.length,
                          (i) {
                            RestaurentsModel restaurent = restaurents[i];
                            return OfferWidget(
                              image: restaurent.imageUrl,
                              logo: restaurent.logoUrl,
                              title: restaurent.title,
                              time: restaurent.time,
                              rating: restaurent.ratingCount,
                            );
                          },
                        ),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
