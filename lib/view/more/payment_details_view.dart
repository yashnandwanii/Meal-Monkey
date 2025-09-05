import 'package:flutter/material.dart';
import 'package:food_delivery_app/common/color_extension.dart';
import 'package:food_delivery_app/common_widgets/round_button.dart';
import 'package:food_delivery_app/common_widgets/round_icon_button.dart';
import 'package:food_delivery_app/view/more/add_card_view.dart';
import 'package:food_delivery_app/view/cart/cart_page.dart';

class PaymentDetailsView extends StatefulWidget {
  const PaymentDetailsView({
    super.key,
  });

  @override
  State<PaymentDetailsView> createState() => _PaymentDetailsViewState();
}

class _PaymentDetailsViewState extends State<PaymentDetailsView> {
  TextEditingController txtController = TextEditingController();

  List cardArr = [
    {
      'icon': 'assets/iimg/visa_icon.png',
      'card': '**** **** **** 2187',
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
                      'Payment Details',
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
                        width: 25,
                        height: 25,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                child: Text(
                  'Customize your payment method',
                  style: TextStyle(
                    color: Tcolor.primaryText,
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: Divider(
                  color: Tcolor.textfield,
                  height: 1,
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                padding: EdgeInsets.zero,
                itemCount: cardArr.length,
                itemBuilder: ((context, index) {
                  var mObj = cardArr[index] as Map? ?? {};
                  return Container(
                    margin:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 15,
                    ),
                    decoration: BoxDecoration(
                      color: Tcolor.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 10,
                          offset: Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Text(
                              'Cash/Card On Delivery',
                              style: TextStyle(
                                color: Tcolor.secondaryText,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const Spacer(),
                            Image.asset(
                              'assets/iimg/check.png',
                              width: 20,
                              height: 20,
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Divider(
                            height: 1,
                            color: Colors.grey[200],
                          ),
                        ),
                        Row(
                          children: [
                            Image.asset(
                              mObj['icon'].toString(),
                              width: 50,
                              height: 35,
                            ),
                            const SizedBox(width: 15),
                            Text(
                              mObj['card'].toString(),
                              style: TextStyle(
                                color: Tcolor.primaryText,
                                fontSize: 16,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            const Spacer(),
                            SizedBox(
                              height: 35,
                              width: 100,
                              child: RoundButton(
                                onPressed: () {},
                                text: 'Delete',
                                type: RoundButtonType.textPrimary,
                              ),
                            )
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Divider(
                            height: 1,
                            color: Colors.grey[200],
                          ),
                        ),
                        Row(
                          children: [
                            Text(
                              'Other Methods',
                              style: TextStyle(
                                color: Tcolor.secondaryText,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  );
                }),
              ),
              const SizedBox(
                height: 15,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: RoundIconButton(
                  onPressed: () {
                    showModalBottomSheet(
                        context: context,
                        builder: (context) {
                          return const AddCardView();
                        });
                  },
                  title: 'Add Another Credit/Debit Card',
                  icon: 'assets/iimg/add.png',
                  fontSize: 16,
                  color: Tcolor.primary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
