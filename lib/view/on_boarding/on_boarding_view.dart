import 'package:flutter/material.dart';
import 'package:food_delivery_app/common/color_extension.dart';
import 'package:food_delivery_app/common_widgets/round_button.dart';
import 'package:food_delivery_app/view/main_tabview/main_tabview.dart';

class OnBoardingView extends StatefulWidget {
  const OnBoardingView({super.key});

  @override
  State<OnBoardingView> createState() => _OnBoardingViewState();
}

class _OnBoardingViewState extends State<OnBoardingView> {
  int selectPage = 0;
  PageController controller = PageController();

  List pageArr = [
    {
      'title': 'Find Food You Love',
      'subtitle':
          'Discover the best foods from over 1000\n restaurants and fast delivery to your\ndoorstep',
      'image': 'assets/iimg/on_boarding_1.png',
    },
    {
      'title': 'Fast Delivery',
      'subtitle': 'Fast food delivery to your home, office\n wherever you are',
      'image': 'assets/iimg/on_boarding_2.png',
    },
    {
      'title': 'Live Tracking',
      'subtitle':
          'Real time tracking of your food on the app\nonce you placed the order',
      'image': 'assets/iimg/on_boarding_3.png',
    },
  ];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller.addListener(() {
      setState(() {
        selectPage = controller.page?.floor() ?? 0;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: [
          PageView.builder(
            controller: controller,
            itemCount: pageArr.length,
            itemBuilder: ((context, index) {
              var pObj = pageArr[index] as Map? ?? {};
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: media.width,
                    height: media.width,
                    alignment: Alignment.center,
                    child: Image.asset(
                      pObj['image'].toString(),
                      width: media.width * 0.65,
                      fit: BoxFit.contain,
                    ),
                  ),
                  SizedBox(
                    height: media.width * 0.1,
                  ),
                  Text(
                    pObj['title'].toString(),
                    style: TextStyle(
                      fontSize: 28,
                      color: Tcolor.primaryText,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  SizedBox(
                    height: media.width * 0.1,
                  ),
                  Text(
                    pObj['subtitle'].toString(),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 13,
                      color: Tcolor.secondaryText,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(
                    height: media.width * 0.2,
                  ),
                ],
              );
            }),
          ),
          Column(
            children: [
              const Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  pageArr.length,
                  (index) => Container(
                    margin: const EdgeInsets.all(5),
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      color: selectPage == index
                          ? Tcolor.primary
                          : Tcolor.secondaryText,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25),
                child: RoundButton(
                    onPressed: () {
                      if (selectPage >= 2) {
                        // go to Home screen
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const MainTabview()));
                      } else {
                        setState(() {
                          selectPage = selectPage + 1;
                          controller.animateToPage(selectPage,
                              duration: const Duration(milliseconds: 500),
                              curve: Curves.easeIn);
                        });
                      }
                    },
                    text: 'Next'),
              ),
              SizedBox(
                height: media.width * 0.2,
              ),
            ],
          )
        ],
      ),
    );
  }
}
