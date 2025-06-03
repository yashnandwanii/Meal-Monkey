// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:food_delivery_app/common/app_style.dart';
import 'package:food_delivery_app/common/color_extension.dart';
import 'package:food_delivery_app/common/reusable_text.dart';
import 'package:food_delivery_app/models/foods.dart';

class FoodTile extends StatelessWidget {
  FoodTile({super.key, required this.food, this.color});

  FoodItem food;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        
      },
      child: Stack(
        clipBehavior: Clip.hardEdge,
        children: [
          Container(
            margin: EdgeInsets.only(bottom: 8.h),
            width: MediaQuery.of(context).size.width,
            height: 70.h,
            decoration: BoxDecoration(
              color: color ?? Colors.grey.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(9.r),
            ),
            child: Container(
              padding: EdgeInsets.all(4.r),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8.r),
                    child: Stack(
                      children: [
                        SizedBox(
                          height: 70.h,
                          width: 70.w,
                          child: Image.network(
                            food.imageUrl[0],
                            fit: BoxFit.cover,
                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          child: Container(
                            padding: EdgeInsets.only(
                              left: 6.w,
                              bottom: 2.h,
                            ),
                            color: Colors.grey.withValues(alpha: 0.6),
                            height: 16.h,
                            width: MediaQuery.of(context).size.width,
                            child: RatingBarIndicator(
                              itemBuilder: (context, i) {
                                return Icon(
                                  Icons.star,
                                  color: Tcolor.primary,
                                );
                              },
                              itemSize: 15.r,
                              rating: 5,
                              unratedColor: Colors.white54,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 8.w,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ReusableText(
                        text: food.title,
                        style: appBarTextStyle(
                          13,
                          Colors.black,
                          FontWeight.w600,
                        ),
                      ),
                      ReusableText(
                        text: "Delivery Time: ${food.time}",
                        style: appBarTextStyle(
                          11,
                          Colors.grey,
                          FontWeight.w400,
                        ),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.7,
                        height: 15.h,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: food.additives.length,
                          itemBuilder: (context, index) {
                            var additive = food.additives[index];
                            return Container(
                              margin: EdgeInsets.only(right: 5.w),
                              decoration: BoxDecoration(
                                color: Colors.blue.withValues(alpha: 0.2),
                                borderRadius: BorderRadius.all(
                                  Radius.circular(9.r),
                                ),
                              ),
                              child: Center(
                                child: Padding(
                                  padding: EdgeInsets.all(2.h),
                                  child: ReusableText(
                                    text: additive.title,
                                    style: appBarTextStyle(
                                      8,
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
                    ],
                  )
                ],
              ),
            ),
          ),
          Positioned(
            right: 5.w,
            top: 6.h,
            child: Container(
              width: 60.w,
              height: 19.h,
              decoration: BoxDecoration(
                color: Colors.lightGreen,
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Center(
                child: ReusableText(
                  text: "\$ ${food.price.toStringAsFixed(2)}",
                  style: appBarTextStyle(
                    12,
                    Colors.white,
                    FontWeight.w500,
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            right: 75.w,
            top: 6.h,
            child: GestureDetector(
              onTap: () {},
              child: Container(
                width: 19.w,
                height: 19.h,
                decoration: BoxDecoration(
                  color: Colors.orange,
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Center(
                  child: Icon(
                    MaterialCommunityIcons.cart_plus,
                    size: 15.h,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
