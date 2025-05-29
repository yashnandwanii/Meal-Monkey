import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food_delivery_app/common/app_style.dart';
import 'package:food_delivery_app/common/color_extension.dart';
import 'package:food_delivery_app/common/reusable_text.dart';

class RestaurentTile extends StatelessWidget {
  const RestaurentTile({super.key, required this.restaurant});

  final dynamic restaurant;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: Stack(
        clipBehavior: Clip.hardEdge,
        children: [
          Container(
            margin: EdgeInsets.only(bottom: 8.h),
            width: MediaQuery.of(context).size.width,
            height: 70.h,
            decoration: BoxDecoration(
              color: Colors.white60,
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
                            restaurant['imageUrl'],
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
                        text: restaurant['title'],
                        style: appBarTextStyle(
                          11,
                          Colors.black,
                          FontWeight.w400,
                        ),
                      ),
                      ReusableText(
                        text: "Delivery Time: ${restaurant['time']} min",
                        style: appBarTextStyle(
                          11,
                          Colors.grey,
                          FontWeight.w400,
                        ),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.7,
                        child: Text(
                          restaurant['coords']['address'] ?? '',
                          style: appBarTextStyle(
                            9,
                            Colors.grey,
                            FontWeight.w400,
                          ),
                          overflow: TextOverflow.ellipsis,
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
                color: restaurant['isAvailable'] == true ||
                        restaurant['isAvailable'] == null
                    ? Colors.lightGreen
                    : Colors.grey,
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Center(
                child: ReusableText(
                  text: restaurant['isAvailable'] == true ||
                          restaurant['isAvailable'] == null
                      ? "Open"
                      : "Closed",
                  style: appBarTextStyle(
                    12,
                    Colors.white,
                    FontWeight.w500,
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
