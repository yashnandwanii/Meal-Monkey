// ignore_for_file: unrelated_type_equality_checks

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:food_delivery_app/common/app_style.dart';
import 'package:food_delivery_app/common/color_extension.dart';
import 'package:food_delivery_app/common/constants.dart';
import 'package:food_delivery_app/common/custom_button.dart';
import 'package:food_delivery_app/common/custom_text_field.dart';
import 'package:food_delivery_app/common/reusable_text.dart';
import 'package:food_delivery_app/controllers/foods_controller.dart';
import 'package:food_delivery_app/hooks/fetch_restaurent.dart';
import 'package:food_delivery_app/models/foods.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:food_delivery_app/view/auth/phone_verification_page.dart';
import 'package:food_delivery_app/view/restaurent/restaurent_page.dart';
import 'package:get/get.dart';

class FoodPage extends StatefulHookWidget {
  const FoodPage({super.key, required this.food});

  final FoodItem food;

  @override
  State<FoodPage> createState() => _FoodPageState();
}

class _FoodPageState extends State<FoodPage> {
  final TextEditingController _searchController = TextEditingController();
  final PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();
    // Register controller only if not registered already
    if (!Get.isRegistered<FoodsController>()) {
      Get.put(FoodsController());
    }

    // Post-frame call to avoid triggering rebuild during build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final controller = Get.find<FoodsController>();
      controller.loadAdditives(widget.food.additives);
    });
  }

  @override
  Widget build(BuildContext context) {
    final hookResult = usefetchRestaurent(widget.food.restaurent);
    final controller = Get.find<FoodsController>();

    return Scaffold(
      backgroundColor: Colors.white,
      body: ListView(
        physics: const NeverScrollableScrollPhysics(),
        padding: EdgeInsets.zero,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.only(
              bottomRight: Radius.circular(30.r),
            ),
            child: Stack(
              children: [
                Stack(
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                      height: 230.h,
                      child: PageView.builder(
                        controller: _pageController,
                        onPageChanged: (i) {
                          controller.changeIndex(i);
                        },
                        itemCount: widget.food.imageUrl.length,
                        itemBuilder: (context, index) {
                          return SizedBox(
                            height: 230.h,
                            width: MediaQuery.of(context).size.width,
                            child: CachedNetworkImage(
                              imageUrl: widget.food.imageUrl[index],
                              fit: BoxFit.cover,
                            ),
                          );
                        },
                      ),
                    ),
                    Positioned(
                      bottom: 10,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 12.0),
                        child: Obx(
                          () => Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(
                              widget.food.imageUrl.length,
                              (index) => Container(
                                margin: EdgeInsets.only(left: 5.w, right: 5.w),
                                width: 8.w,
                                height: 8.h,
                                decoration: BoxDecoration(
                                  color: controller.currentIndex == index
                                      ? Colors.red
                                      : Colors.grey,
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 40.h,
                      left: 12.w,
                      child: GestureDetector(
                        onTap: () {
                          Get.back();
                        },
                        child: Icon(
                          Ionicons.chevron_back_circle,
                          size: 30.w,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 10.h,
                      right: 12.w,
                      child: CustomButton(
                        ontap: () {
                          Get.to(
                            () => RestaurentPage(
                              restaurent: hookResult.data,
                            ),
                          );
                        },
                        color: Theme.of(context).primaryColorDark,
                        width: 120.w,
                        height: 30.h,
                        radius: 10.r,
                        text: 'Open Restaurent',
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 12.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 10.h,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ReusableText(
                      text: widget.food.title,
                      style: appBarTextStyle(
                        18,
                        Colors.black,
                        FontWeight.w600,
                      ),
                    ),
                    Obx(
                      () => ReusableText(
                        text:
                            '\$${(widget.food.price + controller.totalAdditivesPrice) * controller.count.value}',
                        style: appBarTextStyle(
                          18,
                          Tcolor.primary,
                          FontWeight.w600,
                        ),
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: 5.h,
                ),
                Text(
                  widget.food.description,
                  style: appBarTextStyle(
                    14,
                    Colors.grey,
                    FontWeight.w400,
                  ),
                  maxLines: 4,
                  textAlign: TextAlign.justify,
                ),
                SizedBox(
                  height: 5.h,
                ),
                SizedBox(
                  height: 25.h,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: List.generate(
                      widget.food.foodTags.length,
                      (index) {
                        final tag = widget.food.foodTags[index];
                        return Container(
                          height: 20.h,
                          width: 50.w,
                          margin: EdgeInsets.only(right: 5.w),
                          decoration: BoxDecoration(
                            color: Tcolor.primary.withValues(alpha: 0.3),
                            borderRadius: BorderRadius.circular(15.r),
                          ),
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 5.0, vertical: 5),
                              child: ReusableText(
                                text: tag,
                                style: appBarTextStyle(
                                  12,
                                  Colors.black,
                                  FontWeight.w400,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                SizedBox(
                  height: 10.h,
                ),
                ReusableText(
                  text: 'Additives and Toppings',
                  style: appBarTextStyle(
                    18,
                    Colors.black,
                    FontWeight.w600,
                  ),
                ),
                SizedBox(
                  height: 10.h,
                ),
                SizedBox(
                  height: 20.h,
                ),
                Obx(
                  () => Column(
                    children: List.generate(
                      controller.additivesList.length,
                      (i) {
                        final additive = controller.additivesList[i];
                        return CheckboxListTile(
                          contentPadding: EdgeInsets.zero,
                          visualDensity: VisualDensity.compact,
                          dense: true,
                          activeColor: Tcolor.primary,
                          value: additive.isChecked.value,
                          title: Row(
                            children: [
                              ReusableText(
                                text: additive.title,
                                style: appBarTextStyle(
                                  14,
                                  Colors.black,
                                  FontWeight.w400,
                                ),
                              ),
                              const Spacer(),
                              ReusableText(
                                text: '\$${additive.price}',
                                style: appBarTextStyle(
                                  12,
                                  Tcolor.primary,
                                  FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                          onChanged: (bool? value) {
                            additive.toggleChecked();
                            controller.getTotalPrice();
                          },
                        );
                      },
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ReusableText(
                      text: "Quantity",
                      style: appBarTextStyle(
                        17,
                        Colors.black,
                        FontWeight.w600,
                      ),
                    ),
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            controller.decrementCount();
                          },
                          child: const Icon(AntDesign.minuscircle,
                              color: Colors.black),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Obx(
                            () => ReusableText(
                              text: controller.count.value.toString(),
                              style: appBarTextStyle(
                                14,
                                Colors.black,
                                FontWeight.w400,
                              ),
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            controller.incrementCount();
                          },
                          child: const Icon(
                            AntDesign.pluscircle,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    )
                  ],
                ),
                SizedBox(
                  height: 20.h,
                ),
                ReusableText(
                  text: 'Preferences',
                  style: appBarTextStyle(
                    18,
                    Colors.black,
                    FontWeight.w600,
                  ),
                ),
                SizedBox(
                  height: 10.h,
                ),
                SizedBox(
                  height: 65.h,
                  child: CustomSearchField(
                    controller: _searchController,
                    hintText: 'Add a note with your order',
                    onEditingComplete: () {
                      FocusScope.of(context).unfocus();
                    },
                    maxLines: 3,
                  ),
                ),
                SizedBox(
                  height: 10.h,
                ),
                Container(
                  height: 40.h,
                  decoration: BoxDecoration(
                    color: Tcolor.primary,
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () {
                          _showVerificationSheet(context).then((value) {
                            if (value != null) {
                              Get.back();
                            }
                          });
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12.0),
                          child: ReusableText(
                            text: 'Place Order',
                            style: appBarTextStyle(
                              16,
                              Colors.white,
                              FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 5.w),
                      GestureDetector(
                        onTap: () {},
                        child: CircleAvatar(
                          radius: 20.r,
                          backgroundColor: Colors.deepPurple,
                          child: IconButton(
                            onPressed: () {
                              // Add your order placement logic here
                            },
                            icon: const Icon(
                              Ionicons.cart,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<dynamic> _showVerificationSheet(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.r),
          topRight: Radius.circular(20.r),
        ),
      ),
      builder: (context) {
        return Container(
          height: 500.h,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20.r),
              topRight: Radius.circular(20.r),
            ),
          ),
          child: Padding(
            padding: EdgeInsets.all(8.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 10.h),
                ReusableText(
                  text: 'Verify your Phone Number',
                  style: appBarTextStyle(
                    18,
                    Tcolor.primary,
                    FontWeight.w600,
                  ),
                ),
                SizedBox(
                  height: 300.h,
                  child: Column(
                    children: List.generate(
                      verificationReasons.length,
                      (i) {
                        return ListTile(
                          contentPadding: EdgeInsets.zero,
                          visualDensity: VisualDensity.compact,
                          dense: true,
                          leading: Icon(
                            Icons.check_circle_outline,
                            color: Tcolor.primary,
                          ),
                          title: Text(
                            verificationReasons[i],
                            textAlign: TextAlign.justify,
                            style: appBarTextStyle(
                              11,
                              Colors.grey,
                              FontWeight.w400,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                SizedBox(height: 10.h),
                CustomButton(
                  text: 'Verify',
                  ontap: () {
                    Get.to(() => const PhoneVerificationPage());
                  },
                  height: 35.h,
                  color: Tcolor.primary,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
