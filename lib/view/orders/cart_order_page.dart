import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food_delivery_app/common/color_extension.dart';
import 'package:food_delivery_app/common/constants.dart';
import 'package:food_delivery_app/hooks/fetch_addresses.dart';
import 'package:food_delivery_app/models/addresses_response.dart';
import 'package:food_delivery_app/models/cart_response.dart';
import 'package:food_delivery_app/models/order_request.dart';
import 'package:food_delivery_app/models/order_response.dart';
import 'package:food_delivery_app/models/restaurents.dart' as restaurant_model;
import 'package:food_delivery_app/services/location_service.dart';
import 'package:food_delivery_app/services/payment_service.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:get/get.dart';

class CartOrderPage extends HookWidget {
  const CartOrderPage({
    super.key,
    required this.cartItems,
  });

  final List<CartResponse> cartItems;

  @override
  Widget build(BuildContext context) {
    final razorpay = useMemoized(() {
      try {
        final rzp = Razorpay();
        debugPrint('Razorpay instance created successfully');
        return rzp;
      } catch (e) {
        debugPrint('Error creating Razorpay instance: $e');
        return null;
      }
    });

    final hookResult = useFetchAllAddresses();
    final List<AddressResponse>? addresses = hookResult.data ?? [];
    final isLoadingAddresses = hookResult.isLoading;
    final refetch = hookResult.refetch;

    final selectedAddress = useState<AddressResponse?>(null);
    final isProcessingPayment = useState<bool>(false);
    final currentOrderId = useState<String?>(null);
    final deliveryInfo = useState<DeliveryInfo?>(null);
    final specialInstructions = useState<String>('');

    // Get restaurant info from first cart item (since all items are from same restaurant)
    final restaurant = cartItems.isNotEmpty
        ? restaurant_model.RestaurentsModel(
            id: cartItems.first.productId.restaurent.id,
            title: cartItems.first.productId.restaurent.coords.title,
            time: cartItems.first.productId.restaurent.time,
            imageUrl: "", // Cart doesn't have restaurant image
            foods: [],
            pickup: true,
            delivery: true,
            isAvailable: true,
            owner: "",
            code: "",
            logoUrl: "",
            rating: 4,
            ratingCount: "100+",
            verification: "verified",
            verificationMessage: "",
            coords: restaurant_model.Coords(
              id: cartItems.first.productId.restaurent.coords.id,
              latitude: cartItems.first.productId.restaurent.coords.latitude,
              longitude: cartItems.first.productId.restaurent.coords.longitude,
              address: cartItems.first.productId.restaurent.coords.address,
              title: cartItems.first.productId.restaurent.coords.title,
              latitudeDelta:
                  cartItems.first.productId.restaurent.coords.latitudeDelta,
              longitudeDelta:
                  cartItems.first.productId.restaurent.coords.longitudeDelta,
            ),
            businessHours: cartItems.first.productId.restaurent.time,
          )
        : null;

    // Calculate totals
    final subtotal =
        cartItems.fold<double>(0, (sum, item) => sum + item.totalPrice);
    final deliveryCharge = deliveryInfo.value?.charge ?? 20.0;
    final total = subtotal + deliveryCharge;

    // Setup Razorpay event handlers
    useEffect(() {
      if (razorpay == null) return null;

      void handlePaymentSuccess(PaymentSuccessResponse response) async {
        debugPrint("=== PAYMENT SUCCESS ===");
        debugPrint('Payment ID: ${response.paymentId}');
        debugPrint('Order ID: ${response.orderId}');
        debugPrint('Signature: ${response.signature}');

        handlePaymentSuccessFlow(response, currentOrderId, deliveryInfo,
            selectedAddress, restaurant, cartItems, specialInstructions);
      }

      void handlePaymentError(PaymentFailureResponse response) async {
        handlePaymentErrorFlow(response, currentOrderId);
      }

      void handleExternalWallet(ExternalWalletResponse response) {
        debugPrint("=== EXTERNAL WALLET ===");
        debugPrint('Wallet Name: ${response.walletName}');
      }

      razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, handlePaymentSuccess);
      razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, handlePaymentError);
      razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, handleExternalWallet);

