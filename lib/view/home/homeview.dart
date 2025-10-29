import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food_delivery_app/common/constants.dart';
import 'package:food_delivery_app/common/custom_container.dart';
import 'package:food_delivery_app/common/heading.dart';
import 'package:food_delivery_app/common_widgets/custom_appbar.dart';
import 'package:food_delivery_app/controllers/category_controller.dart';
import 'package:food_delivery_app/view/category/all_categories.dart';
import 'package:food_delivery_app/view/home/all_fastest_foods.dart';
import 'package:food_delivery_app/view/home/all_nearby_restaurents.dart';
import 'package:food_delivery_app/view/home/recommendations.dart';
import 'package:food_delivery_app/view/home/widgets/category_foods_list.dart';
import 'package:food_delivery_app/view/home/widgets/category_list.dart';
import 'package:food_delivery_app/view/home/widgets/food_list.dart';
import 'package:food_delivery_app/view/home/widgets/nearby_restaurents_list.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class Homeview extends StatefulWidget {
  const Homeview({super.key});
  @override
  State<Homeview> createState() => _HomeviewState();
}

class _HomeviewState extends State<Homeview>
    with AutomaticKeepAliveClientMixin {
  final GetStorage box = GetStorage();
  final TextEditingController txtController = TextEditingController();
  late CategoryController controller;
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
      controller = Get.put(CategoryController());
      _isInitialized = true;
      print('HomeView: Controller initialized and data loaded');
    } else {
      controller = Get.find<CategoryController>();
      print('HomeView: Using existing controller - data preserved');
    }
  }

  @override
  void dispose() {
    txtController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context); // Required for AutomaticKeepAliveClientMixin

    return Scaffold(
      backgroundColor: offWhite,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(130.h),
        child: const CustomAppbar(),
      ),
      body: SafeArea(
        child: CustomContainer(
          containerContent: Column(
            children: [
              const CategoryList(),
              Obx(
                () {
                  if (controller.categoryValue == '') {
                    return Column(
                      children: [
                        Heading(
                          title: 'Nearby Restaurants',
                          onTap: () {
                            Get.to(
                              () => const AllNearbyRestaurents(),
                              transition: Transition.rightToLeft,
                              duration: const Duration(milliseconds: 500),
                            );
                          },
                        ),
                        const NearbyRestaurents(),
                        Heading(
                          title: 'Try Something New',
                          onTap: () {
                            Get.to(
                              () => const Recommendations(),
                              transition: Transition.rightToLeft,
                              duration: const Duration(milliseconds: 500),
                            );
                          },
                        ),
                        const FoodList(
                          code: '41007428',
                          type: 'recommendation',
                        ),
                        Heading(
                          title: 'Food Closer to you',
                          onTap: () {
                            Get.to(
                              () => const AllFastestFoods(),
                              transition: Transition.rightToLeft,
                              duration: const Duration(milliseconds: 500),
                            );
                          },
                        ),
                        const FoodList(
                          code: '41007428',
                          type: 'random',
                        ),
                      ],
                    );
                  } else if (controller.titleValue == 'more' ||
                      controller.categoryValue == 'more' ||
                      controller.titleValue == 'More') {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      Get.to(
                          () => const AllCategories()); // or your target screen
                    });
                    Future.delayed(Duration.zero, () {
                      controller.updateCategory = '';
                      controller.updateTitle = '';
                    });

                    return const SizedBox.shrink();
                  } else {
                    return CustomContainer(
                      containerContent: Column(
                        children: [
                          Heading(
                            moreButton: true,
                            title: 'Explore ${controller.titleValue} Category',
                            onTap: () {
                              Get.to(
                                () => const AllNearbyRestaurents(),
                                transition: Transition.rightToLeft,
                                duration: const Duration(milliseconds: 500),
                              );
                            },
                          ),
                          const CategoryFoodsList()
                        ],
                      ),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
