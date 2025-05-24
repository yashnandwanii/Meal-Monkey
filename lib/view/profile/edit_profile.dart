import 'package:flutter/material.dart';
import 'package:food_delivery_app/common/color_extension.dart';

class EditAccountPage extends StatefulWidget {
  const EditAccountPage({super.key});

  @override
  State<EditAccountPage> createState() => _EditAccountPageState();
}

class _EditAccountPageState extends State<EditAccountPage> {
  final TextEditingController _nameController =
      TextEditingController(text: "yash");
  final TextEditingController _emailController =
      TextEditingController(text: "yasharora9084@gmail.com");
  final TextEditingController _phoneController =
      TextEditingController(text: "8690642344");

  void _editField(TextEditingController controller, String title) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: Text("Edit $title"),
          content: TextField(
            controller: controller,
            decoration: InputDecoration(hintText: "Enter $title"),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                setState(() {});
                Navigator.pop(context);
              },
              child: const Text("Save"),
            ),
          ],
        );
      },
    );
  }

  Future<void> updateDetails()async{
    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          TextButton(
            onPressed: () {},
            child: Text("Save", style: TextStyle(color: Tcolor.primary)),
          ),
        ],
        title: const Text(
          "EDIT ACCOUNT",
          style: TextStyle(
            color: Colors.black,
            fontSize: 16,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildEditableField("NAME", _nameController),
            _buildEditableField("EMAIL ADDRESS", _emailController),
            _buildEditableField("PHONE NUMBER", _phoneController,
                prefix: "+91  "),
          ],
        ),
      ),
    );
  }

  Widget _buildEditableField(String label, TextEditingController controller,
      {String prefix = ""}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: const TextStyle(
                  fontWeight: FontWeight.bold, color: Colors.grey)),
          const SizedBox(height: 4),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Colors.grey.shade400),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: TextField(
                    controller: controller,
                    readOnly: true,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      prefixText: prefix,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () => _editField(controller, label),
                  child: Text(
                    "EDIT",
                    style: TextStyle(color: Tcolor.primary),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
