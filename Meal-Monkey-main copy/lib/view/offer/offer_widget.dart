import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food_delivery_app/common/app_style.dart';
import 'package:food_delivery_app/common/reusable_text.dart';

class OfferWidget extends StatelessWidget {
  const OfferWidget(
      {super.key,
      required this.image,
      required this.logo,
      required this.title,
      required this.time,
      required this.rating,
      this.onTap});
  final String image;
  final String logo;
  final String title;
  final String time;
  final String rating;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.only(right: 12.w),
        child: Container(
          width: double.infinity,
          height: 200.h,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: ListView(
            physics: const NeverScrollableScrollPhysics(),
            children: [
              Padding(
                padding: EdgeInsets.all(8.w),
                child: Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12.r),
                      child: SizedBox(
                        height: 130.h,
                        width: width * 0.9,
                        child: Image.network(
                          image,
                          fit: BoxFit.fitWidth,
                        ),
                      ),
                    ),
                    Positioned(
                      right: 10.w,
                      top: 10.h,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(50.r),
                        child: Container(
                          color: Colors.white70,
                          child: Padding(
                            padding: EdgeInsets.all(2.h),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(50.r),
                              child: Image.network(
                                logo,
                                height: 30.h,
                                width: 30.w,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 12.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ReusableText(
                      text: title,
                      style: appBarTextStyle(
                        12,
                        Colors.black,
                        FontWeight.w500,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ReusableText(
                          text: 'Delivery time',
                          style: appBarTextStyle(
                            9,
                            Colors.grey,
                            FontWeight.w500,
                          ),
                        ),
                        ReusableText(
                          text: time,
                          style: appBarTextStyle(
                            9,
                            Colors.black,
                            FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 4.h),
                    Row(
                      children: [
                        RatingBarIndicator(
                          itemBuilder: (context, index) => const Icon(
                            Icons.star,
                            color: Color(0xffFC6011),
                          ),
                          itemCount: 5,
                          itemSize: 15.h,
                        ),
                        SizedBox(width: 10.w),
                        ReusableText(
                          text: '$rating reviews and ratings',
                          style: appBarTextStyle(
                            9,
                            Colors.grey,
                            FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
