import 'package:flutter/material.dart';
import 'package:food_delivery_app/common/color_extension.dart';
import 'package:food_delivery_app/common_widgets/menu_item_row.dart';
import 'package:food_delivery_app/common_widgets/round_textfield.dart';
import 'package:food_delivery_app/view/menu/item_details_view.dart';
import 'package:food_delivery_app/view/cart/cart.dart';

class MenuItemView extends StatefulWidget {
  final Map mObj;
  const MenuItemView({super.key, required this.mObj});

  @override
  State<MenuItemView> createState() => _MenuItemViewState();
}

class _MenuItemViewState extends State<MenuItemView> {
  TextEditingController txtController = TextEditingController();

  List menuItemArr = [
    {
      'image': 'assets/iimg/dess_1.png',
      'name': 'French Apple Pie',
      'rate': '4.9',
      'rating': '124',
      'type': 'Minute by Tuk Tuk',
      "food_type": "Dessets"
    },
    {
      'image': 'assets/iimg/dess_2.png',
      'name': 'Dark Chocolate Cake',
      'rate': '4.7',
      'rating': '124',
      'type': 'Cakes by Tella',
      "food_type": "Dessets"
    },
    {
      'image': 'assets/iimg/dess_3.png',
      'name': 'Street shake',
      'rate': '4.9',
      'rating': '124',
      'type': 'Cafe Racer',
      "food_type": "Dessets"
    },
    {
      'image': 'assets/iimg/dess_4.png',
      'name': 'Fudgy Chewy Brownies',
      'rate': '4.8',
      'rating': '124',
      'type': 'Minute by Tuk Tuk',
      "food_type": "Dessets"
    },
  ];

  List mostPopArr = [
    {
      'image': 'assets/iimg/m_res_1.png',
      'name': 'Minute by Tuk Tuk',
      'rate': '4.9',
      'rating': '124',
      'type': 'Cafa',
      "food_type": "Western Food"
    },
    {
      'image': 'assets/iimg/m_res_2.png',
      'name': 'Cafe de Noir',
      'rate': '4.9',
      'rating': '124',
      'type': 'Cafa',
      "food_type": "Western Food"
    },
  ];

  List recentArr = [
    {
      'image': 'assets/iimg/item_1.png',
      'name': 'Mulberry Pizza by Josh',
      'rate': '4.9',
      'rating': '124',
      'type': 'Cafa',
      "food_type": "Western Food"
    },
    {
      'image': 'assets/iimg/item_2.png',
      'name': 'Barita',
      'rate': '4.9',
      'rating': '124',
      'type': 'Cafa',
      "food_type": "Western Food"
    },
    {
      'image': 'assets/iimg/item_3.png',
      'name': 'Pizza Rush Hour',
      'rate': '4.9',
      'rating': '124',
      'type': 'Cafa',
      "food_type": "Western Food"
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Column(
            children: [
              const SizedBox(
                height: 46,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Image.asset(
                        'assets/iimg/btn_back.png',
                        width: 20,
                        height: 20,
                      ),
                    ),
                    Text(
                      widget.mObj['name'].toString(),
                      style: TextStyle(
                          color: Tcolor.primaryText,
                          fontSize: 20,
                          fontWeight: FontWeight.w800),
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
                        'assets/iimg/shopping_cart.png',
                        width: 25,
                        height: 25,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: RoundTextfield(
                  hintText: 'Search Food',
                  controller: txtController,
                  left: Container(
                    alignment: Alignment.center,
                    width: 30,
                    child: Image.asset(
                      'assets/iimg/search.png',
                      width: 20,
                      height: 20,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 15),
              ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                padding: EdgeInsets.zero,
                itemCount: menuItemArr.length,
                itemBuilder: ((context, index) {
                  var mObj = menuItemArr[index] as Map? ?? {};
                  return MenuItemRow(
                    mObj: mObj,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ItemDetailsView(),
                        ),
                      );
                    },
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
