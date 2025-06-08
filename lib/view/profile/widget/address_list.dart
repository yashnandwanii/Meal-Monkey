import 'package:flutter/material.dart';
import 'package:food_delivery_app/models/addresses_response.dart';
import 'package:food_delivery_app/view/profile/widget/address_tile.dart';

class AddressListWidget extends StatelessWidget {
  const AddressListWidget({super.key, required this.addresses});

  final List<AddressResponse>
      addresses; // Replace with the actual list of addresses

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount:
          addresses.length, // Replace with the actual number of addresses
      itemBuilder: (context, index) {
        final address = addresses[index];
        return Container(
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: Colors.grey.shade300,
                width: 0.5,
              ),
              top: BorderSide(
                color: Colors.grey.shade300,
                width: 0.5,
              ),
            ),
          ),
          child: AddressTile(address: address),
        );
      },
    );
  }
}
