import 'package:demo_app/screen/starting_pages/splash_screen.dart';
import 'package:demo_app/screen/main_pages/profile_screen.dart';
import 'package:demo_app/screen/main_pages/cart_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<ProfileData>(
          create: (BuildContext context) => ProfileData(),
        ),
        ChangeNotifierProvider<CartData>(
          create: (BuildContext context) => CartData(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: SplashScreen(),
      ),
    );
  }
}