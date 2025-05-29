import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food_delivery_app/common/background_container.dart';
import 'package:food_delivery_app/common/uidata.dart';
import 'package:food_delivery_app/view/home/widgets/restaurent_tile.dart';

class AllNearbyRestaurents extends StatelessWidget {
  const AllNearbyRestaurents({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nearby Restaurants'),
        centerTitle: true,
        elevation: 0.3,
        backgroundColor: Colors.white70,
      ),
      body: BackgroundContainer(
        color: Colors.white,
        child: Padding(
          padding: EdgeInsets.all(12.h),
          child: ListView(
            scrollDirection: Axis.vertical,
            children: List.generate(
              restaurents.length,
              (index) {
                var restaurant = restaurents[index];
                return RestaurentTile(
                  restaurant: restaurant,
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
