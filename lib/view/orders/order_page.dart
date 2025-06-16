import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:food_delivery_app/common/app_style.dart';
import 'package:food_delivery_app/common/background_container.dart';
import 'package:food_delivery_app/common/color_extension.dart';
import 'package:food_delivery_app/common/constants.dart';
import 'package:food_delivery_app/common/custom_button.dart';
import 'package:food_delivery_app/common/reusable_text.dart';
import 'package:food_delivery_app/hooks/fetch_addresses.dart';
import 'package:food_delivery_app/models/addresses_response.dart';
import 'package:food_delivery_app/models/foods.dart';
import 'package:food_delivery_app/models/order_request.dart';
import 'package:food_delivery_app/models/restaurents.dart';
import 'package:food_delivery_app/services/order_service.dart';
import 'package:food_delivery_app/view/orders/widgets/order_tile.dart';
import 'package:food_delivery_app/view/restaurent/Widgets/row_text.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class OrderPage extends HookWidget {
  const OrderPage({
    super.key,
    required this.restaurant,
    required this.food,
    required this.item,
  });

  final RestaurentsModel restaurant;
  final FoodItem food;
  final OrderItem item;

  @override
  Widget build(BuildContext context) {
    final razorpay = useMemoized(() => Razorpay());
    final hookResult = useFetchAllAddresses();
    final List<AddressResponse>? addresses = hookResult.data ?? [];
    final bool isLoading = hookResult.isLoading;

    final selectedAddress = useState<AddressResponse?>(null);

    useEffect(() {
      razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, (response) {
        Fluttertoast.showToast(
            msg: "Payment Successful: ${response.paymentId}");
      });
      razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, (response) {
        Fluttertoast.showToast(msg: "Payment Failed: ${response.message}");
      });
      razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, (response) {
        Fluttertoast.showToast(
            msg: "External Wallet Selected: ${response.walletName}");
      });

      return () => razorpay.clear(); // dispose
    }, []);

    useEffect(() {
      if (addresses!.isNotEmpty) {
        final defaultAddress = addresses.firstWhere(
          (addr) => addr.isDefault == true,
          orElse: () => addresses.first,
        );
        selectedAddress.value = defaultAddress;
        razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, (response) async {
          Fluttertoast.showToast(
            msg: "Payment Successful: ${response.paymentId}",
          );

          // Now send data to your backend
          await saveOrderToMongoDB(
            paymentId: response.paymentId,
            orderId: response.orderId, // Razorpay orderId
            amount: item.price,
            restaurant: restaurant,
            food: food,
            address: selectedAddress.value,
          );
        });
      }
      return null;
    }, [addresses]);

    void _openCheckout(double amount) {
      var options = {
        'key': 'rzp_test_1AovirvDbdoNlo',
        'amount': amount.toInt().toString(),
        'currency': 'INR',
        'name': restaurant.title,
        'description': 'Food Order Payment',
        'prefill': {
          'contact': '1234567890',
          'email': 'yashnandwani47@gmail.com',
        },
        'external': {
          'wallets': ['paytm']
        }
      };

      try {
        razorpay.open(options);
      } catch (e) {
        debugPrint("Razorpay error: $e");
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
                    OrderTile(food: food, color: Colors.white),
                    Container(
                      width: width,
                      height: height / 3.9,
                      padding: EdgeInsets.symmetric(
                        horizontal: 10.w,
                        vertical: 10.h,
                      ),
                      decoration: BoxDecoration(
                        color: offWhite,
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 5.h,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              ReusableText(
                                text: restaurant.title,
                                style: appBarTextStyle(
                                  20,
                                  Colors.black54,
                                  FontWeight.bold,
                                ),
                              ),
                              CircleAvatar(
                                radius: 20.r,
                                backgroundImage: NetworkImage(
                                  restaurant.imageUrl,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 5.h,
                          ),
                          RowText(
                            first: "Business Hours",
                            second: restaurant.businessHours,
                          ),
                          SizedBox(
                            height: 5.h,
                          ),
                          const RowText(
                            first: "Distance from you",
                            second: "3km",
                          ),
                          SizedBox(
                            height: 5.h,
                          ),
                          RowText(
                            first: "Price from Restaurant",
                            second: "₹ ${food.price}",
                          ),
                          SizedBox(
                            height: 5.h,
                          ),
                          RowText(
                            first: "Order Total",
                            second: "₹ ${item.price}",
                          ),
                          SizedBox(
                            height: 5.h,
                          ),
                          ReusableText(
                            text: 'Additives',
                            style: appBarTextStyle(
                              15,
                              Colors.black54,
                              FontWeight.bold,
                            ),
                          ),
                          SizedBox(
                            height: 5.h,
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.7,
                            height: 15.h,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: item.additives.length,
                              itemBuilder: (context, index) {
                                var additive = item.additives[index];
                                return Container(
                                  margin: EdgeInsets.only(right: 5.w),
                                  decoration: BoxDecoration(
                                    color: Colors.blue.withValues(alpha: 0.2),
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(9.r),
                                    ),
                                  ),
                                  child: Center(
                                    child: Padding(
                                      padding: EdgeInsets.all(2.h),
                                      child: ReusableText(
                                        text: additive,
                                        style: appBarTextStyle(
                                          8,
                                          Colors.black,
                                          FontWeight.w400,
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    Container(
                      width: width,
                      padding: EdgeInsets.all(10.w),
                      decoration: BoxDecoration(
                        color: offWhite,
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ReusableText(
                            text: 'Delivery Address',
                            style: appBarTextStyle(
                                14, Colors.black87, FontWeight.w600),
                          ),
                          SizedBox(height: 10.h),
                          DropdownButtonFormField<AddressResponse>(
                            value: selectedAddress.value,
                            isExpanded: true,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: 'Selected Address',
                            ),
                            items: addresses!.map((address) {
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
                              selectedAddress.value = val!;
                            },
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20.h),
                    CustomButton(
                      text: 'Proceed To Payment',
                      height: 40.h,
                      ontap: () {
                        _openCheckout(item.price * 100);
                      },
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
