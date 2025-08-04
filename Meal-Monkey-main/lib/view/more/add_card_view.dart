import 'package:flutter/material.dart';
import 'package:food_delivery_app/common/color_extension.dart';
import 'package:food_delivery_app/common_widgets/round_icon_button.dart';
import 'package:food_delivery_app/common_widgets/round_textfield.dart';

class AddCardView extends StatefulWidget {
  const AddCardView({super.key});

  @override
  State<AddCardView> createState() => _AddCardViewState();
}

class _AddCardViewState extends State<AddCardView> {
  TextEditingController cardNumberController = TextEditingController();
  TextEditingController securitycodeController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController txtCardMonth = TextEditingController();
  TextEditingController txtCardYear = TextEditingController();
  bool isAnytime = false;

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return Container(
      height: media.height,
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 25),
      width: media.width,
      decoration: BoxDecoration(
        color: Tcolor.white,
        borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20), topRight: Radius.circular(20)),
      ),
      alignment: Alignment.bottomCenter,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Add Credit/Debit Card',
                style: TextStyle(
                  color: Tcolor.primary,
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
              IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(
                  Icons.close,
                  color: Tcolor.primaryText,
                  size: 25,
                ),
              ),
            ],
          ),
          Divider(
            height: 1,
            color: Colors.grey[200],
          ),
          const SizedBox(
            height: 15,
          ),
          RoundTextfield(
            hintText: 'Card Number',
            controller: cardNumberController,
          ),
          const SizedBox(
            height: 15,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Expiry',
                style: TextStyle(
                  color: Tcolor.primaryText,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              SizedBox(
                width: 80,
                child: RoundTextfield(
                  hintText: 'MM',
                  controller: txtCardMonth,
                ),
              ),
              const SizedBox(
                width: 15,
              ),
              SizedBox(
                width: 80,
                child: RoundTextfield(
                  hintText: 'YYYY',
                  controller: txtCardYear,
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 15,
          ),
          RoundTextfield(
            hintText: 'Security Code',
            controller: securitycodeController,
          ),
          const SizedBox(
            height: 15,
          ),
          RoundTextfield(
            hintText: 'Full Name',
            controller: nameController,
          ),
          const SizedBox(
            height: 15,
          ),
          Row(
            children: [
              Text(
                'Save card for future payments',
                style: TextStyle(
                  color: Tcolor.primaryText,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              Switch(
                  value: isAnytime,
                  activeColor: Tcolor.primary,
                  onChanged: (newVal) {
                    setState(() {
                      isAnytime = newVal;
                    });
                  })
            ],
          ),
          const SizedBox(
            height: 15,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: RoundIconButton(
              onPressed: () {},
              title: 'Add card',
              icon: 'assets/iimg/add.png',
              fontSize: 16,
              color: Tcolor.primary,
            ),
          ),
          const SizedBox(
            height: 15,
          ),
        ],
      ),
    );
  }
}
