import 'package:flutter/material.dart';
import 'package:food_delivery_app/common/color_extension.dart';

import '../cart/cart_page.dart';

class InboxView extends StatefulWidget {
  const InboxView({super.key});

  @override
  State<InboxView> createState() => _InboxViewState();
}

class _InboxViewState extends State<InboxView> {
  List inboxArr = [
    {
      "title": "Exclusive Discount Offer",
      "detail":
          "Enjoy up to 50% off on your favorite meals this weekend. Don’t miss out on this limited-time offer!",
    },
    {
      "title": "New Menu Alert",
      "detail":
          "Check out our latest additions to the menu featuring gourmet dishes and seasonal favorites.",
    },
    {
      "title": "Order Confirmation",
      "detail":
          "Your recent order has been confirmed. Track it live and enjoy your meal shortly!",
    },
    {
      "title": "Special Loyalty Rewards",
      "detail":
          "You’ve earned 200 loyalty points! Redeem them on your next order to enjoy great savings.",
    },
    {
      "title": "Festive Delights Await",
      "detail":
          "Celebrate the season with our curated festive specials. Order now and make your holidays delicious!",
    },
    {
      "title": "Free Dessert Offer",
      "detail":
          "Get a free dessert on orders above ₹500. Treat yourself today!",
    },
    {
      "title": "MealMonkey Promotions",
      "detail":
          "Discover exciting deals and discounts on your favorite cuisines. Order now to save big!",
    },
    {
      "title": "Your Feedback Matters",
      "detail":
          "We value your opinion! Share your feedback and get a chance to win a discount voucher.",
    },
    {
      "title": "Limited-Time Combo Offers",
      "detail":
          "Enjoy exclusive combo offers on your favorite meals. Order before the deal ends!",
    },
    {
      "title": "Delivery Update",
      "detail":
          "Your delivery is on its way! Track the live status and get ready to enjoy your order.",
    },
    {
      "title": "Midnight Cravings Sorted",
      "detail":
          "Late-night hunger? We’ve got you covered with our 24/7 delivery service. Order now!",
    },
    {
      "title": "Special Anniversary Deal",
      "detail":
          "It’s our anniversary, and we’re celebrating with discounts just for you. Thank you for being with us!",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Tcolor.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 46,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Image.asset("assets/iimg/btn_back.png",
                          width: 20, height: 20),
                    ),
                    const SizedBox(
                      width: 8,
                    ),
                    Expanded(
                      child: Text(
                        "Inbox",
                        style: TextStyle(
                            color: Tcolor.primaryText,
                            fontSize: 20,
                            fontWeight: FontWeight.w800),
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const CartPage()));
                      },
                      icon: Image.asset(
                        "assets/iimg/shopping_cart.png",
                        width: 25,
                        height: 25,
                      ),
                    ),
                  ],
                ),
              ),
              ListView.separated(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                padding: EdgeInsets.zero,
                itemCount: inboxArr.length,
                separatorBuilder: ((context, index) => Divider(
                      indent: 25,
                      endIndent: 25,
                      color: Tcolor.secondaryText.withValues(alpha: 0.4),
                      height: 1,
                    )),
                itemBuilder: ((context, index) {
                  var cObj = inboxArr[index] as Map? ?? {};
                  return Container(
                    decoration: BoxDecoration(
                        color:
                            index % 4 != 1 ? Tcolor.white : Tcolor.textfield),
                    padding: const EdgeInsets.symmetric(
                        vertical: 15, horizontal: 25),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(top: 4),
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                              color: Tcolor.primary,
                              borderRadius: BorderRadius.circular(4)),
                        ),
                        const SizedBox(
                          width: 15,
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                cObj["title"].toString(),
                                style: TextStyle(
                                    color: Tcolor.primaryText,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600),
                              ),
                              const SizedBox(
                                height: 4,
                              ),
                              Text(
                                cObj["detail"].toString(),
                                maxLines: 2,
                                style: TextStyle(
                                    color: Tcolor.secondaryText, fontSize: 14),
                              ),
                            ],
                          ),
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
    );
  }
}
