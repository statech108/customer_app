import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:demo_app/data/color.dart';
import 'package:demo_app/screen/main_pages/home_screen.dart';


class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  String _verificationId = '';
  bool _isOTPSent = false;
  bool _isLoading = false;

  Future<void> _saveUserData(String name, String phone) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_name', name);
    await prefs.setString('user_phone', phone);
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: primary_colour),
    );
  }

  // 🔹 Step 1: Send OTP
  Future<void> _sendOTP() async {
    String userPhone = _phoneController.text.trim();

    if (userPhone.isEmpty || userPhone.length != 10) {
      _showSnackBar('Please enter a valid phone number');
      return;
    }

    setState(() => _isLoading = true);

    await _auth.verifyPhoneNumber(
      phoneNumber: '+91$userPhone',
      timeout: const Duration(seconds: 60),
      verificationCompleted: (PhoneAuthCredential credential) async {
        await _auth.signInWithCredential(credential);
        _onLoginSuccess();
      },
      verificationFailed: (FirebaseAuthException e) {
        _showSnackBar('Verification failed: ${e.message}');
        setState(() => _isLoading = false);
      },
      codeSent: (String verificationId, int? resendToken) {
        setState(() {
          _verificationId = verificationId;
          _isOTPSent = true;
          _isLoading = false;
        });
        _showSnackBar('OTP sent successfully');
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        _verificationId = verificationId;
      },
    );
  }

  // 🔹 Step 2: Verify OTP
  Future<void> _verifyOTP() async {
    String otp = _otpController.text.trim();

    if (otp.length != 6) {
      _showSnackBar('Please enter a valid 6-digit OTP');
      return;
    }

    setState(() => _isLoading = true);

    try {
      PhoneAuthCredential credential =
      PhoneAuthProvider.credential(verificationId: _verificationId, smsCode: otp);
      await _auth.signInWithCredential(credential);
      _onLoginSuccess();
    } catch (e) {
      _showSnackBar('Invalid OTP, please try again');
      setState(() => _isLoading = false);
    }
  }

  // 🔹 After successful login
  Future<void> _onLoginSuccess() async {
    await _saveUserData(
      _nameController.text.trim(),
      _phoneController.text.trim(),
    );
    _showSnackBar('Login successful!');
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => HomePage()),
    );
  }

  // 🔹 Skip login
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
                child: Text('Skip login', style: TextStyle(color: primary_colour_54, fontSize: 14)),
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 40),
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: primary_colour,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Icon(Icons.person, size: 50, color: secondary_colour),
            ),
            const SizedBox(height: 24),
            Text(
              _isOTPSent ? 'Verify OTP' : 'Welcome',
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: primary_colour),
            ),
            const SizedBox(height: 8),
            Text(
              _isOTPSent
                  ? 'Enter the 6-digit code sent to ${_phoneController.text}'
                  : 'Login or Sign Up with Phone Number',
              style: TextStyle(fontSize: 16, color: primary_colour_54),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),

            if (!_isOTPSent) ...[
              // Name Input
              _buildTextField(
                controller: _nameController,
                label: 'Name',
                hint: 'Enter your full name',
              ),
              const SizedBox(height: 20),

              // Phone Input
              _buildTextField(
                controller: _phoneController,
                label: 'Phone Number',
                hint: 'Enter mobile number',
                prefix: '+91 ',
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 32),

              // Continue Button
              _buildButton(
                title: 'Continue',
                onPressed: _sendOTP,
              ),
            ] else ...[
              // OTP Input
              TextField(
                controller: _otpController,
                maxLength: 6,
                keyboardType: TextInputType.number,
                style: TextStyle(color: primary_colour),
                decoration: InputDecoration(
                  labelText: 'OTP',
                  counterText: '',
                  labelStyle: TextStyle(color: primary_colour_54),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: primary_colour),
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 32),
              _buildButton(
                title: 'Verify OTP',
                onPressed: _verifyOTP,
              ),
            ],

            const SizedBox(height: 24),

            if (!_isOTPSent)
              Text(
                'By continuing, you agree to our Terms of Service & Privacy Policy',
                style: TextStyle(fontSize: 12, color: primary_colour_54),
                textAlign: TextAlign.center,
              ),

            if (_isLoading) const SizedBox(height: 20),
            if (_isLoading) const CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    String prefix = '',
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      style: TextStyle(color: primary_colour),
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        hintStyle: TextStyle(color: primary_colour_38),
        labelStyle: TextStyle(color: primary_colour_54),
        prefixText: prefix,
        prefixStyle: TextStyle(color: primary_colour, fontWeight: FontWeight.w500),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: primary_colour),
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  Widget _buildButton({required String title, required VoidCallback onPressed}) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: _isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: primary_colour,
          foregroundColor: secondary_colour,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          elevation: 0,
        ),
        child: Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _otpController.dispose();
    super.dispose();
  }
}
