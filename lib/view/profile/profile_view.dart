import 'package:flutter/material.dart';

import 'package:food_delivery_app/common/color_extension.dart';
import 'package:food_delivery_app/view/profile/edit_profile.dart';
import 'package:page_transition/page_transition.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Tcolor.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text("Profile"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          TextButton(
            onPressed: () {},
            child: const Text("Help"),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildProfileHeader(),
            const SizedBox(height: 16),
            _buildListTile(
              title: "Meal Monkey Prime",
              subtitle:
                  "₹472 saved with previous plan\nRenew now to unlock exclusive benefits",
              trailing:
                  const Text("EXPIRED", style: TextStyle(color: Colors.orange)),
            ),
            _buildListTile(
              title: "Meal Monkey Credit Card",
              subtitle: "Apply for the card and start earning cashbacks!",
            ),
            _buildListTile(
              title: "My Vouchers",
              subtitle: "Scratch and win exciting vouchers",
              trailing: const Text("NEW", style: TextStyle(color: Colors.red)),
            ),
            _buildListTile(
              title: "My Account",
              subtitle: "Favourites, Hidden restaurants & Settings",
            ),
            _buildListTile(
              title: "My Eatlists",
              subtitle: "View all your saved lists in one place",
            ),
            _buildListTile(
              title: "Addresses",
              subtitle: "Share, Edit & Add New Addresses",
            ),
            _buildListTile(
              title: "Payments & Refunds",
              subtitle: "Refund Status & Payment Modes",
            ),
            _buildListTile(
              title: "Meal Monkey Money & Gift Cards",
              subtitle: "Account balance, Gift cards & Transaction History",
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
              child: const Center(
                child: Text(
                  "BROWSE PAST ORDERS",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "YASH",
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        const Text(
          "+91 - 8690642344  •  yasharora9084@gmail.com",
          style: TextStyle(color: Colors.grey),
        ),
        const SizedBox(height: 8),
        TextButton(
          onPressed: () {
            
            Navigator.push(
              context,
              PageTransition(
                type: PageTransitionType.fade,
                child: const EditAccountPage(),
              ),
            );
          },
          child: const Text(
            "Edit Profile",
            style: TextStyle(color: Colors.orange),
          ),
        ),
      ],
    );
  }

  Widget _buildListTile({
    required String title,
    required String subtitle,
    Widget? trailing,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle),
        trailing: trailing,
      ),
    );
  }
}
