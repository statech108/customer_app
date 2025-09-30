import 'package:demo_app/data/color.dart';
import 'package:demo_app/screen/starting_pages/greeting_screen.dart';
import 'package:flutter/material.dart';

class LanguageScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background_colour,
      body: Column(
        children: [
          // Top 50% with background colour + logo
          Expanded(
            flex: 1,
            child: Container(
              color: primary_colour,
              child: Center(
                child: Image.asset(
                  'asset/image/logo_bg_black.jpg',
                  width: 200,
                  height: 200,
                ),
              ),
            ),
          ),

          // Bottom 50% with language selection
          Expanded(
            flex: 1,
            child: Container(
              color: background_colour,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Preferred Language",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 25),
                  LanguageButton(language: "English", greeting: "Hello"),
                  LanguageButton(language: "Hindi", greeting: "नमस्ते"),
                  LanguageButton(language: "Punjabi", greeting: "ਸਤ ਸ੍ਰੀ ਅਕਾਲ"),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class LanguageButton extends StatelessWidget {
  final String language;
  final String greeting;
  const LanguageButton({required this.language, required this.greeting});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Container(
        decoration: BoxDecoration(
          color: primary_colour,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 8,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            minimumSize: Size(220, 50),
          ),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => GreetingScreen(greeting: greeting),
              ),
            );
          },
          child: Text(
            language,
            style: TextStyle(fontSize: 16, color: secondary_text_colour),
          ),
        ),
      ),
    );
  }
}
