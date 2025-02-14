import 'package:flutter/material.dart';
import 'package:food_delivery_app/view/on_boarding/startup_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Add this line

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        fontFamily: 'Metropolis',

        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        //useMaterial3: true,
      ),
      home: const StartupView(),
    );
  }
}
