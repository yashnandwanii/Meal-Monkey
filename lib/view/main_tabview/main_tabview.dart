import 'package:flutter/material.dart';
import 'package:food_delivery_app/common/color_extension.dart';
import 'package:food_delivery_app/common_widgets/tab_button.dart';
import 'package:food_delivery_app/services/auth_service.dart';
import 'package:food_delivery_app/view/cart/cart_page.dart';
import 'package:food_delivery_app/view/home/homeview.dart';
import 'package:food_delivery_app/view/menu/menu_view.dart';
import 'package:food_delivery_app/view/offer/offer_view.dart';
import 'package:food_delivery_app/view/profile/profile_page.dart';

class MainTabview extends StatefulWidget {
  const MainTabview({super.key});

  @override
  State<MainTabview> createState() => _MainTabviewState();
}

class _MainTabviewState extends State<MainTabview> {
  int selectTab = 2;
  PageStorageBucket storageBucket = PageStorageBucket();

  // Cache widgets to prevent recreation
  late final List<Widget> _pages;
  late final Map<int, Widget> _cachedPages = {};

  @override
  void initState() {
    super.initState();
    _initializePages();
    _initializeApp();
  }

  void _initializePages() {
    // Initialize all pages but don't create them until needed
    _pages = [
      const MenuView(), // Index 0
      OfferView(), // Index 1
      const Homeview(), // Index 2 (default)
      const CartPage(), // Index 3
      const ProfilePage(), // Index 4
    ];

    // Pre-cache the home page since it's the default
    _cachedPages[2] = _pages[2];
  }

  Widget _getPageForIndex(int index) {
    // Return cached page if it exists, otherwise create and cache it
    if (!_cachedPages.containsKey(index)) {
      print('MainTabView: Creating new page for index $index');
      _cachedPages[index] = _pages[index];
    } else {
      print('MainTabView: Using cached page for index $index');
    }
    return _cachedPages[index]!;
  }

  void _onTabSelected(int newIndex) {
    if (selectTab != newIndex) {
      print('MainTabView: Switching from tab $selectTab to tab $newIndex');
      setState(() {
        selectTab = newIndex;
      });
    } else {
      print('MainTabView: Tab $newIndex already selected, no reload needed');
    }
  }

  void _initializeApp() async {
    try {
      print('=== INITIALIZING MAIN APP ===');

      // Refresh user data when the main app loads
      await AuthService.refreshUserData();

      print('Main app initialization completed');
    } catch (e) {
      print('Error during main app initialization: $e');
      // Don't throw error as it's not critical for app startup
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageStorage(
        bucket: storageBucket,
        child: IndexedStack(
          index: selectTab,
          children: [
            _getPageForIndex(0), // MenuView
            _getPageForIndex(1), // OfferView
            _getPageForIndex(2), // Homeview
            _getPageForIndex(3), // CartPage
            _getPageForIndex(4), // ProfilePage
          ],
        ),
      ),
      floatingActionButtonLocation:
          FloatingActionButtonLocation.miniCenterDocked,
      floatingActionButton: SizedBox(
        width: 60,
        height: 60,
        child: FloatingActionButton(
          onPressed: () => _onTabSelected(2),
          shape: const CircleBorder(),
          backgroundColor: selectTab == 2 ? Tcolor.primary : Tcolor.placeholder,
          child: Image.asset(
            'assets/iimg/tab_home.png',
            width: 30,
            height: 30,
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Colors.white,
        surfaceTintColor: Colors.white,
        shadowColor: Colors.black,
        elevation: 1,
        notchMargin: 12,
        height: 66,
        shape: const CircularNotchedRectangle(),
        child: SafeArea(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              TabButton(
                title: 'Menu',
                onTap: () => _onTabSelected(0),
                icon: 'tab_menu',
                isSelected: selectTab == 0,
              ),
              TabButton(
                title: 'Offers',
                onTap: () => _onTabSelected(1),
                icon: 'tab_offer',
                isSelected: selectTab == 1,
              ),
              const SizedBox(
                height: 40,
                width: 40,
              ),
              TabButton(
                title: 'Cart',
                onTap: () => _onTabSelected(3),
                icon: 'tab_cart',
                isSelected: selectTab == 3,
              ),
              TabButton(
                title: 'Profile',
                onTap: () => _onTabSelected(4),
                icon: 'tab_profile',
                isSelected: selectTab == 4,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
