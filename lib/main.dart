import 'package:flutter/material.dart';
import 'package:food_delivery_app/controllers/provider/authProvider/authProvider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:food_delivery_app/routes/routes.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Add this line
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<MobileAuthprovider>(
            create: (_) => MobileAuthprovider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        routes: AppRoutes.routes,
        initialRoute: RouteNames.startup,
        theme: ThemeData(
          fontFamily: 'Metropolis',
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          //useMaterial3: true,
        ),
      ),
    );
  }
}
