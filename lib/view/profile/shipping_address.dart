// ignore_for_file: prefer_const_constructors

import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:food_delivery_app/common/app_style.dart';
import 'package:food_delivery_app/common/background_container.dart';
import 'package:food_delivery_app/common/color_extension.dart';
import 'package:food_delivery_app/common/constants.dart';
import 'package:food_delivery_app/common/custom_button.dart';
import 'package:food_delivery_app/common/reusable_text.dart';
import 'package:food_delivery_app/common_widgets/input_field.dart';
import 'package:food_delivery_app/common_widgets/round_textfield.dart';
import 'package:food_delivery_app/controllers/user_location_controller.dart';
import 'package:food_delivery_app/models/address_model.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

class ShippingAddressPage extends StatefulWidget {
  const ShippingAddressPage({super.key});

  @override
  State<ShippingAddressPage> createState() => _ShippingAddressPageState();
}

class _ShippingAddressPageState extends State<ShippingAddressPage> {
  late final PageController _pageController = PageController(initialPage: 0);
  GoogleMapController? _mapController;
  LatLng? _selectedLocation;
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _postalCode = TextEditingController();
  final TextEditingController _instructions = TextEditingController();
  List<dynamic> _placeList = [];
  List<dynamic> _selectedPlace = [];

  @override
  void initState() {
    super.initState();
    _pageController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    _searchController.dispose();
    _postalCode.dispose();
    super.dispose();
  }

