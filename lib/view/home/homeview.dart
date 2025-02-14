import 'package:flutter/material.dart';
import 'package:food_delivery_app/common/color_extension.dart';
import 'package:food_delivery_app/common_widgets/category_cell.dart';
import 'package:food_delivery_app/common_widgets/most_popular_cell.dart';
import 'package:food_delivery_app/common_widgets/popular_restaurent_row.dart';
import 'package:food_delivery_app/common_widgets/recent_item_row.dart';
import 'package:food_delivery_app/common_widgets/round_textfield.dart';
import 'package:food_delivery_app/common_widgets/view_all_title_row.dart';
import 'package:food_delivery_app/view/more/my_order_view.dart';

class Homeview extends StatefulWidget {
  const Homeview({super.key});

  @override
  State<Homeview> createState() => _HomeviewState();
}

class _HomeviewState extends State<Homeview> {
  TextEditingController txtController = TextEditingController();
  List catArr = [
    {'image': 'assets/iimg/cat_offer.png', 'name': 'Offers'},
    {'image': 'assets/iimg/cat_sri.png', 'name': 'Sri Lankan'},
    {'image': 'assets/iimg/cat_3.png', 'name': 'Italian'},
    {'image': 'assets/iimg/cat_4.png', 'name': 'Indian'},
  ];
  List popArr = [
    {
      'image': 'assets/iimg/res_1.png',
      'name': 'Minute by Tuk Tuk',
      'rate': '4.9',
      'rating': '124',
      'type': 'Cafa',
      "food_type": "Western Food"
    },
    {
      'image': 'assets/iimg/res_2.png',
      'name': 'Cafe de Noir',
      'rate': '4.9',
      'rating': '124',
      'type': 'Cafa',
      "food_type": "Western Food"
    },
    {
      'image': 'assets/iimg/res_3.png',
      'name': 'Bakes by Tella',
      'rate': '4.9',
      'rating': '124',
      'type': 'Cafa',
      "food_type": "Western Food"
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
      backgroundColor: Tcolor.white,
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
                    Text(
                      'Good Morning Akila!',
                      style: TextStyle(
                        color: Tcolor.primaryText,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
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
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Delivering to ',
                      style: TextStyle(
                        color: Tcolor.secondaryText,
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(
                      height: 6,
                    ),
                    Row(
                      children: [
                        Text(
                          'Current Location',
                          style: TextStyle(
                            color: Tcolor.secondaryText,
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(
                          width: 25,
                        ),
                        Image.asset(
                          'assets/iimg/dropdown.png',
                          width: 12,
                          height: 12,
                        ),
                      ],
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
              const SizedBox(
                height: 30,
              ),
              SizedBox(
                height: 120,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  itemCount: catArr.length,
                  itemBuilder: ((context, index) {
                    var cObj = catArr[index] as Map? ?? {};
                    return CategoryCell(cObj: cObj, onTap: () {});
                  }),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                ),
                child: ViewAllTitleRow(
                  title: 'Popular Restaurents',
                  onView: () {},
                ),
              ),
              ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                padding: EdgeInsets.zero,
                itemCount: popArr.length,
                itemBuilder: ((context, index) {
                  var pObj = popArr[index] as Map? ?? {};
                  return PopularRestaurentRow(
                    pObj: pObj,
                    onTap: () {},
                  );
                }),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                ),
                child: ViewAllTitleRow(
                  title: 'Most Popular',
                  onView: () {},
                ),
              ),
              SizedBox(
                height: 220,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  itemCount: mostPopArr.length,
                  itemBuilder: ((context, index) {
                    var mObj = mostPopArr[index] as Map? ?? {};
                    return MostPopularCell(
                      mObj: mObj,
                      onTap: () {},
                    );
                  }),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                ),
                child: ViewAllTitleRow(
                  title: 'Recent Items',
                  onView: () {},
                ),
              ),
              ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                padding: const EdgeInsets.symmetric(horizontal: 15),
                itemCount: recentArr.length,
                itemBuilder: ((context, index) {
                  var rObj = recentArr[index] as Map? ?? {};
                  return RecentItemRow(
                    rObj: rObj,
                    onTap: () {},
                  );
                }),
              )
            ],
          ),
        ),
      ),
    );
  }
}
