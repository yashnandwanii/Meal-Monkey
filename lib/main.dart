import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:food_delivery_app/routes/routes.dart';
import 'package:get/get.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return GetMaterialApp(
          debugShowCheckedModeBanner: false,
          routes: AppRoutes.routes,
          initialRoute: RouteNames.startup,
          theme: ThemeData(
            fontFamily: 'Metropolis',
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          ),
        );
      },
    );
  }
}
