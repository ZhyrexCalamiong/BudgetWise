import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F2),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            RichText(
              text: const TextSpan(
                children: [
                  TextSpan(
                    text: "Hey,\n",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextSpan(
                    text: "Welcome Back",
                    style: TextStyle(
                      color: Color(0xFFD95D37),
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            _buildTextField('Email', fontSize: 10.0),
            _buildTextField('Password', obscureText: true, fontSize: 10.0),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {
                  _showForgotPasswordModal(context);
                },
                child: const Text(
                  'Forgot Password?',
                  style: TextStyle(fontSize: 10, color: Colors.black54),
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Navigate to home screen when login is pressed
                Navigator.pushReplacementNamed(context, '/home');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF75ECE1), // Background color
                minimumSize: const Size.fromHeight(50), // Button height
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Login',
                style: TextStyle(fontSize: 12, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String labelText, {bool obscureText = false, double fontSize = 10.0}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextField(
        obscureText: obscureText,
        style: TextStyle(fontSize: fontSize), // Apply the font size here
        decoration: InputDecoration(
          labelText: labelText,
          labelStyle: TextStyle(fontSize: fontSize), // Apply font size to label
          hintStyle: TextStyle(fontSize: fontSize),  // Apply font size to hint
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: const Color(0xFFFFFFFF),
        ),
      ),
    );
  }

  void _showForgotPasswordModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(24.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              AppBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                centerTitle: true,
                title: Text(
                  'Forgot Password',
                  style: TextStyle(color: Colors.black),
                ),
                toolbarHeight: 56, // Adjust height if needed
              ),
              const SizedBox(height: 24),
              _buildTextField('Email', fontSize: 10.0),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close the forgot password modal
                  _showVerifyEmailModal(context); // Show the verify email modal
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF75ECE1), // Uniform button color
                  minimumSize: const Size.fromHeight(50), // Button height
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Send',
                  style: TextStyle(fontSize: 12, color: Colors.white),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showVerifyEmailModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(24.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              AppBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                centerTitle: true,
                title: Text(
                  'Verify Your Email',
                  style: TextStyle(color: Colors.black),
                ),
                toolbarHeight: 56, // Adjust height if needed
              ),
              const SizedBox(height: 24),
              _buildTextField('Enter 4-digit code', fontSize: 10.0),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close the verify email modal
                  _showResetPasswordModal(context); // Show the reset password modal
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF75ECE1), // Uniform button color
                  minimumSize: const Size.fromHeight(50), // Button height
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Verify',
                  style: TextStyle(fontSize: 12, color: Colors.white),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showResetPasswordModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(24.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              AppBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                centerTitle: true,
                title: Text(
                  'Reset Password',
                  style: TextStyle(color: Colors.black),
                ),
                toolbarHeight: 56, // Adjust height if needed
              ),
              const SizedBox(height: 24),
              _buildTextField('Enter New Password', obscureText: true, fontSize: 10.0),
              const SizedBox(height: 16),
              _buildTextField('Re-enter New Password', obscureText: true, fontSize: 10.0),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacementNamed(context, '/login'); // Navigate to login page
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF75ECE1), // Uniform button color
                  minimumSize: const Size.fromHeight(50), // Button height
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Proceed',
                  style: TextStyle(fontSize: 12, color: Colors.white),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
