// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:food_delivery_app/common/color_extension.dart';
import 'package:food_delivery_app/common/custom_text_field.dart';
import 'package:food_delivery_app/controllers/search_controller.dart';
import 'package:food_delivery_app/view/menu/menu_items_view.dart';
import 'package:food_delivery_app/view/menu/search_results.dart';
import 'package:food_delivery_app/common_widgets/general_app_bar.dart';
import 'package:get/get.dart';

class MenuView extends StatefulWidget {
  const MenuView({super.key});

  @override
  State<MenuView> createState() => _MenuViewState();
}

class _MenuViewState extends State<MenuView>
    with AutomaticKeepAliveClientMixin {
  TextEditingController txtSearch = TextEditingController();
  late SearchFoodController controller;
  bool _isInitialized = false;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _initializeController();
  }

  void _initializeController() {
    if (!_isInitialized) {
      controller = Get.put(SearchFoodController());
      _isInitialized = true;
      print('MenuView: Controller initialized and data loaded');
    } else {
      controller = Get.find<SearchFoodController>();
      print('MenuView: Using existing controller - data preserved');
    }
  }

  List menuArr = [
    {
      'name': 'Food',
      'image': 'assets/iimg/menu_1.png',
      'item_count': '120',
    },
    {
      'name': 'Beverages',
      'image': 'assets/iimg/menu_2.png',
      'item_count': '220',
    },
    {
      'name': 'Desserts',
      'image': 'assets/iimg/menu_3.png',
      'item_count': '155',
    },
    {
      'name': 'Promotions',
      'image': 'assets/iimg/menu_4.png',
      'item_count': '25',
    },
  ];

  @override
  Widget build(BuildContext context) {
    super.build(context); // Required for AutomaticKeepAliveClientMixin

    var media = MediaQuery.of(context).size;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(40.h),
        child: const GeneralAppBar(title: 'Menu'),
      ),
      backgroundColor: Tcolor.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            CustomSearchField(
              controller: txtSearch,
              hintText: 'Search for menu items',
              obscureText: false,
              onEditingComplete: () {
                // Implement search functionality here
              },
              suffixIcon: GestureDetector(
                onTap: () {
                  if (controller.isTrigger == false) {
                    controller.searchFoods(txtSearch.text.trim());
                    controller.setTrigger = true;
                  } else {
                    controller.searchResults = null;
                    controller.setTrigger = false;
                    txtSearch.clear();
                    controller.searchFoods(txtSearch.text.trim());
                  }
                },
                child: Obx(
                  () => controller.isTrigger == false
                      ? Icon(
                          Ionicons.search_circle,
                          color: Tcolor.primaryText,
                          size: 40.h,
                        )
                      : const Icon(
                          Ionicons.close_circle,
                          color: Colors.red,
                          size: 40,
                        ),
                ),
              ),
              keyboardType: TextInputType.text,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a search term';
                }
                return null;
              },
            ),
            SizedBox(height: 10.h),
            Obx(
              () {
                if (controller.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (controller.isTrigger &&
                    controller.searchResults != null &&
                    controller.searchResults!.isNotEmpty) {
                  // Show search results list
                  return const SearchResults();
                } else {
                  // Show the original Stack section
                  return Stack(
                    alignment: Alignment.centerLeft,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(top: 10),
                        width: media.width * 0.27,
                        height: media.height * 0.55,
                        decoration: BoxDecoration(
                          color: Tcolor.primary,
                          borderRadius: const BorderRadius.only(
                            topRight: Radius.circular(35),
                            bottomRight: Radius.circular(35),
                          ),
                        ),
                      ),
                      SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 20),
                          child: Column(
                            children: [
                              ListView.builder(
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                padding: const EdgeInsets.symmetric(
                                    vertical: 30, horizontal: 20),
                                itemCount: menuArr.length,
                                itemBuilder: ((context, index) {
                                  var mObj = menuArr[index] as Map? ?? {};
                                  return GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              MenuItemView(mObj: mObj),
                                        ),
                                      );
                                    },
                                    child: Stack(
                                      alignment: Alignment.centerRight,
                                      children: [
                                        Container(
                                          margin: const EdgeInsets.only(
                                              top: 10, bottom: 10, right: 20),
                                          width: media.width - 100,
                                          height: 100,
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            boxShadow: const [
                                              BoxShadow(
                                                color: Colors.black12,
                                                blurRadius: 7,
                                                offset: Offset(0, 4),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Image.asset(
                                              mObj['image'].toString(),
                                              width: 80,
                                              height: 80,
                                              fit: BoxFit.contain,
                                            ),
                                            const SizedBox(
                                              width: 15,
                                            ),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    mObj['name'].toString(),
                                                    style: TextStyle(
                                                      color: Tcolor.primaryText,
                                                      fontSize: 24,
                                                      fontWeight:
                                                          FontWeight.w800,
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    height: 4,
                                                  ),
                                                  Text(
                                                    '${mObj['item_count'].toString()} items',
                                                    style: TextStyle(
                                                      color:
                                                          Tcolor.secondaryText,
                                                      fontSize: 13,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            Container(
                                              width: 35,
                                              height: 35,
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                                boxShadow: const [
                                                  BoxShadow(
                                                    color: Colors.black12,
                                                    blurRadius: 4,
                                                    offset: Offset(0, 2),
                                                  ),
                                                ],
                                              ),
                                              alignment: Alignment.center,
                                              child: Image.asset(
                                                'assets/iimg/btn_next.png',
                                                width: 15,
                                                height: 15,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  );
                                }),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
