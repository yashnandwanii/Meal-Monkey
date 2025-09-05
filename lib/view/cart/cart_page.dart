import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food_delivery_app/common/color_extension.dart';
import 'package:food_delivery_app/common/constants.dart';
import 'package:food_delivery_app/common/shimmers/foodlist_shimmer.dart';
import 'package:food_delivery_app/controllers/login_controller.dart';
import 'package:food_delivery_app/controllers/cart_controller.dart';
import 'package:food_delivery_app/hooks/fetch_cart.dart';
import 'package:food_delivery_app/models/cart_response.dart';
import 'package:food_delivery_app/models/login_response.dart';
import 'package:food_delivery_app/routes/routes.dart';
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

    user = controller.getUserInfo();
    print(user!.email.toString());

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

    if (!user.verification) {
      return const VerificationPage();
    }

    // Cart fetching hook
    final hookResults = useFetchCart();
    final List<CartResponse> carts = hookResults.data ?? [];
    final isLoading = hookResults.isLoading;
    final refetch = hookResults.refetch;
    print(carts.length);

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
          if (carts.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete_outline),
              onPressed: () => showClearCartDialog(carts),
            ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
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
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: CartTile(
                                cart: cart,
                                color: Colors.white,
                                refetch: refetch,
                              ),
                            );
                          },
                        ),
            ),
            // Bottom Button
            if (!isLoading && carts.isNotEmpty)
              Container(
                width: double.infinity,
                padding: EdgeInsets.only(bottom: 40.h, left: 20.w, right: 20.w),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    backgroundColor: Tcolor.primary,
                    textStyle: const TextStyle(fontSize: 18),
                  ),
                  onPressed: () {
                    proceedToCheckout(carts);
                  },
                  child: const Text(
                    'Proceed to Checkout',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  void proceedToCheckout(List<CartResponse> carts) {
    if (carts.isEmpty) {
      Get.snackbar(
        'Empty Cart',
        'Please add some items to your cart first',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
      return;
    }

    // Calculate total
    final subtotal =
        carts.fold<double>(0, (sum, item) => sum + item.totalPrice);
    final deliveryFee = 20.0; // Default delivery fee
    final total = subtotal + deliveryFee;

    // Show checkout confirmation dialog
    Get.dialog(
      AlertDialog(
        title: Text('Checkout Confirmation'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
                'Restaurant: ${carts.first.productId.restaurent.coords.title}'),
            SizedBox(height: 8),
            Text('Items: ${carts.length}'),
            SizedBox(height: 8),
            Text('Subtotal: ₹${subtotal.toStringAsFixed(2)}'),
            Text('Delivery: ₹${deliveryFee.toStringAsFixed(2)}'),
            Divider(),
            Text('Total: ₹${total.toStringAsFixed(2)}',
                style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 16),
            Text(
                'Note: This will navigate you to the full checkout process where you can select address and complete payment.',
                style: TextStyle(fontSize: 12, color: Colors.grey[600])),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back();
              // Navigate to cart order page for full checkout
              Get.toNamed(RouteNames.cartCheckout, arguments: carts);
            },
            child: Text('Proceed'),
          ),
        ],
      ),
    );
  }

  void showClearCartDialog(List<CartResponse> carts) {
    Get.dialog(
      AlertDialog(
        title: Text('Clear Cart'),
        content: Text(
            'Are you sure you want to clear all ${carts.length} items from your cart?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Get.back();
              clearAllCartItems();
            },
            child: Text('Clear All', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void clearAllCartItems() async {
    try {
      final controller = Get.put(CartController());
      await controller.clearCart();
      Get.snackbar(
        'Cart Cleared',
        'All items have been removed from your cart',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to clear cart: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }
}