      return () {
        razorpay.clear();
      };
    }, [razorpay]);

    // Calculate delivery charge when address changes
    useEffect(() {
      if (selectedAddress.value != null && restaurant != null) {
        final info = DeliveryInfo.calculate(
          userLat: selectedAddress.value!.latitude,
          userLon: selectedAddress.value!.longitude,
          restaurantLat: restaurant.coords.latitude,
          restaurantLon: restaurant.coords.longitude,
        );
        deliveryInfo.value = info;
      }
      return null;
    }, [selectedAddress.value]);

    if (cartItems.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('Checkout')),
        body: const Center(
          child: Text('No items in cart'),
        ),
      );
    }

    return Scaffold(
      backgroundColor: offWhite,
      appBar: AppBar(
        backgroundColor: offWhite,
        elevation: 0,
        title: const Text(
          'Checkout',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => Get.back(),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Restaurant Info
              Container(
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12.r),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withValues(alpha: 0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      width: 60.w,
                      height: 60.h,
                      decoration: BoxDecoration(
                        color: Tcolor.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Icon(
                        Icons.restaurant,
                        color: Tcolor.primary,
                        size: 30.sp,
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            restaurant?.title ?? 'Restaurant',
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 4.h),
                          Text(
                            'Business Hours: ${restaurant?.businessHours ?? "9:00 AM - 11:00 PM"}',
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 20.h),

              // Order Items
              Text(
                'Order Items (${cartItems.length})',
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 12.h),

              ...cartItems
                  .map((cartItem) => Container(
                        margin: EdgeInsets.only(bottom: 12.h),
                        padding: EdgeInsets.all(16.w),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12.r),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withValues(alpha: 0.1),
                              blurRadius: 10,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8.r),
                              child: cartItem.productId.imageUrl.isNotEmpty
                                  ? Image.network(
                                      cartItem.productId.imageUrl.first,
                                      width: 60.w,
                                      height: 60.h,
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                        return Container(
                                          width: 60.w,
                                          height: 60.h,
                                          color: Colors.grey[300],
                                          child:
                                              Icon(Icons.image_not_supported),
                                        );
                                      },
                                    )
                                  : Container(
                                      width: 60.w,
                                      height: 60.h,
                                      color: Colors.grey[300],
                                      child: Icon(Icons.image_not_supported),
                                    ),
                            ),
                            SizedBox(width: 12.w),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    cartItem.productId.title,
                                    style: TextStyle(
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  SizedBox(height: 4.h),
                                  Text(
                                    'Quantity: ${cartItem.quantity}',
                                    style: TextStyle(
                                      fontSize: 14.sp,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                  if (cartItem.additives.isNotEmpty) ...[
                                    SizedBox(height: 4.h),
                                    Text(
                                      'Add-ons: ${cartItem.additives.join(', ')}',
                                      style: TextStyle(
                                        fontSize: 12.sp,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                            Text(
                              '₹${cartItem.totalPrice.toStringAsFixed(2)}',
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.bold,
                                color: Tcolor.primary,
                              ),
                            ),
                          ],
                        ),
                      ))
                  .toList(),

              SizedBox(height: 20.h),

              // Special Instructions
              Container(
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12.r),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withValues(alpha: 0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Special Instructions',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 12.h),
                    TextField(
                      maxLines: 3,
                      onChanged: (value) => specialInstructions.value = value,
                      decoration: InputDecoration(
                        hintText: 'Any special requests for your order...',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.r),
                          borderSide: BorderSide(color: Colors.grey[300]!),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.r),
                          borderSide: BorderSide(color: Colors.grey[300]!),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.r),
                          borderSide: BorderSide(color: Tcolor.primary),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 20.h),

              // Delivery Address Section
              Container(
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12.r),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withValues(alpha: 0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Delivery Address',
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextButton(
                          onPressed: refetch,
                          child: Text(
                            'Refresh',
                            style: TextStyle(color: Tcolor.primary),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 12.h),
                    isLoadingAddresses
                        ? const Center(child: CircularProgressIndicator())
                        : (addresses?.isEmpty ?? true)
                            ? Container(
                                padding: EdgeInsets.all(20.w),
                                decoration: BoxDecoration(
                                  color: Colors.grey[50],
                                  borderRadius: BorderRadius.circular(8.r),
                                  border: Border.all(color: Colors.grey[300]!),
                                ),
                                child: Column(
                                  children: [
                                    Icon(
                                      Icons.location_off,
                                      size: 40.sp,
                                      color: Colors.grey[400],
                                    ),
                                    SizedBox(height: 8.h),
                                    Text(
                                      'No addresses found',
                                      style: TextStyle(
                                        fontSize: 14.sp,
                                        color: Colors.grey[600],
                                      ),
                                    ),
                                    SizedBox(height: 8.h),
                                    ElevatedButton(
                                      onPressed: () =>
                                          Get.toNamed('/add-address'),
                                      child: const Text('Add Address'),
                                    ),
                                  ],
                                ),
                              )
                            : Column(
                                children: (addresses ?? []).map((address) {
                                  final isSelected =
                                      selectedAddress.value?.id == address.id;
                                  return Container(
                                    margin: EdgeInsets.only(bottom: 8.h),
                                    child: Material(
                                      color: Colors.transparent,
                                      child: InkWell(
                                        onTap: () =>
                                            selectedAddress.value = address,
                                        borderRadius:
                                            BorderRadius.circular(8.r),
                                        child: Container(
                                          padding: EdgeInsets.all(12.w),
                                          decoration: BoxDecoration(
                                            color: isSelected
                                                ? Tcolor.primary
                                                    .withValues(alpha: 0.1)
                                                : Colors.grey[50],
                                            borderRadius:
                                                BorderRadius.circular(8.r),
                                            border: Border.all(
                                              color: isSelected
                                                  ? Tcolor.primary
                                                  : Colors.grey[300]!,
                                              width: isSelected ? 2 : 1,
                                            ),
                                          ),
                                          child: Row(
                                            children: [
                                              Icon(
                                                Icons.location_on,
                                                color: isSelected
                                                    ? Tcolor.primary
                                                    : Colors.grey[600],
                                                size: 20.sp,
                                              ),
                                              SizedBox(width: 8.w),
                                              Expanded(
                                                child: Text(
                                                  '${address.addressLine1}, ${address.postalCode}',
                                                  style: TextStyle(
                                                    fontSize: 14.sp,
                                                    color: isSelected
                                                        ? Tcolor.primary
                                                        : Colors.black87,
                                                    fontWeight: isSelected
                                                        ? FontWeight.w600
                                                        : FontWeight.normal,
                                                  ),
                                                ),
                                              ),
                                              if (isSelected)
                                                Icon(
                                                  Icons.check_circle,
                                                  color: Tcolor.primary,
                                                  size: 20.sp,
                                                ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ),
                  ],
                ),
              ),

              SizedBox(height: 20.h),

              // Order Summary
              Container(
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12.r),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withValues(alpha: 0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Order Summary',
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 16.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Subtotal (${cartItems.length} items)',
                          style: TextStyle(fontSize: 14.sp),
                        ),
                        Text(
                          '₹${subtotal.toStringAsFixed(2)}',
                          style: TextStyle(fontSize: 14.sp),
                        ),
                      ],
                    ),
                    SizedBox(height: 8.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Text(
                              'Delivery Fee',
                              style: TextStyle(fontSize: 14.sp),
                            ),
                            if (deliveryInfo.value != null) ...[
                              SizedBox(width: 4.w),
                              Text(
                                '(${deliveryInfo.value!.distance.toStringAsFixed(1)} km)',
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ],
                        ),
                        Text(
                          '₹${deliveryCharge.toStringAsFixed(2)}',
                          style: TextStyle(fontSize: 14.sp),
                        ),
                      ],
                    ),
                    Divider(height: 24.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Total Amount',
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '₹${total.toStringAsFixed(2)}',
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                            color: Tcolor.primary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              SizedBox(height: 80.h), // Space for bottom button
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 32.h),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withValues(alpha: 0.2),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: SizedBox(
          width: double.infinity,
          height: 50.h,
          child: ElevatedButton(
            onPressed:
                selectedAddress.value == null || isProcessingPayment.value
                    ? null
                    : () => processCartOrder(
                          cartItems,
                          selectedAddress.value!,
                          deliveryInfo.value,
                          restaurant!,
                          specialInstructions.value,
                          currentOrderId,
                          isProcessingPayment,
                          razorpay,
                        ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Tcolor.primary,
              disabledBackgroundColor: Colors.grey[300],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.r),
              ),
            ),
            child: isProcessingPayment.value
                ? const CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  )
                : Text(
                    'Pay ₹${total.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}

// Payment processing functions
void processCartOrder(
  List<CartResponse> cartItems,
  AddressResponse address,
  DeliveryInfo? deliveryInfo,
  restaurant_model.RestaurentsModel restaurant,
  String specialInstructions,
  ValueNotifier<String?> currentOrderId,
  ValueNotifier<bool> isProcessingPayment,
  Razorpay? razorpay,
) async {
  if (razorpay == null) {
    Get.snackbar('Error', 'Payment system not initialized');
    return;
  }

  try {
    isProcessingPayment.value = true;

    // Calculate totals
    final subtotal =
        cartItems.fold<double>(0, (sum, item) => sum + item.totalPrice);
    final deliveryCharge = deliveryInfo?.charge ?? 20.0;
    final total = subtotal + deliveryCharge;

    // Create order items from cart
    final List<OrderItem> orderItems = cartItems
        .map((cartItem) => OrderItem(
              foodId: cartItem.productId.id,
              foodName: cartItem.productId.title,
              quantity: cartItem.quantity,
              price: cartItem.totalPrice / cartItem.quantity, // Unit price
              additives: cartItem.additives,
              instructions: specialInstructions.isNotEmpty
                  ? specialInstructions
                  : 'No special instructions',
            ))
        .toList();

    // Create order request
    final orderRequest = OrderRequest(
      userId: PaymentService.getUserId()!,
      restaurantId: restaurant.id,
      restaurantName: restaurant.title,
      orderItems: orderItems,
      orderTotal: total,
      deliveryFee: deliveryCharge,
      grandTotal: total,
      deliveryAddressId: address.id,
      deliveryAddress: address.addressLine1,
      restaurantCoords: [
        restaurant.coords.latitude,
        restaurant.coords.longitude
      ],
      recipientCoords: [address.latitude, address.longitude],
      notes: specialInstructions.isNotEmpty ? specialInstructions : '',
    );

    debugPrint("=== CREATING ORDER ===");
    debugPrint("Order request: ${orderRequestToJson(orderRequest)}");

    // Create order with backend
    final orderCreationResponse =
        await PaymentService.createOrder(orderRequest);

    if (orderCreationResponse.success && orderCreationResponse.data != null) {
      currentOrderId.value = orderCreationResponse.data!.orderId;

      debugPrint("=== ORDER CREATED ===");
      debugPrint("Order ID: ${orderCreationResponse.data!.orderId}");
      debugPrint(
          "Razorpay Order ID: ${orderCreationResponse.data!.razorpayOrderId}");

      // Configure Razorpay payment options
      final options = {
        'key': 'rzp_test_1DP5mmOlF5G5ag', // Razorpay test key
        'amount': (total * 100).toInt(),
        'name': 'Meal Monkey',
        'order_id': orderCreationResponse.data!.razorpayOrderId,
        'description':
            'Payment for ${cartItems.length} items from ${restaurant.title}',
        'timeout': 300,
        'prefill': {
          'contact': PaymentService.getUserData()?['phone'] ?? '',
          'email': PaymentService.getUserData()?['email'] ?? '',
        },
        'theme': {
          'color': '#FF6B6B',
        },
      };

      debugPrint("=== OPENING RAZORPAY ===");
      debugPrint("Options: $options");

      razorpay.open(options);
    } else {
      throw Exception(orderCreationResponse.message);
    }
  } catch (e) {
    debugPrint("=== ERROR CREATING ORDER ===");
    debugPrint("Error: $e");

    isProcessingPayment.value = false;

    Get.snackbar(
      'Order Creation Failed',
      e.toString(),
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.red.withValues(alpha: 0.8),
      colorText: Colors.white,
      duration: const Duration(seconds: 5),
    );
  }
}

void handlePaymentSuccessFlow(
  PaymentSuccessResponse response,
  ValueNotifier<String?> currentOrderId,
  ValueNotifier<DeliveryInfo?> deliveryInfo,
  ValueNotifier<AddressResponse?> selectedAddress,
  restaurant_model.RestaurentsModel? restaurant,
  List<CartResponse> cartItems,
  ValueNotifier<String> specialInstructions,
) async {
  try {
    // Show verification dialog
    Get.dialog(
      AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircularProgressIndicator(),
            const SizedBox(height: 16),
            const Text('Verifying payment...'),
          ],
        ),
      ),
      barrierDismissible: false,
    );

    // Create verification request
    final verificationRequest = PaymentVerificationRequest(
      razorpayOrderId: response.orderId ?? '',
      razorpayPaymentId: response.paymentId ?? '',
      razorpaySignature: response.signature ?? '',
      orderId: currentOrderId.value!,
    );

    debugPrint("=== VERIFYING PAYMENT WITH BACKEND ===");

    // Verify payment with backend
    final verificationResponse =
        await PaymentService.verifyPayment(verificationRequest);

    // Close verification dialog
    if (Get.isDialogOpen == true) {
      Get.back();
    }

    if (verificationResponse.success && verificationResponse.data != null) {
      debugPrint("=== PAYMENT VERIFIED SUCCESSFULLY ===");
      debugPrint("Order Status: ${verificationResponse.data!.orderStatus}");
      debugPrint("Payment Status: ${verificationResponse.data!.paymentStatus}");

      // Create comprehensive order details for tracking page
      final orderDetails = {
        'orderId': verificationResponse.data!.orderId,
        'paymentId': verificationResponse.data!.paymentId,
        'orderDate': verificationResponse.data!.orderDate,
        'estimatedDeliveryTime': deliveryInfo.value?.estimatedTime ?? 30,
        'orderStatus': verificationResponse.data!.orderStatus,
        'paymentStatus': verificationResponse.data!.paymentStatus,
        'restaurant': {
          'name': restaurant?.title ?? 'Restaurant',
          'id': restaurant?.id ?? '',
          'imageUrl': restaurant?.imageUrl ?? [],
          'businessHours': restaurant?.businessHours ?? '',
        },
        'cartItems': cartItems
            .map((item) => {
                  'name': item.productId.title,
                  'id': item.productId.id,
                  'imageUrl': item.productId.imageUrl.isNotEmpty
                      ? item.productId.imageUrl[0]
                      : '',
                  'price': item.totalPrice / item.quantity,
                  'quantity': item.quantity,
                  'additives': item.additives,
                })
            .toList(),
        'orderDetails': {
          'subtotal':
              cartItems.fold<double>(0, (sum, item) => sum + item.totalPrice),
          'deliveryFee': deliveryInfo.value?.charge ?? 20.0,
          'totalAmount':
              cartItems.fold<double>(0, (sum, item) => sum + item.totalPrice) +
                  (deliveryInfo.value?.charge ?? 20.0),
          'instructions': specialInstructions.value.isNotEmpty
              ? specialInstructions.value
              : 'No special instructions',
          'distance': deliveryInfo.value?.distance ?? 0.0,
          'itemCount': cartItems.length,
        },
        'address': {
          'line1': selectedAddress.value!.addressLine1,
          'postalCode': selectedAddress.value!.postalCode,
          'latitude': selectedAddress.value!.latitude,
          'longitude': selectedAddress.value!.longitude,
        },
      };

      // Show success toast
      Fluttertoast.showToast(
        msg: "Order placed successfully! Track your order now.",
        backgroundColor: Colors.green,
        textColor: Colors.white,
        toastLength: Toast.LENGTH_LONG,
      );

      // Navigate to order tracking page with comprehensive order details
      Get.offAllNamed('/order-tracking', arguments: orderDetails);
    } else {
      throw Exception(verificationResponse.message);
    }
  } catch (e) {
    debugPrint("=== ERROR IN PAYMENT VERIFICATION ===");
    debugPrint("Error: $e");

    // Close any open dialogs
    if (Get.isDialogOpen == true) {
      Get.back();
    }

    // Handle payment failure with backend
    if (currentOrderId.value != null) {
      try {
        await PaymentService.handlePaymentFailure(PaymentFailureRequest(
          orderId: currentOrderId.value!,
          razorpayOrderId: response.orderId,
          razorpayPaymentId: response.paymentId,
          error: {'description': e.toString(), 'step': 'verification'},
        ));
      } catch (failureError) {
        debugPrint("Error handling payment failure: $failureError");
      }
    }

    Get.snackbar(
      'Payment Verification Error',
      'Your payment was successful but verification failed. Please contact support with Payment ID: ${response.paymentId}',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.orange.withValues(alpha: 0.8),
      colorText: Colors.white,
      duration: const Duration(seconds: 8),
    );
  }
}

void handlePaymentErrorFlow(
  PaymentFailureResponse response,
  ValueNotifier<String?> currentOrderId,
) async {
  debugPrint("=== PAYMENT FAILED ===");
  debugPrint('Error Code: ${response.code}');
  debugPrint('Error Message: ${response.message}');
  debugPrint('Error Details: ${response.error}');

  // Handle payment failure with backend
  if (currentOrderId.value != null) {
    try {
      await PaymentService.handlePaymentFailure(PaymentFailureRequest(
        orderId: currentOrderId.value!,
        razorpayOrderId: null,
        razorpayPaymentId: null,
        error: {
          'code': response.code.toString(),
          'description': response.message ?? 'Payment failed',
          'step': 'payment',
        },
      ));
    } catch (e) {
      debugPrint("Error handling payment failure: $e");
    }
  }

  String errorMessage = 'Payment failed';
  if (response.code == Razorpay.PAYMENT_CANCELLED) {
    errorMessage = 'Payment was cancelled';
  } else if (response.code == Razorpay.NETWORK_ERROR) {
    errorMessage =
        'Network error occurred. Please check your connection and try again.';
  }

  Get.snackbar(
    'Payment Failed',
    errorMessage,
    snackPosition: SnackPosition.BOTTOM,
    backgroundColor: Colors.red.withValues(alpha: 0.8),
    colorText: Colors.white,
    duration: const Duration(seconds: 5),
  );
}
