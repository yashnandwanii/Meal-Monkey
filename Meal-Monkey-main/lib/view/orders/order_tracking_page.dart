import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food_delivery_app/common/app_style.dart';
import 'package:food_delivery_app/common/color_extension.dart';
import 'package:food_delivery_app/common/reusable_text.dart';
import 'package:food_delivery_app/view/main_tabview/main_tabview.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:get/get.dart';
import 'dart:async';

class OrderTrackingPage extends StatefulWidget {
  const OrderTrackingPage({super.key});

  @override
  State<OrderTrackingPage> createState() => _OrderTrackingPageState();
}

class _OrderTrackingPageState extends State<OrderTrackingPage>
    with TickerProviderStateMixin {
  late GoogleMapController mapController;
  late AnimationController _animationController;
  late Animation<double> _progressAnimation;

  // Get order details from arguments
  Map<String, dynamic> get orderDetails => Get.arguments ?? {};

  // Order status tracking
  int currentStep =
      1; // 0: Confirmed, 1: Preparing, 2: On the way, 3: Delivered
  Timer? _statusTimer;

  // Sample coordinates from order details
  LatLng get userLocation => LatLng(
        orderDetails['address']?['latitude'] ?? 23.215158922565934,
        orderDetails['address']?['longitude'] ?? 77.43137374520302,
      );

  LatLng get restaurantLocation => LatLng(
        // Use actual restaurant coordinates from order or default to nearby location
        orderDetails['restaurant']?['latitude'] ?? 23.220158922565934,
        orderDetails['restaurant']?['longitude'] ?? 77.43837374520302,
      );

  // Simulated delivery boy location (moving towards user)
  LatLng deliveryBoyLocation = const LatLng(23.217, 77.435);

  Set<Marker> markers = {};
  Set<Polyline> polylines = {};

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _initializeMap();
    _startOrderTracking();
  }

  void _setupAnimations() {
    _animationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _progressAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    _animationController.repeat();
  }

  void _initializeMap() {
    _createMarkers();
    _createPolylines();
  }

  void _createMarkers() {
    markers = {
      Marker(
        markerId: const MarkerId('user'),
        position: userLocation,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
        infoWindow: const InfoWindow(
          title: 'Your Location',
          snippet: 'Delivery Address',
        ),
      ),
      Marker(
        markerId: const MarkerId('restaurant'),
        position: restaurantLocation,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange),
        infoWindow: InfoWindow(
          title: orderDetails['restaurant']?['name'] ?? 'Restaurant',
          snippet: 'Preparing your order',
        ),
      ),
      Marker(
        markerId: const MarkerId('delivery'),
        position: deliveryBoyLocation,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
        infoWindow: const InfoWindow(
          title: 'Delivery Partner',
          snippet: 'On the way',
        ),
      ),
    };
  }

  void _createPolylines() {
    polylines = {
      Polyline(
        polylineId: const PolylineId('route'),
        points: [restaurantLocation, deliveryBoyLocation, userLocation],
        color: Tcolor.primary,
        width: 4,
        patterns: [PatternItem.dash(20), PatternItem.gap(10)],
      ),
    };
  }

  void _startOrderTracking() {
    _statusTimer = Timer.periodic(const Duration(seconds: 15), (timer) {
      if (mounted && currentStep < 3) {
        setState(() {
          currentStep++;
          if (currentStep == 2) {
            // Simulate delivery boy moving
            _simulateDeliveryMovement();
          }
        });
      } else {
        timer.cancel();
      }
    });
  }

  void _simulateDeliveryMovement() {
    // Simulate delivery boy moving towards user location
    Timer.periodic(const Duration(seconds: 5), (timer) {
      if (mounted && currentStep == 2) {
        setState(() {
          // Move delivery boy closer to user
          double lat = deliveryBoyLocation.latitude +
              (userLocation.latitude - deliveryBoyLocation.latitude) * 0.1;
          double lng = deliveryBoyLocation.longitude +
              (userLocation.longitude - deliveryBoyLocation.longitude) * 0.1;

          deliveryBoyLocation = LatLng(lat, lng);
          _createMarkers();
          _createPolylines();
        });
      } else {
        timer.cancel();
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    _statusTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Tcolor.primary,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Get.offAll(
            () => const MainTabview(),
            transition: Transition.leftToRight,
            duration: const Duration(milliseconds: 300),
          ),
        ),
        title: ReusableText(
          text: "Track Order",
          style: appBarTextStyle(18, Colors.white, FontWeight.w600),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.support_agent, color: Colors.white),
            onPressed: () {
              // Open support chat
            },
          ),
        ],
      ),
      body: Column(
        children: [
          _buildOrderHeader(),
          _buildOrderStatus(),
          _buildMapView(),
          _buildOrderDetails(),
          _buildDeliveryInfo(),
        ],
      ),
    );
  }

  Widget _buildOrderHeader() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Tcolor.primary,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(20.r),
          bottomRight: Radius.circular(20.r),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ReusableText(
                    text:
                        "Order #${orderDetails['orderId']?.substring(0, 8) ?? 'N/A'}",
                    style: appBarTextStyle(16, Colors.white, FontWeight.w600),
                  ),
                  SizedBox(height: 4.h),
                  ReusableText(
                    text: orderDetails['restaurant']?['name'] ?? 'Restaurant',
                    style: appBarTextStyle(14, Colors.white70, FontWeight.w400),
                  ),
                ],
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AnimatedBuilder(
                      animation: _progressAnimation,
                      builder: (context, child) {
                        return Transform.scale(
                          scale: 1.0 + (_progressAnimation.value * 0.1),
                          child: Icon(
                            Icons.access_time,
                            color: Colors.white,
                            size: 16.sp,
                          ),
                        );
                      },
                    ),
                    SizedBox(width: 4.w),
                    ReusableText(
                      text:
                          "${orderDetails['estimatedDeliveryTime'] ?? '30'} mins",
                      style: appBarTextStyle(14, Colors.white, FontWeight.w500),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildOrderStatus() {
    List<String> statusTitles = [
      'Order Confirmed',
      'Preparing Food',
      'On the Way',
      'Delivered'
    ];

    List<IconData> statusIcons = [
      Icons.check_circle,
      Icons.restaurant,
      Icons.delivery_dining,
      Icons.home
    ];

    return Container(
      padding: EdgeInsets.all(10.w),
      child: Row(
        children: List.generate(statusTitles.length, (index) {
          bool isActive = index <= currentStep;
          bool isCurrent = index == currentStep;

          return Expanded(
            child: Column(
              children: [
                Row(
                  children: [
                    if (index > 0)
                      Expanded(
                        child: Container(
                          height: 2.h,
                          color: index <= currentStep
                              ? Tcolor.primary
                              : Colors.grey[300],
                        ),
                      ),
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 500),
                      width: 40.w,
                      height: 40.w,
                      decoration: BoxDecoration(
                        color: isActive ? Tcolor.primary : Colors.grey[300],
                        shape: BoxShape.circle,
                        boxShadow: isCurrent
                            ? [
                                BoxShadow(
                                  color: Tcolor.primary.withOpacity(0.3),
                                  blurRadius: 8,
                                  spreadRadius: 2,
                                ),
                              ]
                            : null,
                      ),
                      child: Icon(
                        statusIcons[index],
                        color: isActive ? Colors.white : Colors.grey[600],
                        size: 20.sp,
                      ),
                    ),
                    if (index < statusTitles.length - 1)
                      Expanded(
                        child: Container(
                          height: 2.h,
                          color: index < currentStep
                              ? Tcolor.primary
                              : Colors.grey[300],
                        ),
                      ),
                  ],
                ),
                SizedBox(height: 4.h),
                Text(
                  statusTitles[index],
                  style: TextStyle(
                    fontSize: 10.sp,
                    fontWeight: isCurrent ? FontWeight.w600 : FontWeight.w400,
                    color: isActive ? Tcolor.primary : Colors.grey[600],
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget _buildMapView() {
    return Container(
      height: 250.h,
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12.r),
        child: GoogleMap(
          initialCameraPosition: CameraPosition(
            target: LatLng(
              (userLocation.latitude + restaurantLocation.latitude) / 2,
              (userLocation.longitude + restaurantLocation.longitude) / 2,
            ),
            zoom: 12.0,
          ),
          markers: markers,
          polylines: polylines,
          onMapCreated: (GoogleMapController controller) {
            mapController = controller;
          },
          myLocationEnabled: false,
          compassEnabled: false,
          mapToolbarEnabled: false,
          zoomControlsEnabled: false,
        ),
      ),
    );
  }

  Widget _buildOrderDetails() {
    return Container(
      margin: EdgeInsets.all(16.w),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ReusableText(
            text: "Order Details",
            style: appBarTextStyle(16, Colors.black87, FontWeight.w600),
          ),
          SizedBox(height: 12.h),
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8.r),
                child: Container(
                  width: 50.w,
                  height: 50.w,
                  color: Colors.grey[200],
                  child: orderDetails['food']?['imageUrl'] != null
                      ? Image.network(
                          orderDetails['food']['imageUrl'],
                          fit: BoxFit.cover,
                        )
                      : Icon(Icons.fastfood, color: Colors.grey[400]),
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ReusableText(
                      text: orderDetails['food']?['name'] ?? 'Food Item',
                      style:
                          appBarTextStyle(14, Colors.black87, FontWeight.w500),
                    ),
                    SizedBox(height: 4.h),
                    ReusableText(
                      text:
                          "Qty: ${orderDetails['orderDetails']?['quantity'] ?? 1}",
                      style: appBarTextStyle(
                          12, Colors.grey[600]!, FontWeight.w400),
                    ),
                  ],
                ),
              ),
              ReusableText(
                text:
                    "₹${orderDetails['orderDetails']?['totalAmount']?.toStringAsFixed(2) ?? '0.00'}",
                style: appBarTextStyle(14, Tcolor.primary, FontWeight.w600),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDeliveryInfo() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w).copyWith(bottom: 20.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Tcolor.primary.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Tcolor.primary.withOpacity(0.2)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ReusableText(
                    text: "Delivery Partner",
                    style: appBarTextStyle(14, Colors.black87, FontWeight.w600),
                  ),
                  SizedBox(height: 4.h),
                  ReusableText(
                    text: "Rahul Kumar",
                    style:
                        appBarTextStyle(12, Colors.grey[600]!, FontWeight.w400),
                  ),
                ],
              ),
              Row(
                children: [
                  IconButton(
                    onPressed: () {
                      // Call delivery partner
                    },
                    icon: Icon(
                      Icons.phone,
                      color: Tcolor.primary,
                      size: 20.sp,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      // Message delivery partner
                    },
                    icon: Icon(
                      Icons.message,
                      color: Tcolor.primary,
                      size: 20.sp,
                    ),
                  ),
                ],
              ),
            ],
          ),
          Divider(color: Colors.grey[300]),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ReusableText(
                text: "Estimated Arrival",
                style: appBarTextStyle(14, Colors.black87, FontWeight.w500),
              ),
              ReusableText(
                text: "${orderDetails['estimatedDeliveryTime'] ?? 30} minutes",
                style: appBarTextStyle(14, Tcolor.primary, FontWeight.w600),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
