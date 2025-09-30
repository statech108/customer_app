import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ComingSoonApp extends StatefulWidget {
  const ComingSoonApp({super.key});

  @override
  State<ComingSoonApp> createState() => _ComingSoonAppState();
}

class _ComingSoonAppState extends State<ComingSoonApp> {
  String userName = "Guest";
  String userPhone = "N/A";

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userName = prefs.getString('user_name') ?? "Guest";
      userPhone = prefs.getString('user_phone') ?? "N/A";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Text(
          "Welcome $userName\nPhone: $userPhone",
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
