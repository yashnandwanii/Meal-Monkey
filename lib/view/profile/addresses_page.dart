import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:food_delivery_app/common/background_container.dart';
import 'package:food_delivery_app/common/color_extension.dart';
import 'package:food_delivery_app/common/constants.dart';
import 'package:food_delivery_app/hooks/fetch_addresses.dart';
import 'package:food_delivery_app/models/addresses_response.dart';
import 'package:food_delivery_app/view/profile/widget/address_tile.dart';

class AddressPage extends HookWidget {
  const AddressPage({super.key});

  @override
  Widget build(BuildContext context) {
    final hookResults = useFetchAllAddresses();
    final List<AddressResponse>? addresses = hookResults.data ?? [];
    final bool isLoading = hookResults.isLoading;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Address Page'),
        centerTitle: true,
        backgroundColor: offWhite,
      ),
      body: BackgroundContainer(
        color: offWhite,
        child: Stack(
          children: [
            if (isLoading)
              const CircularProgressIndicator()
            else
              ListView.builder(
                itemCount: addresses!.length,
                itemBuilder: (context, index) {
                  final address = addresses[index];
                  return AddressTile(address: address);
                },
              ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Handle add address action
        },
        backgroundColor: Tcolor.primary,
        child: const Icon(
          Icons.add,
          color: offWhite,
        ),
      ),
    );
  }
}