  void _onSearchSubmitted(String searchQuery) async {
    if (searchQuery.isNotEmpty) {
      final url = Uri.parse(
          'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$searchQuery&key=$googleApiKey');

      final response = await http.get(url);
      //debugPrint('Response status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final data = response.body;

        setState(() {
          _placeList = jsonDecode(data)['predictions'] ?? [];
        });
        //debugPrint('Fetched places: $_placeList');
      } else {
        debugPrint('Error fetching places: ${response.statusCode}');
        setState(() {
          _placeList = [];
        });
      }
    } else {
      _placeList = [];
    }
  }

  void _getPlaceDetails(String placeId) async {
    final url = Uri.parse(
      'https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&key=$googleApiKey',
    );

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final result = data['result'];
      final location = result['geometry']['location'];
      final lat = location['lat'] as double;
      final lng = location['lng'] as double;

      final address = result['formatted_address'] ?? 'No address found';

      String postalCode = "";
      final addressComponents = result['address_components'];

      for (var component in addressComponents) {
        if (component['types'].contains('postal_code')) {
          postalCode = component['long_name'];
          break;
        }
      }

      setState(() {
        _selectedLocation = LatLng(lat, lng);
        _searchController.text = address;
        _placeList = [];
        _postalCode.text = postalCode;
        moveToSelectedPosition();

        _mapController?.animateCamera(
          CameraUpdate.newLatLng(_selectedLocation!),
        );
      });
    } else {
      debugPrint('Error fetching place details: ${response.statusCode}');
      setState(() {
        _selectedLocation = null;
        _searchController.text = '';
        _postalCode.text = '';
        _placeList = [];
      });
    }
  }

  void moveToSelectedPosition() {
    if (_selectedLocation != null && _mapController != null) {
      _mapController!.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: _selectedLocation!,
            zoom: 15,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final locationController = Get.put(UserLocationController());
    return Scaffold(
      backgroundColor: Color(0xFFFAF9F6),
      appBar: AppBar(
        leading: Obx(
          () => Padding(
            padding: EdgeInsets.only(right: 0),
            child: locationController.tabIndex == 0
                ? IconButton(
                    icon: Icon(AntDesign.closecircleo, color: Colors.red),
                    onPressed: () {
                      Get.back();
                    },
                  )
                : IconButton(
                    icon: Icon(
                      AntDesign.leftcircleo,
                      color: Colors.black,
                    ),
                    onPressed: () {
                      locationController.tabIndex = 0;
                      _pageController.previousPage(
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.easeIn,
                      );
                    },
                  ),
          ),
        ),
        actions: [
          Obx(
            () => locationController.tabIndex == 1
                ? const SizedBox.shrink()
                : Padding(
                    padding: EdgeInsets.only(top: 8.h),
                    child: IconButton(
                      onPressed: () {
                        locationController.tabIndex = 1;
                        _pageController.nextPage(
                          duration: const Duration(milliseconds: 500),
                          curve: Curves.easeIn,
                        );
                      },
                      icon: const Icon(
                        AntDesign.rightcircleo,
                        color: Colors.black,
                      ),
                    ),
                  ),
          ),
        ],
        backgroundColor: Colors.white38,
        title: const Text(
          'Shipping Address',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        elevation: 0,
      ),
      body: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: PageView(
          controller: _pageController,
          physics: const NeverScrollableScrollPhysics(),
          pageSnapping: false,
          onPageChanged: (i) {
            // Handle page change if needed
            _pageController.jumpToPage(i);
            debugPrint('Page changed to: $i');
          },
          children: [
            Stack(
              children: [
                GoogleMap(
                  onMapCreated: (GoogleMapController controller) {
                    // Handle map creation if needed
                    _mapController = controller;
                  },
                  initialCameraPosition: CameraPosition(
                    target: _selectedLocation ?? LatLng(28.326276, 76.515098),
                    zoom: 14,
                  ),
                  markers: _selectedLocation == null
                      // ignore: prefer_collection_literals
                      ? Set.of(
                          [
                            Marker(
                              markerId: const MarkerId('Default Location'),
                              position: LatLng(28.326276, 76.515098),
                              draggable: true,
                              onDragEnd: (newPosition) {
                                locationController.getUserAddress(newPosition);
                                setState(() {
                                  _selectedLocation = newPosition;
                                });
                              },
                            ),
                          ],
                        )
                      // ignore: prefer_collection_literals
                      : Set.of(
                          [
                            Marker(
                              markerId: const MarkerId('Your Location'),
                              position: _selectedLocation!,
                              draggable: true,
                              onDragEnd: (newPosition) {
                                locationController.getUserAddress(newPosition);
                                setState(
                                  () {
                                    _selectedLocation = newPosition;
                                  },
                                );
                              },
                            ),
                          ],
                        ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 12.w),
                      color: Color(0xFFFAF9F6),
                      child: TextField(
                        controller: _searchController,
                        decoration: InputDecoration(
                          hintText: 'Search for a location',
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.r),
                            borderSide: BorderSide.none,
                          ),
                          prefixIcon: Icon(Icons.search),
                        ),
                        onSubmitted: (value) {
                          // Handle search submission
                          _onSearchSubmitted(value);
                          debugPrint('Searching for: $value');
                        },
                      ),
                    ),
                    _placeList.isEmpty
                        ? const SizedBox.shrink()
                        : Expanded(
                            child: ListView(
                              children: List.generate(
                                _placeList.length,
                                (i) {
                                  return Container(
                                    color: Colors.white,
                                    child: ListTile(
                                      visualDensity: VisualDensity.compact,
                                      title: Text(
                                        _placeList[i]['description'] ??
                                            'No description',
                                      ),
                                      onTap: () {
                                        _getPlaceDetails(
                                          _placeList[i]['place_id'],
                                        );
                                        _selectedPlace.add(_placeList[i]);
                                      },
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                  ],
                )
              ],
            ),
            BackgroundContainer(
              color: Color(0xFFFAF9F6),
              child: Container(
                child: ListView(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  children: [
                    InputField(
                      hintText: 'Address',
                      controller: _searchController,
                      leadingIcon: Icons.map,
                      keyboardType: TextInputType.number,
                    ),
                    SizedBox(height: 15.h),
                    InputField(
                      hintText: 'Postal Code',
                      controller: _postalCode,
                      leadingIcon: Ionicons.location_sharp,
                      keyboardType: TextInputType.text,
                    ),
                    SizedBox(height: 15.h),
                    InputField(
                      hintText: 'Instructions (optional)',
                      controller: _instructions,
                      leadingIcon: Ionicons.chatbubble,
                      keyboardType: TextInputType.text,
                    ),
                    SizedBox(height: 15.h),
                    Padding(
                      padding: EdgeInsets.only(left: 8.w),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ReusableText(
                            text: 'Set this as default address?',
                            style: appBarTextStyle(
                              12,
                              Colors.black,
                              FontWeight.w600,
                            ),
                          ),
                          Obx(
                            () => CupertinoSwitch(
                                activeTrackColor: Tcolor.primary,
                                thumbColor: Colors.grey,
                                value: locationController.isDefault,
                                onChanged: (value) {
                                  locationController.isDefault = value;
                                  debugPrint('Default address set to: $value');
                                }),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 15.h),
                    CustomButton(
                      text: 'S U B M I T',
                      ontap: () {
                        if (_searchController.text.isNotEmpty &&
                            _postalCode.text.isNotEmpty) {
                          AddressModel model = AddressModel(
                            addressLine1: _searchController.text.trim(),
                            postalCode: _postalCode.text.trim(),
                            addressModelDefault: locationController.isDefault,
                            deliveryInstructions: _instructions.text ?? "",
                            latitude: _selectedLocation!.latitude,
                            longitude: _selectedLocation!.longitude,
                          );

                          String data = addressModelToJson(model);
                        }
                      },
                      height: 45,
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
