import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food_delivery_app/common/shimmers/nearby_shimmer.dart';
import 'package:food_delivery_app/hooks/fetch_all_restaurents.dart';
import 'package:food_delivery_app/models/restaurents.dart';
import 'package:food_delivery_app/view/home/widgets/restaurent_widget.dart';
import 'package:food_delivery_app/view/restaurent/restaurent_page.dart';
import 'package:get/get.dart';

class NearbyRestaurents extends HookWidget {
  const NearbyRestaurents({super.key});

  @override
  Widget build(BuildContext context) {
    final hookResults = useFetchAllRestaurents('41007428');
    List<RestaurentsModel>? restaurents = hookResults.data;
    final isLoading = hookResults.isLoading;

    return isLoading
        ? const NearbyShimmer()
        : restaurents == null || restaurents.isEmpty
            ? Container(
                height: 190.h,
                padding: EdgeInsets.only(left: 12.w, top: 10.h),
                child: Center(
                  child: Text(
                    'No restaurants available',
                    style: TextStyle(
                      fontSize: 16.sp,
                      color: Colors.grey,
                    ),
                  ),
                ),
              )
            : Container(
                height: 190.h,
                padding: EdgeInsets.only(left: 12.w, top: 10.h),
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: List.generate(
                    restaurents.length,
                    (i) {
                      RestaurentsModel restaurent = restaurents[i];
                      return RestaurentWidget(
                        onTap: () {
                          Get.to(
                            () => RestaurentPage(restaurent: restaurent),
                            transition: Transition.rightToLeft,
                            duration: const Duration(milliseconds: 500),
                          );
                        },
                        image: restaurent.imageUrl,
                        logo: restaurent.logoUrl,
                        title: restaurent.title,
                        time: restaurent.time,
                        rating: restaurent.ratingCount,
                      );
                    },
                  ),
                ),
              );
  }
}
