import 'package:flutter/material.dart';
import 'package:food_delivery_app/common/color_extension.dart';
import 'package:food_delivery_app/common_widgets/tab_button.dart';
import 'package:food_delivery_app/view/home/homeview.dart';
import 'package:food_delivery_app/view/menu/menu_view.dart';
import 'package:food_delivery_app/view/more/more_view.dart';
import 'package:food_delivery_app/view/offer/offer_view.dart';

class MainTabview extends StatefulWidget {
  const MainTabview({super.key});

  @override
  State<MainTabview> createState() => _MainTabviewState();
}

class _MainTabviewState extends State<MainTabview> {
  int selectTab = 2;
  PageStorageBucket storageBucket = PageStorageBucket();
  Widget selectPageView = const Homeview();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageStorage(bucket: storageBucket, child: selectPageView),
      floatingActionButtonLocation:
          FloatingActionButtonLocation.miniCenterDocked,
      floatingActionButton: SizedBox(
        width: 60,
        height: 60,
        child: FloatingActionButton(
          onPressed: () {
            if (selectTab != 2) {
              selectTab = 2;
              selectPageView = const Homeview();
            } else {}
            if (mounted) {
              setState(() {
                selectTab = 2;
                selectPageView = const Homeview();
              });
            }
          },
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
                onTap: () {
                  if (selectTab != 0) {
                    selectTab = 0;
                    selectPageView = const MenuView();
                  }
                  if (mounted) {
                    setState(() {
                      selectTab = 0;
                      selectPageView = const MenuView();
                    });
                  }
                },
                icon: 'tab_menu',
                isSelected: selectTab == 0,
              ),
              TabButton(
                title: 'Offers',
                onTap: () {
                  if (selectTab != 1) {
                    selectTab = 1;
                    selectPageView = const OfferView();
                  }
                  if (mounted) {
                    setState(() {
                      selectTab = 1;
                      selectPageView = const OfferView();
                    });
                  }
                },
                icon: 'tab_offer',
                isSelected: selectTab == 1,
              ),
              const SizedBox(
                height: 40,
                width: 40,
              ),
              TabButton(
                title: 'Profile',
                onTap: () {
                  // if (selectTab != 3) {
                  //   selectTab = 3;
                  //   selectPageView = const ProfileView();
                  // }
                  // if (mounted) {
                  //   setState(() {
                  //     selectTab = 3;
                  //     selectPageView = const ProfileView();
                  //   });
                  // }
                },
                icon: 'tab_profile',
                isSelected: selectTab == 3,
              ),
              TabButton(
                title: 'More',
                onTap: () {
                  if (selectTab != 4) {
                    selectTab = 4;
                    selectPageView = const MoreView();
                  }
                  if (mounted) {
                    setState(() {
                      selectTab = 4;
                      selectPageView = const MoreView();
                    });
                  }
                },
                icon: 'tab_more',
                isSelected: selectTab == 4,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
