import 'dart:async';
import 'package:demo_app/data/color.dart';
import 'package:demo_app/screen/starting_pages/login_screen.dart';
import 'package:flutter/material.dart';

class GreetingScreen extends StatelessWidget {
  final String greeting;
  const GreetingScreen({super.key, required this.greeting});

  @override
  Widget build(BuildContext context) {
    // Navigate after 1 seconds
    Future.delayed(const Duration(seconds: 1), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );
    });

    return Scaffold(
      backgroundColor: background_colour,
      body: Center(
        child: Text(
          greeting,
          style: const TextStyle(
            fontSize: 36,
            fontWeight: FontWeight.bold,
            color: primary_text_colour,
          ),
        ),
      ),
    );
  }
}
