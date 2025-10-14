import 'package:flutter/material.dart';
import 'package:demo_app/data/color.dart';
import 'package:demo_app/screen/main_pages/home_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  Future<void> _saveUserData(String name, String phone) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_name', name);
    await prefs.setString('user_phone', phone);
  }

  // Handle login/signup
  void _handleLogin() {
    String user_name = _nameController.text.trim();
    String user_phoneNumber = _phoneController.text.trim();

    if (user_name.isEmpty) {
      _showSnackBar('Please enter your name');
      return;
    }

    if (user_phoneNumber.isEmpty) {
      _showSnackBar('Please enter your phone number');
      return;
    }

    if (user_phoneNumber.length != 10) {
      _showSnackBar('Please enter a valid phone number');
      return;
    }

    // Here you would typically integrate with Firebase Auth or your backend
    _showSnackBar('Login/Signup initiated for $user_name ($user_phoneNumber)');

    // Navigate to next screen or show OTP dialog
    _showOTPDialog();
  }

  // Show OTP verification dialog
  void _showOTPDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: background_colour,
          title: Text('Verify OTP', style: TextStyle(color: primary_colour)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Enter the 6-digit code sent to ${_phoneController.text}',
                style: TextStyle(color: primary_colour_54),
              ),
              SizedBox(height: 16),
              TextField(
                keyboardType: TextInputType.number,
                maxLength: 6,
                decoration: InputDecoration(
                  hintText: 'Enter OTP',
                  border: OutlineInputBorder(),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: primary_colour),
                  ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel', style: TextStyle(color: primary_colour_54)),
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.of(context).pop(); // Close OTP dialog
                _showSnackBar('Login successful!');

                //Shared Preferences
                await _saveUserData(
                  _nameController.text.trim(),
                  _phoneController.text.trim(),
                );

                // Navigate to Home Page
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => HomePage()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: primary_colour,
                foregroundColor: secondary_colour,
              ),
              child: const Text('Verify'),
            ),
          ],
        );
      },
    );
  }

  // Show snackbar message
  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: primary_colour),
    );
  }

  // Skip login process
  void _skipLogin() {
    _showSnackBar('Login skipped');
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => HomePage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background_colour,
      appBar: AppBar(
        backgroundColor: background_colour,
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0, bottom: 8.0),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: TextButton(
                onPressed: _skipLogin,
                child: Text(
                  'Skip login',
                  style: TextStyle(color: primary_colour_54, fontSize: 14),
                ),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 40),

            // App Logo/Title
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: primary_colour,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Icon(Icons.person, size: 50, color: secondary_colour),
            ),

            SizedBox(height: 24),

            Text(
              'Welcome',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: primary_colour,
              ),
            ),

            SizedBox(height: 8),

            Text(
              'Login or Sign Up with Phone Number',
              style: TextStyle(fontSize: 16, color: primary_colour_54),
              textAlign: TextAlign.center,
            ),

            SizedBox(height: 40),

            // Name Input
            Container(
              margin: EdgeInsets.only(bottom: 20),
              child: TextField(
                controller: _nameController,
                style: TextStyle(color: primary_colour),
                decoration: InputDecoration(
                  labelText: 'Name',
                  labelStyle: TextStyle(color: primary_colour_54), // default
                  floatingLabelStyle: TextStyle(
                    color: primary_colour,
                  ), // when focused
                  hintText: 'Enter your full name',
                  hintStyle: TextStyle(color: primary_colour_38),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: primary_colour),
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),

            // Phone Number Input
            Container(
              margin: EdgeInsets.only(bottom: 20),
              child: TextField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                style: TextStyle(color: primary_colour),
                decoration: InputDecoration(
                  labelText: 'Phone Number',
                  labelStyle: TextStyle(color: primary_colour_54), // default
                  floatingLabelStyle: TextStyle(
                    color: primary_colour,
                  ), // when focused
                  hintText: 'Enter mobile number',
                  hintStyle: TextStyle(color: primary_colour_38),
                  prefixIcon: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                    child: Text(
                      '+91',
                      style: TextStyle(
                        fontSize: 16,
                        color: primary_colour,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  prefixIconConstraints: BoxConstraints(
                    minWidth: 0,
                    minHeight: 0,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: primary_colour),
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),

            SizedBox(height: 32),

            // Continue Button
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: _handleLogin,
                style: ElevatedButton.styleFrom(
                  backgroundColor: primary_colour,
                  foregroundColor: secondary_colour,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  'Continue',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),
            ),

            SizedBox(height: 24),

            // Terms and Privacy
            Text(
              'By continuing, you agree to our Terms of service & Privacy policy',
              style: TextStyle(fontSize: 12, color: primary_colour_54),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }
}
