import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:food_delivery_app/common/constants.dart';
import 'package:food_delivery_app/common/custom_container.dart';
import 'package:food_delivery_app/common/shimmers/foodlist_shimmer.dart';
import 'package:food_delivery_app/controllers/login_controller.dart';
import 'package:food_delivery_app/hooks/fetch_cart.dart';
import 'package:food_delivery_app/models/cart_response.dart';
import 'package:food_delivery_app/models/login_response.dart';
import 'package:food_delivery_app/view/auth/verification_page.dart';
import 'package:food_delivery_app/view/cart/widgets/cart_tile.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class CartPage extends HookWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    final box = GetStorage();
    final hookResults = useFetchCart();
    final List<CartResponse> carts = hookResults.data ?? [];
    final isLoading = hookResults.isLoading;
    final apiError = hookResults.error;
    final refetch = hookResults.refetch;
    LoginResponse? user;

    final controller = Get.put(LoginController());

    String? token = box.read('token');
    if (token != null) {
      user = controller.getUserInfo();
      // debugPrint('User Info: ${user?.username}, ${user?.email}');
    }
    if (token == null) {
      return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text('Cart'),
          centerTitle: true,
        ),
        body: const Center(
          child: Text(
            'Please log in to view your cart',
            style: TextStyle(fontSize: 16, color: Colors.black54),
          ),
        ),
      );
    }

    if (user != null && user.verification == false) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Get.offAll(() => const VerificationPage());
      });
    }

    return Scaffold(
      backgroundColor: offWhite,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: offWhite,
        title: const Text('Cart'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: refetch,
          ),
        ],
      ),
      body: SafeArea(
        child: CustomContainer(
          containerContent: isLoading
              ? const FoodListShimmer(
                  scrollDirection: Axis.vertical,
                )
              : SizedBox(
                  width: 50,
                  child: ListView.builder(
                    itemCount: carts.length,
                    itemBuilder: (context, index) {
                      var cart = carts[index];
                      return CartTile(cart: cart);
                    },
                  ),
                ),
        ),
      ),
    );
  }
}
