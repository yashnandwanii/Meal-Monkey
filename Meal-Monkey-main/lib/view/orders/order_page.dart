import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:food_delivery_app/common/app_style.dart';
import 'package:food_delivery_app/common/background_container.dart';
import 'package:food_delivery_app/common/color_extension.dart';
import 'package:food_delivery_app/common/constants.dart';
import 'package:food_delivery_app/common/reusable_text.dart';
import 'package:food_delivery_app/hooks/fetch_addresses.dart';
import 'package:food_delivery_app/models/addresses_response.dart';
import 'package:food_delivery_app/models/foods.dart';
import 'package:food_delivery_app/models/restaurents.dart';
import 'package:food_delivery_app/models/order_request.dart';
import 'package:food_delivery_app/models/order_response.dart';
import 'package:food_delivery_app/models/payment_request.dart';
import 'package:food_delivery_app/services/payment_service.dart';
import 'package:food_delivery_app/view/restaurent/Widgets/row_text.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:get/get.dart';
import 'dart:async';

class OrderPage extends HookWidget {
  const OrderPage({
    super.key,
    required this.restaurant,
    required this.food,
    required this.item,
  });

  final RestaurentsModel restaurant;
  final FoodItem food;
  final PaymentOrderItem item;

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
    final bool isLoading = hookResult.isLoading;
    final isProcessingPayment = useState<bool>(false);
    final selectedAddress = useState<AddressResponse?>(null);
    final currentOrderId = useState<String?>(null);

