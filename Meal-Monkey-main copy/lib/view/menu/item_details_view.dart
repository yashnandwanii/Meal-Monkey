import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:food_delivery_app/common/color_extension.dart';
import 'package:food_delivery_app/common_widgets/round_icon_button.dart';
import 'package:food_delivery_app/view/cart/cart_page.dart';
import 'package:get/get.dart';

class ItemDetailsView extends StatefulWidget {
  const ItemDetailsView({super.key});

  @override
  State<ItemDetailsView> createState() => _ItemDetailsViewState();
}

class _ItemDetailsViewState extends State<ItemDetailsView> {
  int price = 249;
  int qty = 2;
  String? sizeValue;
  String? ingredientValue;

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Tcolor.white,
      body: Stack(
        alignment: Alignment.topCenter,
        children: [
          Image.asset(
            'assets/iimg/detail_top.png',
            width: media.width,
            height: media.width,
            fit: BoxFit.cover,
          ),
          Container(
            width: media.width,
            height: media.width,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.black.withValues(alpha: 0.5),
                  Colors.black.withValues(alpha: 0.1),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Column(
                children: [
                  SizedBox(
                    height: media.width - 60,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Tcolor.white,
                      borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(30),
                          topRight: Radius.circular(30)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 20,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 25,
                          ),
                          child: Text(
                            'Tandoori Chicken Pizza',
                            style: TextStyle(
                              color: Tcolor.primaryText,
                              fontSize: 22,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 25,
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                children: [
                                  IgnorePointer(
                                    ignoring: true,
                                    child: RatingBar.builder(
                                      initialRating: 4,
                                      minRating: 1,
                                      direction: Axis.horizontal,
                                      allowHalfRating: true,
                                      itemCount: 5,
                                      itemSize: 20,
                                      itemPadding: const EdgeInsets.symmetric(
                                          horizontal: 4.0),
                                      itemBuilder: (context, _) => Icon(
                                        Icons.star,
                                        color: Tcolor.primary,
                                      ),
                                      onRatingUpdate: (rating) {
                                        // Do nothing, as this is read-only;
                                      },
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    '4.0 (23 Reviews)',
                                    style: TextStyle(
                                        color: Tcolor.primary,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ],
                              ),
                              Column(
                                children: [
                                  Text(
                                    '₹ ${price * qty} ',
                                    style: TextStyle(
                                      color: Tcolor.primaryText,
                                      fontSize: 31,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          qty = qty - 1;

                                          if (qty < 1) {
                                            qty = 1;
                                          }
                                          setState(() {});
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 15),
                                          height: 25,
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                              color: Tcolor.primary,
                                              borderRadius:
                                                  BorderRadius.circular(12.5)),
                                          child: Text(
                                            "-",
                                            style: TextStyle(
                                                color: Tcolor.white,
                                                fontSize: 14,
                                                fontWeight: FontWeight.w700),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 8,
                                      ),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 15),
                                        height: 25,
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                              color: Tcolor.primary,
                                            ),
                                            borderRadius:
                                                BorderRadius.circular(12.5)),
                                        child: Text(
                                          qty.toString(),
                                          style: TextStyle(
                                              color: Tcolor.primary,
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 8,
                                      ),
                                      InkWell(
                                        onTap: () {
                                          qty = qty + 1;

                                          setState(() {});
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 15),
                                          height: 25,
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                              color: Tcolor.primary,
                                              borderRadius:
                                                  BorderRadius.circular(12.5)),
                                          child: Text(
                                            "+",
                                            style: TextStyle(
                                                color: Tcolor.white,
                                                fontSize: 14,
                                                fontWeight: FontWeight.w700),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 25,
                          ),
                          child: Text(
                            'Description',
                            style: TextStyle(
                              color: Tcolor.primaryText,
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 25,
                          ),
                          child: Text(
                            'Tandoori Chicken Pizza is a delicious fusion dish that combines the flavors of Indian tandoori chicken with the cheesy goodness of pizza. It features a pizza base topped with tandoori-marinated chicken pieces, tangy tomato sauce, melted mozzarella cheese, and a mix of vegetables like onions, bell peppers, or tomatoes. The pizza is often garnished with fresh cilantro or a drizzle of yogurt-based sauce to balance the spices. It\'s a perfect blend of Indian and Italian cuisines, offering a deliciously unique taste.',
                            style: TextStyle(
                              color: Tcolor.secondaryText,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                            textAlign: TextAlign.justify,
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Divider(
                          color: Tcolor.secondaryText.withValues(alpha: 0.4),
                          thickness: 1,
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 25,
                          ),
                          child: Text(
                            'Customize your Pizza',
                            style: TextStyle(
                              color: Tcolor.primaryText,
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 25,
                          ),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            width: media.width - 50,
                            decoration: BoxDecoration(
                              color: Tcolor.textfield,
                              borderRadius: BorderRadius.circular(25),
                            ),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton(
                                isExpanded: true,
                                items: const [
                                  DropdownMenuItem(
                                    value: 'Small',
                                    child: Text('Small'),
                                  ),
                                  DropdownMenuItem(
                                    value: 'Medium',
                                    child: Text('Medium'),
                                  ),
                                  DropdownMenuItem(
                                    value: 'Large',
                                    child: Text('Large'),
                                  ),
                                ],
                                onChanged: (value) {
                                  setState(() {
                                    sizeValue = value;
                                  });
                                },
                                hint: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 20,
                                  ),
                                  child: Text(
                                    sizeValue ?? '- Select the size -',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Tcolor.primaryText,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 25,
                          ),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            width: media.width - 50,
                            decoration: BoxDecoration(
                              color: Tcolor.textfield,
                              borderRadius: BorderRadius.circular(25),
                            ),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton(
                                isExpanded: true,
                                items: const [
                                  DropdownMenuItem(
                                    value: 'Extra Cheeze',
                                    child: Text('Extra Cheeze'),
                                  ),
                                  DropdownMenuItem(
                                    value: 'Extra Toppings',
                                    child: Text('Extra Toppings'),
                                  ),
                                  DropdownMenuItem(
                                    value: 'Extra Spices',
                                    child: Text('Extra Spices'),
                                  ),
                                ],
                                onChanged: (value) {
                                  setState(() {
                                    ingredientValue = value;
                                  });
                                },
                                hint: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 20,
                                  ),
                                  child: Text(
                                    ingredientValue ??
                                        '- Select the ingredients -',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Tcolor.primaryText,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    height: 220,
                    child: Stack(
                      alignment: Alignment.centerLeft,
                      children: [
                        Container(
                          width: media.width * 0.25,
                          height: 160,
                          decoration: BoxDecoration(
                            color: Tcolor.primary,
                            borderRadius: const BorderRadius.only(
                                topRight: Radius.circular(35),
                                bottomRight: Radius.circular(35)),
                          ),
                        ),
                        Center(
                          child: Stack(
                            alignment: Alignment.centerRight,
                            children: [
                              Container(
                                  margin: const EdgeInsets.only(
                                      top: 8, bottom: 8, left: 10, right: 20),
                                  width: media.width - 80,
                                  height: 120,
                                  decoration: const BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(35),
                                          bottomLeft: Radius.circular(35),
                                          topRight: Radius.circular(10),
                                          bottomRight: Radius.circular(10)),
                                      boxShadow: [
                                        BoxShadow(
                                            color: Colors.black12,
                                            blurRadius: 12,
                                            offset: Offset(0, 4))
                                      ]),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        "Total Price",
                                        style: TextStyle(
                                            color: Tcolor.primaryText,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w500),
                                      ),
                                      const SizedBox(
                                        height: 4,
                                      ),
                                      Text(
                                        "\$${(price * qty).toString()}",
                                        style: TextStyle(
                                            color: Tcolor.primaryText,
                                            fontSize: 21,
                                            fontWeight: FontWeight.w700),
                                      ),
                                      const SizedBox(
                                        height: 4,
                                      ),
                                      SizedBox(
                                        width: 150,
                                        height: 40,
                                        child: RoundIconButton(
                                            title: "Add to Cart",
                                            icon:
                                                "assets/iimg/shopping_add.png",
                                            color: Tcolor.primary,
                                            onPressed: () {
                                              Get.to(
                                                () => const CartPage(),
                                                preventDuplicates: true,
                                                transition:
                                                    Transition.rightToLeft,
                                              );
                                            }),
                                      )
                                    ],
                                  )),
                              InkWell(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const CartPage()));
                                },
                                child: Container(
                                  width: 45,
                                  height: 45,
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(22.5),
                                      boxShadow: const [
                                        BoxShadow(
                                            color: Colors.black12,
                                            blurRadius: 4,
                                            offset: Offset(0, 2))
                                      ]),
                                  alignment: Alignment.center,
                                  child: Image.asset(
                                      "assets/iimg/shopping_cart.png",
                                      width: 20,
                                      height: 20,
                                      color: Tcolor.primary),
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Column(
              children: [
                const SizedBox(
                  height: 35,
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
                          color: Tcolor.white,
                          width: 20,
                          height: 20,
                        ),
                      ),
                      Text(
                        '',
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
                              builder: (context) => const CartPage(),
                            ),
                          );
                        },
                        icon: Image.asset(
                          'assets/iimg/shopping_cart.png',
                          color: Tcolor.white,
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
              ],
            ),
          ),
        ],
      ),
    );
  }
}
