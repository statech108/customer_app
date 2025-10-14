import 'package:demo_app/screen/starting_pages/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:demo_app/screen/main_pages/cart_screen.dart';

void main() {
  runApp(
    ChangeNotifierProvider<CartData>(
      create: (_) => CartData(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen()
    );
  }
}