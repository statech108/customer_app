import 'package:demo_app/data/theme/app_color.dart';
import 'package:demo_app/screen/starting_pages/greeting_screen.dart';
import 'package:flutter/material.dart';

class Languagescreen extends StatelessWidget {
  const Languagescreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColour,
      body: Column(
        children: [
          // 66% Screen with Logo
          Expanded(
            flex: 2,
            child: Container(
              color: AppColors.backgroundColourWithLogo,
              child: Center(
                child: Image.asset(
                  'assets/images/logo_bg_black.jpg',
                  width: 400,
                  height: 400,
                ),
              ),
            ),
          ),

          // 34% Screen with Language Options
          Expanded(
            flex: 1,
            child: Container(
              color: AppColors.backgroundColour,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Preferred Language",
                    style: TextStyle(
                      fontSize: 35,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textDark,
                    ),
                  ),
                  SizedBox(height: 25),
                  LanguageButton(language: "हिंदी", greeting: "नमस्ते"),
                  LanguageButton(language: "English", greeting: "Hello"),
                  LanguageButton(language: "ਪੰਜਾਬੀ", greeting: "ਸਤ ਸ੍ਰੀ ਅਕਾਲ"),
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
  const LanguageButton({
    required this.language,
    required this.greeting,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.primary.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(50),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.15),
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
            minimumSize: Size(200, 50),
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
            style: TextStyle(fontSize: 18, color: AppColors.textLight),
          ),
        ),
      ),
    );
  }
}
