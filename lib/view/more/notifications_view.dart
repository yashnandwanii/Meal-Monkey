import 'package:flutter/material.dart';
import 'package:food_delivery_app/common/color_extension.dart';
import 'package:food_delivery_app/view/cart/cart.dart';

class NotificationsView extends StatefulWidget {
  const NotificationsView({super.key});

  @override
  State<NotificationsView> createState() => _NotificationsViewState();
}

class _NotificationsViewState extends State<NotificationsView> {
  List notificationArr = [
    {
      "title": "Your order has been picked up by the delivery partner.",
      "time": "Now",
    },
    {
      "title": "Your order has been successfully delivered. Enjoy your meal!",
      "time": "1 h ago",
    },
    {
      "title": "The delivery partner is on the way with your order.",
      "time": "3 h ago",
    },
    {
      "title": "Your order was delivered. We hope you loved it!",
      "time": "5 h ago",
    },
    {
      "title": "Your order was picked up and is heading your way.",
      "time": "05 Jun 2023",
    },
    {
      "title": "Delivery completed. Thanks for choosing [App Name]!",
      "time": "05 Jun 2023",
    },
    {
      "title": "The delivery partner has picked up your order. Get ready!",
      "time": "06 Jun 2023",
    },
    {
      "title": "Your delivery was successful. Have a great meal!",
      "time": "06 Jun 2023",
    },
    {
      "title": "Your order has been picked up by the delivery partner.",
      "time": "Now",
    },
    {
      "title": "Your order has been successfully delivered. Enjoy your meal!",
      "time": "1 h ago",
    },
    {
      "title": "The delivery partner is on the way with your order.",
      "time": "3 h ago",
    },
    {
      "title": "Your order was delivered. We hope you loved it!",
      "time": "5 h ago",
    },
    {
      "title": "Your order was picked up and is heading your way.",
      "time": "05 Jun 2023",
    },
    {
      "title": "Delivery completed. Thanks for choosing [App Name]!",
      "time": "05 Jun 2023",
    },
    {
      "title": "The delivery partner has picked up your order. Get ready!",
      "time": "06 Jun 2023",
    },
    {
      "title": "Your delivery was successful. Have a great meal!",
      "time": "06 Jun 2023",
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
                        "Notifications",
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
                                builder: (context) => const MyOrderView()));
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
                itemCount: notificationArr.length,
                separatorBuilder: ((context, index) => Divider(
                      indent: 25,
                      endIndent: 25,
                      color: Tcolor.secondaryText.withValues(alpha: 0.4),
                      height: 1,
                    )),
                itemBuilder: ((context, index) {
                  var cObj = notificationArr[index] as Map? ?? {};
                  return Container(
                    decoration: BoxDecoration(
                        color:
                            index % 2 == 0 ? Tcolor.white : Tcolor.textfield),
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
                                cObj["time"].toString(),
                                style: TextStyle(
                                    color: Tcolor.secondaryText,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500),
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
