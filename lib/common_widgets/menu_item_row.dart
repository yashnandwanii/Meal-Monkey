import 'package:flutter/material.dart';

import '../common/color_extension.dart';

class MenuItemRow extends StatelessWidget {
  final Map mObj;
  final VoidCallback onTap;
  const MenuItemRow({super.key, required this.mObj, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: InkWell(
        onTap: onTap,
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.asset(
                mObj["image"].toString(),
                width: double.maxFinite,
                height: 220,
                fit: BoxFit.cover,
              ),
            ),
            Container(
              width: double.maxFinite,
              height: 200,
              decoration: const BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      offset: Offset(0, 2),
                      blurRadius: 2.0,
                    )
                  ],
                  gradient: LinearGradient(colors: [
                    Colors.transparent,
                    Colors.transparent,
                    Colors.black,
                  ], begin: Alignment.topCenter, end: Alignment.bottomCenter)),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 8,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        mObj["name"],
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Tcolor.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(
                        height: 4,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Image.asset(
                            "assets/iimg/rate.png",
                            width: 10,
                            height: 10,
                            fit: BoxFit.cover,
                          ),
                          const SizedBox(
                            width: 4,
                          ),
                          Text(
                            mObj["rate"],
                            textAlign: TextAlign.center,
                            style:
                                TextStyle(color: Tcolor.primary, fontSize: 11),
                          ),
                          const SizedBox(
                            width: 8,
                          ),
                          Text(
                            mObj["type"],
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Tcolor.white, fontSize: 11),
                          ),
                          Text(
                            " . ",
                            textAlign: TextAlign.center,
                            style:
                                TextStyle(color: Tcolor.primary, fontSize: 11),
                          ),
                          Text(
                            mObj["food_type"],
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Tcolor.white,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 18,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
