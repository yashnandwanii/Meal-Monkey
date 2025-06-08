import 'package:flutter/material.dart';

class AddressPage extends StatefulWidget {
  const AddressPage({super.key});

  @override
  State<AddressPage> createState() => _AddressPageState();
}

class _AddressPageState extends State<AddressPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Address Page'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'This is the Address Page',
          style: TextStyle(fontSize: 20, color: Colors.black54),
        ),
      ),
    );
  }
}