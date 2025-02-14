import 'package:flutter/material.dart';
import 'package:food_delivery_app/common/color_extension.dart';
import 'package:food_delivery_app/view/more/about_us_view.dart';
import 'package:food_delivery_app/view/more/inbox_view.dart';
import 'package:food_delivery_app/view/more/my_order_view.dart';
import 'package:food_delivery_app/view/more/notifications_view.dart';
import 'package:food_delivery_app/view/more/payment_details_view.dart';

class MoreView extends StatefulWidget {
  const MoreView({super.key});

  @override
  State<MoreView> createState() => _MoreViewState();
}

class _MoreViewState extends State<MoreView> {
  final List<Map<String, String>> moreArr = [
    {
      'index': '1',
      'name': 'Payment Details',
      'image': 'assets/iimg/more_payment.png',
    },
    {
      'index': '2',
      'name': 'My Order',
      'image': 'assets/iimg/more_my_order.png',
    },
    {
      'index': '3',
      'name': 'Notifications',
      'image': 'assets/iimg/more_notification.png',
    },
    {
      'index': '4',
      'name': 'Inbox',
      'image': 'assets/iimg/more_inbox.png',
    },
    {
      'index': '5',
      'name': 'About Us',
      'image': 'assets/iimg/more_info.png',
    },
  ];

  // Map to handle navigation based on index
  final Map<String, Widget> navigationMap = {
    '1': const PaymentDetailsView(),
    '2': const MyOrderView(),
    '3': const NotificationsView(),
    '4': const InboxView(),
    '5': const AboutUsView(),
  };

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Tcolor.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 46),
              _buildHeader(context),
              ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: moreArr.length,
                itemBuilder: (context, index) {
                  final mObj = moreArr[index];
                  return _buildMoreItem(
                    context,
                    media,
                    name: mObj['name'] ?? 'Unknown',
                    image: mObj['image'] ?? '',
                    index: mObj['index'] ?? '',
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            "More",
            style: TextStyle(
              color: Tcolor.primaryText,
              fontSize: 20,
              fontWeight: FontWeight.w800,
            ),
          ),
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const MyOrderView(),
                ),
              );
            },
            icon: Image.asset(
              "assets/iimg/shopping_cart.png",
              width: 25,
              height: 25,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMoreItem(
    BuildContext context,
    Size media, {
    required String name,
    required String image,
    required String index,
  }) {
    return InkWell(
      onTap: () {
        final destination = navigationMap[index];
        if (destination != null) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => destination),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text("This feature is not implemented yet")),
          );
        }
      },
      child: Row(
        children: [
          Container(
            alignment: Alignment.center,
            height: 100,
            width: media.width - 70,
            margin: const EdgeInsets.only(left: 20, bottom: 15),
            padding: const EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(10),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 10,
                  offset: Offset(0, 5),
                ),
              ],
            ),
            child: ListTile(
              leading: Container(
                padding: const EdgeInsets.all(15),
                height: 100,
                width: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.grey[300],
                ),
                child: Image.asset(
                  image,
                  width: 70,
                  height: 70,
                  errorBuilder: (context, error, stackTrace) =>
                      const Icon(Icons.error, color: Colors.red),
                ),
              ),
              title: Text(
                name,
                style: TextStyle(
                  color: Tcolor.primaryText,
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
            ),
            child: Icon(
              Icons.arrow_forward_ios,
              color: Tcolor.primary,
            ),
          ),
        ],
      ),
    );
  }
}
