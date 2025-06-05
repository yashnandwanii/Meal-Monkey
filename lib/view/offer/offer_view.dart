// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food_delivery_app/common/color_extension.dart';
import 'package:food_delivery_app/common/custom_button.dart';
import 'package:food_delivery_app/common/shimmers/nearby_shimmer.dart';
import 'package:food_delivery_app/hooks/fetch_all_restaurents.dart';
import 'package:food_delivery_app/models/restaurents.dart';
import 'package:food_delivery_app/view/offer/offer_widget.dart';
import 'package:food_delivery_app/common_widgets/general_app_bar.dart';

class OfferView extends HookWidget {
  OfferView({super.key});

  TextEditingController txtSearch = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final hookResults = useFetchAllRestaurents('41007428');
    List<RestaurentsModel>? restaurents = hookResults.data;
    final isLoading = hookResults.isLoading;
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(40.h),
        child: const GeneralAppBar(
          title: 'Latest Offers',
        ),
      ),
      backgroundColor: Tcolor.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Find discounts, Offers special meals and more!",
                      style: TextStyle(
                        color: Tcolor.secondaryText,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 15.h,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: CustomButton(
                  color: Tcolor.primary,
                  text: 'Check Offers',
                  radius: 8,
                  ontap: () {},
                  height: 25.h,
                  width: MediaQuery.of(context).size.width * 0.35,
                ),
              ),
              SizedBox(
                height: 20.h,
              ),
              isLoading
                  ? const NearbyShimmer()
                  : Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10.w),
                      child: ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: restaurents?.length ?? 0,
                        itemBuilder: (context, index) {
                          final restaurent = restaurents![index];
                          return Padding(
                            padding: EdgeInsets.only(
                                bottom: 16.h), // consistent spacing
                            child: OfferWidget(
                              image: restaurent.imageUrl,
                              logo: restaurent.logoUrl,
                              title: restaurent.title,
                              time: restaurent.time,
                              rating: restaurent.ratingCount,
                            ),
                          );
                        },
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
