import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:food_delivery_app/common/app_style.dart';
import 'package:food_delivery_app/common/background_container.dart';
import 'package:food_delivery_app/common/color_extension.dart';
import 'package:food_delivery_app/common/constants.dart';
import 'package:food_delivery_app/common/custom_button.dart';
import 'package:food_delivery_app/common/reusable_text.dart';
import 'package:food_delivery_app/models/foods.dart';
import 'package:food_delivery_app/models/order_request.dart';
import 'package:food_delivery_app/models/restaurents.dart';
import 'package:food_delivery_app/view/orders/widgets/order_tile.dart';
import 'package:food_delivery_app/view/restaurent/Widgets/row_text.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class OrderPage extends StatefulWidget {
  const OrderPage(
      {super.key,
      required this.restaurant,
      required this.food,
      required this.item});
  final RestaurentsModel restaurant;
  final FoodItem food;
  final OrderItem item;

  @override
  State<OrderPage> createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  late Razorpay _razorpay;

  @override
  void initState() {
    super.initState();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  @override
  void dispose() {
    _razorpay.clear();
    super.dispose();
  }

  void _openCheckout(double amount) {
    var options = {
      'key': 'rzp_test_1AovirvDbdoNlo', // Use your live/test key
      'amount': amount.toInt().toString(), // in paise
      'currency': 'INR',
      'name': widget.restaurant.title,
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
      _razorpay.open(options);
    } catch (e) {
      debugPrint("Razorpay error: $e");
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    Fluttertoast.showToast(msg: "Payment Successful: ${response.paymentId}");
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    Fluttertoast.showToast(msg: "Payment Failed: ${response.message}");
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    Fluttertoast.showToast(
        msg: "External Wallet Selected: ${response.walletName}");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Tcolor.primary,
      appBar: AppBar(
        backgroundColor: Tcolor.primary,
        title: ReusableText(
          text: "Complete Order",
          style: appBarTextStyle(
            15,
            Colors.white,
            FontWeight.w600,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: BackgroundContainer(
        color: Colors.white,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.w),
          child: Column(
            children: [
              SizedBox(
                height: 10.h,
              ),
              OrderTile(food: widget.food, color: Colors.white),
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
                          text: widget.restaurant.title,
                          style: appBarTextStyle(
                            20,
                            Colors.black54,
                            FontWeight.bold,
                          ),
                        ),
                        CircleAvatar(
                          radius: 20.r,
                          backgroundImage: NetworkImage(
                            widget.restaurant.imageUrl,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 5.h,
                    ),
                    RowText(
                      first: "Business Hours",
                      second: widget.restaurant.businessHours,
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
                      second: "₹ ${widget.food.price}",
                    ),
                    SizedBox(
                      height: 5.h,
                    ),
                    RowText(
                      first: "Order Total",
                      second: "₹ ${widget.item.price}",
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
                        itemCount: widget.item.additives.length,
                        itemBuilder: (context, index) {
                          var additive = widget.item.additives[index];
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
              CustomButton(
                text: 'Proceed To Payment',
                height: 40.h,
                ontap: () {
                  _openCheckout(widget.item.price * 100);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