    void handlePaymentSuccess(PaymentSuccessResponse response) async {
      isProcessingPayment.value = false;

      try {
        debugPrint("=== PAYMENT SUCCESSFUL - STARTING VERIFICATION ===");
        debugPrint("Payment ID: ${response.paymentId}");
        debugPrint("Razorpay Order ID: ${response.orderId}");
        debugPrint("Signature: ${response.signature}");

        if (currentOrderId.value == null) {
          throw Exception(
              'Order ID not found. Please contact support with payment ID: ${response.paymentId}');
        }

        // Show verification loading
        Get.dialog(
          Center(
            child: Container(
              padding: EdgeInsets.all(20.w),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16.r),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(color: Colors.green),
                  SizedBox(height: 16.h),
                  Text(
                    'Payment Successful!',
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    'Verifying payment...',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    'Please wait while we confirm your payment',
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: Colors.grey[600],
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
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
          debugPrint(
              "Payment Status: ${verificationResponse.data!.paymentStatus}");

          // Create comprehensive order details for success page
          final orderDetails = {
            'orderId': verificationResponse.data!.orderId,
            'paymentId': verificationResponse.data!.paymentId,
            'orderDate': verificationResponse.data!.orderDate,
            'estimatedDeliveryTime':
                verificationResponse.data!.estimatedDeliveryTime,
            'orderStatus': verificationResponse.data!.orderStatus,
            'paymentStatus': verificationResponse.data!.paymentStatus,
            'restaurant': {
              'name': restaurant.title,
              'id': restaurant.id,
              'imageUrl': restaurant.imageUrl,
              'businessHours': restaurant.businessHours,
            },
            'food': {
              'name': food.title,
              'id': food.id,
              'imageUrl': food.imageUrl.isNotEmpty ? food.imageUrl[0] : '',
              'price': item.price,
            },
            'orderDetails': {
              'quantity': item.quantity,
              'subtotal': item.price * item.quantity,
              'deliveryFee': 5.0,
              'totalAmount': (item.price * item.quantity) + 5.0,
              'additives': item.additives,
              'instructions': item.instructions,
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
            msg:
                "Order placed successfully! Order ID: ${verificationResponse.data!.orderId.substring(0, 8)}...",
            backgroundColor: Colors.green,
            textColor: Colors.white,
            toastLength: Toast.LENGTH_LONG,
          );

          // Navigate to success page with comprehensive order details
          Get.offAllNamed('/order-success', arguments: orderDetails);
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
          duration: Duration(seconds: 8),
        );
      }
    }

    void handlePaymentError(PaymentFailureResponse response) async {
      isProcessingPayment.value = false;

      debugPrint("=== PAYMENT FAILED ===");
      debugPrint('Error Code: ${response.code}');
      debugPrint('Error Message: ${response.message}');
      debugPrint('Error Details: ${response.error}');

      // Handle payment failure with backend
      if (currentOrderId.value != null) {
        try {
          debugPrint("Recording payment failure in backend...");
          await PaymentService.handlePaymentFailure(PaymentFailureRequest(
            orderId: currentOrderId.value!,
            error: {
              'code': response.code,
              'description': response.message,
              'source': response.error.toString(),
              'step': 'payment_gateway',
            },
          ));
        } catch (e) {
          debugPrint("Error recording payment failure: $e");
        }
      }

      // Determine specific error message based on error code
      String errorTitle = 'Payment Failed';
      String errorMessage = 'Payment failed. Please try again.';
      Color backgroundColor = Colors.red;

      switch (response.code) {
        case 0: // Payment cancelled by user
        case 2: // Payment cancelled by user (modal dismissed)
          errorTitle = 'Payment Cancelled';
          errorMessage =
              'You cancelled the payment. Your order has been saved and you can retry payment later.';
          backgroundColor = Colors.orange;
          break;
        case 1: // Payment failed due to various reasons
          errorTitle = 'Payment Failed';
          if (response.message?.toLowerCase().contains('insufficient') ==
              true) {
            errorMessage =
                'Insufficient funds. Please check your account balance and try again.';
          } else if (response.message?.toLowerCase().contains('card') == true) {
            errorMessage =
                'Card payment failed. Please check your card details or try a different card.';
          } else if (response.message?.toLowerCase().contains('bank') == true) {
            errorMessage =
                'Bank declined the transaction. Please contact your bank or try a different payment method.';
          } else {
            errorMessage =
                'Payment failed. Please check your payment details and try again.';
          }
          break;
        case 3: // Invalid payment details
          errorTitle = 'Invalid Payment Details';
          errorMessage =
              'The payment details provided are invalid. Please check and try again.';
          break;
        default:
          if (response.message?.contains('Unexpected Error') == true) {
            errorTitle = 'Payment Gateway Error';
            errorMessage =
                'Payment gateway is temporarily unavailable. Please try again in a few moments.';
            backgroundColor = Colors.orange;
          }
          break;
      }

      // Show user-friendly error message
      Fluttertoast.showToast(
        msg: errorMessage,
        backgroundColor: backgroundColor,
        textColor: Colors.white,
        toastLength: Toast.LENGTH_LONG,
      );

      Get.snackbar(
        errorTitle,
        errorMessage,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: backgroundColor.withValues(alpha: 0.8),
        colorText: Colors.white,
        duration: Duration(seconds: 6),
        mainButton: TextButton(
          onPressed: () {
            Get.back();
            // Reset state for retry
            isProcessingPayment.value = false;
            currentOrderId.value = null;
          },
          child: Text(
            'OK',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
      );
    }

    void handleExternalWallet(ExternalWalletResponse response) {
      debugPrint('External wallet event triggered: $response');
      Fluttertoast.showToast(
          msg: "External Wallet Selected: ${response.walletName}");
    }

    useEffect(() {
      if (razorpay == null) {
        debugPrint('Razorpay instance is null, cannot set up listeners');
        return null;
      }

      razorpay.clear();

      // Set up event listeners
      razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, handlePaymentSuccess);
      razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, handlePaymentError);
      razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, handleExternalWallet);

      return () {
        debugPrint('Cleaning up Razorpay listeners');
        razorpay.clear();
      };
    }, []);

    useEffect(() {
      if (addresses != null && addresses.isNotEmpty) {
        final defaultAddress = addresses.firstWhere(
          (addr) => addr.isDefault == true,
          orElse: () => addresses.first,
        );
        selectedAddress.value = defaultAddress;
      }
      return null;
    }, [addresses]);

    void openCheckout() async {
      // Validate address selection
      if (selectedAddress.value == null) {
        Get.snackbar(
          'Error',
          'Please select a delivery address',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.withValues(alpha: 0.8),
          colorText: Colors.white,
          duration: Duration(seconds: 3),
        );
        return;
      }

      // Validate user authentication
      final userId = PaymentService.getUserId();
      if (userId == null) {
        Get.snackbar(
          'Authentication Error',
          'Please login to continue with your order',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.withValues(alpha: 0.8),
          colorText: Colors.white,
          duration: Duration(seconds: 3),
        );
        return;
      }

      // Validate order details
      if (item.quantity <= 0 || item.price <= 0) {
        Get.snackbar(
          'Invalid Order',
          'Please check your order details and try again',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.withValues(alpha: 0.8),
          colorText: Colors.white,
          duration: Duration(seconds: 3),
        );
        return;
      }

      // Start processing
      isProcessingPayment.value = true;
      debugPrint("=== STARTING ORDER CREATION AND PAYMENT PROCESS ===");
      debugPrint("User ID: $userId");
      debugPrint("Restaurant: ${restaurant.title} (${restaurant.id})");
      debugPrint("Food: ${food.title} (${food.id})");
      debugPrint("Quantity: ${item.quantity}");
      debugPrint("Price: ₹${item.price}");
      debugPrint("Address: ${selectedAddress.value!.addressLine1}");

      try {
        // Create order request with detailed validation
        final orderRequest = OrderRequest(
          userId: userId,
          restaurantId: restaurant.id,
          restaurantName: restaurant.title,
          orderItems: [
            OrderItem(
              foodId: food.id,
              foodName: food.title,
              quantity: item.quantity,
              price: item.price,
              additives: item.additives,
              instructions: item.instructions.isEmpty
                  ? 'No special instructions'
                  : item.instructions,
            )
          ],
          orderTotal: item.price * item.quantity,
          deliveryFee: 5.0,
          grandTotal: (item.price * item.quantity) + 5.0,
          deliveryAddressId: selectedAddress.value!.id,
          deliveryAddress:
              '${selectedAddress.value!.addressLine1}, ${selectedAddress.value!.postalCode}',
          restaurantCoords: [
            restaurant.coords.longitude,
            restaurant.coords.latitude
          ],
          recipientCoords: [
            selectedAddress.value!.longitude,
            selectedAddress.value!.latitude
          ],
          notes:
              'Order placed via mobile app at ${DateTime.now().toIso8601String()}',
        );

        debugPrint("=== CREATING ORDER WITH BACKEND ===");

        // Show loading indicator
        Get.dialog(
          Center(
            child: Container(
              padding: EdgeInsets.all(20.w),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16.r),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(color: Tcolor.primary),
                  SizedBox(height: 16.h),
                  Text(
                    'Creating your order...',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    'Please wait while we prepare your order',
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: Colors.grey[600],
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
          barrierDismissible: false,
        );

        // Step 1: Create order and get Razorpay order details
        final orderResponse = await PaymentService.createOrder(orderRequest);

        // Close loading dialog
        Get.back();

        if (!orderResponse.success || orderResponse.data == null) {
          throw Exception(orderResponse.message);
        }

        // Store order ID for payment verification
        currentOrderId.value = orderResponse.data!.orderId;

        debugPrint("=== ORDER CREATED SUCCESSFULLY ===");
        debugPrint("Order ID: ${orderResponse.data!.orderId}");
        debugPrint("Razorpay Order ID: ${orderResponse.data!.razorpayOrderId}");
        debugPrint("Amount: ₹${orderResponse.data!.amount / 100}");

        // Step 2: Prepare Razorpay checkout options
        var options = {
          'key': orderResponse.data!.key,
          'amount': orderResponse.data!.amount,
          'currency': orderResponse.data!.currency,
          'name': restaurant.title,
          'description': 'Food Order Payment for ${food.title}',
          'order_id': orderResponse.data!.razorpayOrderId,
          'prefill': {
            'contact': '1234567890', // You can get this from user profile
            'email': 'user@example.com', // You can get this from user profile
          },
          'notes': {
            'order_type': 'food_delivery',
            'restaurant': restaurant.title,
            'food_item': food.title,
            'app_order_id': orderResponse.data!.orderId,
            'delivery_address': selectedAddress.value!.addressLine1,
          },
          'theme': {
            'color': '#FF7622', // Your app's primary color
          },
        };

        debugPrint("=== OPENING RAZORPAY PAYMENT GATEWAY ===");
        debugPrint("Payment options: $options");

        // Validate Razorpay instance
        if (razorpay == null) {
          throw Exception(
              'Payment gateway not available. Please restart the app and try again.');
        }

        // Add a small delay to ensure UI is ready
        await Future.delayed(const Duration(milliseconds: 500));

        // Open Razorpay checkout
        debugPrint("Opening Razorpay payment gateway...");
        razorpay.open(options);

        // Add a timeout to reset processing state if modal doesn't open
        Timer(const Duration(seconds: 20), () {
          if (isProcessingPayment.value) {
            debugPrint("Payment modal timeout - resetting state");
            isProcessingPayment.value = false;
            Get.snackbar(
              'Payment Timeout',
              'Payment gateway took too long to open. Please check your internet connection and try again.',
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: Colors.orange.withValues(alpha: 0.8),
              colorText: Colors.white,
              duration: Duration(seconds: 5),
            );
          }
        });
      } catch (e) {
        debugPrint("=== ERROR IN ORDER CREATION ===");
        debugPrint("Error: $e");

        // Close any open dialogs
        if (Get.isDialogOpen == true) {
          Get.back();
        }

        isProcessingPayment.value = false;
        currentOrderId.value = null;

        String errorMessage = 'Failed to create order. Please try again.';

        // Provide specific error messages based on error type
        if (e.toString().contains('User not authenticated')) {
          errorMessage = 'Please login again to continue.';
        } else if (e.toString().contains('network') ||
            e.toString().contains('connection')) {
          errorMessage =
              'Network error. Please check your internet connection.';
        } else if (e.toString().contains('server') ||
            e.toString().contains('500')) {
          errorMessage = 'Server error. Please try again in a few moments.';
        }

        Get.snackbar(
          'Order Error',
          errorMessage,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red.withValues(alpha: 0.8),
          colorText: Colors.white,
          duration: Duration(seconds: 5),
        );
      }
    }

    return Scaffold(
      backgroundColor: Tcolor.primary,
      appBar: AppBar(
        backgroundColor: Tcolor.primary,
        title: ReusableText(
          text: "Complete Order",
          style: appBarTextStyle(15, Colors.white, FontWeight.w600),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: BackgroundContainer(
        color: Colors.white,
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.w),
                child: Column(
                  children: [
                    SizedBox(height: 10.h),
                    _buildOrderSummary(),
                    SizedBox(height: 15.h),
                    _buildRestaurantInfo(),
                    SizedBox(height: 20.h),
                    _buildDeliveryAddress(addresses, selectedAddress),
                    SizedBox(height: 20.h),
                    _buildPaymentButton(
                        openCheckout, isProcessingPayment.value),
                  ],
                ),
              ),
      ),
    );
  }

  Widget _buildOrderSummary() {
    return Container(
      width: width,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: offWhite,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ReusableText(
            text: 'Order Summary',
            style: appBarTextStyle(18, Colors.black87, FontWeight.bold),
          ),
          SizedBox(height: 12.h),
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8.r),
                child: Container(
                  width: 60.w,
                  height: 60.w,
                  child: food.imageUrl.isNotEmpty
                      ? Image.network(
                          food.imageUrl[0],
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              color: Colors.grey[200]!,
                              child:
                                  Icon(Icons.fastfood, color: Colors.grey[400]),
                            );
                          },
                        )
                      : Container(
                          color: Colors.grey[200]!,
                          child: Icon(Icons.fastfood, color: Colors.grey[400]),
                        ),
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ReusableText(
                      text: food.title,
                      style:
                          appBarTextStyle(16, Colors.black87, FontWeight.w600),
                    ),
                    SizedBox(height: 4.h),
                    ReusableText(
                      text: 'Qty: ${item.quantity}',
                      style: appBarTextStyle(
                          14, Colors.grey[600]!, FontWeight.w400),
                    ),
                    SizedBox(height: 4.h),
                    ReusableText(
                      text: '₹ ${item.price.toStringAsFixed(2)}',
                      style:
                          appBarTextStyle(16, Tcolor.primary, FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (item.additives.isNotEmpty) ...[
            SizedBox(height: 12.h),
            ReusableText(
              text: 'Additives',
              style: appBarTextStyle(14, Colors.black87, FontWeight.w600),
            ),
            SizedBox(height: 8.h),
            SizedBox(
              height: 30.h,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: item.additives.length,
                itemBuilder: (context, index) {
                  var additive = item.additives[index];
                  return Container(
                    margin: EdgeInsets.only(right: 8.w),
                    padding:
                        EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                    decoration: BoxDecoration(
                      color: Tcolor.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(16.r),
                      border: Border.all(
                          color: Tcolor.primary.withValues(alpha: 0.3)),
                    ),
                    child: ReusableText(
                      text: additive,
                      style:
                          appBarTextStyle(12, Tcolor.primary, FontWeight.w500),
                    ),
                  );
                },
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildRestaurantInfo() {
    return Container(
      width: width,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: offWhite,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ReusableText(
                text: restaurant.title,
                style: appBarTextStyle(18, Colors.black87, FontWeight.bold),
              ),
              CircleAvatar(
                radius: 25.r,
                backgroundImage: NetworkImage(restaurant.imageUrl),
              ),
            ],
          ),
          SizedBox(height: 10.h),
          RowText(first: "Business Hours", second: restaurant.businessHours),
          SizedBox(height: 8.h),
          const RowText(first: "Distance from you", second: "3km"),
          SizedBox(height: 8.h),
          RowText(first: "Delivery Fee", second: "₹5.00"),
          SizedBox(height: 8.h),
          Divider(color: Colors.grey[300]),
          SizedBox(height: 8.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ReusableText(
                text: "Total Amount",
                style: appBarTextStyle(16, Colors.black87, FontWeight.bold),
              ),
              ReusableText(
                text: "₹ ${(item.price + 5.0).toStringAsFixed(2)}",
                style: appBarTextStyle(18, Tcolor.primary, FontWeight.bold),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDeliveryAddress(List<AddressResponse>? addresses,
      ValueNotifier<AddressResponse?> selectedAddress) {
    return Container(
      width: width,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: offWhite,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ReusableText(
            text: 'Delivery Address',
            style: appBarTextStyle(16, Colors.black87, FontWeight.w600),
          ),
          SizedBox(height: 10.h),
          if (addresses != null && addresses.isNotEmpty)
            DropdownButtonFormField<AddressResponse>(
              value: selectedAddress.value,
              isExpanded: true,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
                labelText: 'Select Address',
                labelStyle: TextStyle(color: Colors.grey[600]),
              ),
              items: addresses.map((address) {
                return DropdownMenuItem<AddressResponse>(
                  value: address,
                  child: Text(
                    "${address.addressLine1}, ${address.postalCode}",
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                  ),
                );
              }).toList(),
              onChanged: (val) {
                selectedAddress.value = val;
              },
            )
          else
            Container(
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: Colors.red.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8.r),
                border: Border.all(color: Colors.red.withValues(alpha: 0.3)),
              ),
              child: Row(
                children: [
                  Icon(Icons.error_outline, color: Colors.red, size: 20.sp),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: Text(
                      'No addresses found. Please add an address first.',
                      style: TextStyle(color: Colors.red, fontSize: 14.sp),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildPaymentButton(Function() openCheckout, bool isProcessing) {
    return Container(
      width: width,
      child: Column(
        children: [
          // Order total summary
          // Container(
          //   padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          //   decoration: BoxDecoration(
          //     color: Tcolor.primary.withValues(alpha: 0.1),
          //     borderRadius: BorderRadius.circular(8.r),
          //     border: Border.all(color: Tcolor.primary.withValues(alpha: 0.3)),
          //   ),
          //   child: Row(
          //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //     children: [
          //       Text(
          //         'Total Amount:',
          //         style: TextStyle(
          //           fontSize: 16.sp,
          //           fontWeight: FontWeight.w600,
          //           color: Colors.black87,
          //         ),
          //       ),
          //       Text(
          //         '₹ ${(item.price * item.quantity + 20).toStringAsFixed(2)}',
          //         style: TextStyle(
          //           fontSize: 18.sp,
          //           fontWeight: FontWeight.bold,
          //           color: Tcolor.primary,
          //         ),
          //       ),
          //     ],
          //   ),
          // ),
          // SizedBox(height: 16.h),

          // Payment button
          GestureDetector(
            onTap: isProcessing ? null : openCheckout,
            child: Container(
              width: width,
              height: 54.h,
              decoration: BoxDecoration(
                color: isProcessing ? Colors.grey : Tcolor.primary,
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (isProcessing)
                    SizedBox(
                      width: 20.w,
                      height: 20.h,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  else
                    Icon(
                      Icons.payment,
                      color: Colors.white,
                      size: 20.sp,
                    ),
                  SizedBox(width: 8.w),
                  Text(
                    isProcessing
                        ? 'Processing...'
                        : 'Proceed To Payment ₹${(item.price * item.quantity + 20).toStringAsFixed(0)}',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),

          SizedBox(height: 5.h),

          // Security and payment info
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.security,
                color: Colors.green,
                size: 16.sp,
              ),
              SizedBox(width: 4.w),
              Text(
                'Secure payment powered by Razorpay',
                style: TextStyle(
                  fontSize: 12.sp,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),

          SizedBox(height: 8.h),

          // Payment methods info
          Text(
            'Supports UPI, Cards, Wallets & Net Banking',
            style: TextStyle(
              fontSize: 11.sp,
              color: Colors.grey[500],
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
