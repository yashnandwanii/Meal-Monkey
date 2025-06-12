import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:food_delivery_app/common/constants.dart';
import 'package:food_delivery_app/common/shimmers/foodlist_shimmer.dart';
import 'package:food_delivery_app/controllers/login_controller.dart';
import 'package:food_delivery_app/hooks/fetch_cart.dart';
import 'package:food_delivery_app/models/cart_response.dart';
import 'package:food_delivery_app/models/login_response.dart';
import 'package:food_delivery_app/view/auth/verification_page.dart';
import 'package:food_delivery_app/view/cart/widgets/cart_tile.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:lottie/lottie.dart';

class CartPage extends HookWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    final box = GetStorage();
    final controller = Get.put(LoginController());

    LoginResponse? user;

    String? token = box.read('token');

    if (token != null) {
      user = controller.getUserInfo();
    }

    if (token == null) {
      return Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('You are not logged in'),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  Get.toNamed('/login');
                },
                child: const Text('Login'),
              ),
            ],
          ),
        ),
      );
    }

    if (user != null && user.verification == false) {
      return const VerificationPage();
    }

    // Cart fetching hook
    final hookResults = useFetchCart();
    final List<CartResponse> carts = hookResults.data ?? [];
    final isLoading = hookResults.isLoading;
    final refetch = hookResults.refetch;

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
        child: isLoading
            ? const FoodListShimmer(scrollDirection: Axis.vertical)
            : carts.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          height: 200,
                          width: 200,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          alignment: Alignment.center,
                          child: Lottie.asset(
                            'assets/empty_cart.json',
                            fit: BoxFit.contain,
                          ),
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          'Your cart is empty',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          'Add some items to your cart',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    itemCount: carts.length,
                    itemBuilder: (context, index) {
                      final cart = carts[index];
                      return CartTile(cart: cart);
                    },
                  ),
      ),
    );
  }
}
