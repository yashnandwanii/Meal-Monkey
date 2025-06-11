import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food_delivery_app/common/app_style.dart';
import 'package:food_delivery_app/common/color_extension.dart';
import 'package:food_delivery_app/common/reusable_text.dart';
import 'package:food_delivery_app/controllers/user_location_controller.dart';

import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../models/login_response.dart';

class CustomAppbar extends StatefulHookWidget {
  const CustomAppbar({super.key});

  @override
  State<CustomAppbar> createState() => _CustomAppbarState();
}

class _CustomAppbarState extends State<CustomAppbar> {
  LoginResponse? user;
  final UserLocationController _userLocationController =
      Get.put(UserLocationController());
  String _currentLocation = '';
  String getTimeOfDay() {
    DateTime now = DateTime.now();
    int hour = now.hour;

    if (hour >= 0 && hour < 12) {
      return '☀️';
    } else if (hour >= 12 && hour < 16) {
      return '🌤️';
    } else {
      return '🌙';
    }
  }

  @override
  void initState() {
    super.initState();
    _determinePosition();
  }

  Future<void> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    _getCurrentLocation();
    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return;
  }

  Future<void> _getCurrentLocation() async {
    final controller = Get.put(UserLocationController());
    try {
      Position position = await Geolocator.getCurrentPosition();
      LatLng currentLocation = LatLng(position.latitude, position.longitude);
      debugPrint('$currentLocation');

      controller.setPosition(currentLocation);

      controller.getUserAddress(currentLocation);
      if (mounted) {
        setState(() {
          _currentLocation = controller.address;
        });
      }
      debugPrint('Current location: $_currentLocation');
    } catch (e) {
      debugPrint("Error getting location: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h),
      height: 110.h,
      width: width,
      color: Colors.white54,
      child: Container(
        margin: EdgeInsets.only(top: 20.h),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                CircleAvatar(
                  radius: 23.r,
                  backgroundColor: Colors.orange,
                  backgroundImage: NetworkImage(user?.profile ??
                      "https://www.pngall.com/wp-content/uploads/5/User-Profile-PNG-Image.png"),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 6.h, left: 8.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ReusableText(
                        text: "Deliver to",
                        style: appBarTextStyle(
                          15,
                          Tcolor.primary,
                          FontWeight.w600,
                        ),
                      ),
                      Obx(() {
                        final address = _userLocationController.address;
                        return ReusableText(
                          text: address,
                          style: appBarTextStyle(
                            13,
                            Colors.grey,
                            FontWeight.w400,
                          ),
                        );
                      }),
                    ],
                  ),
                ),
              ],
            ),
            Text(
              getTimeOfDay(),
              style: appBarTextStyle(
                40,
                Colors.black,
                FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
