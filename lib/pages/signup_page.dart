import 'package:flutter/material.dart';
import 'login_page.dart';

class SignupPage extends StatelessWidget {
  const SignupPage({super.key, required this.title});

  final String title;

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
                    text: "Let’s\n",
                    style: TextStyle(
                      color: Colors.orange,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextSpan(
                    text: "get started",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            _buildTextField('First Name'),
            _buildTextField('Middle Name'),
            _buildTextField('Last Name'),
            _buildTextField('Email'),
            _buildTextField('Contact No.'),
            _buildTextField('Password', obscureText: true),
            _buildTextField('Confirm Password', obscureText: true),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Navigate to login page when signup button is pressed
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginPage()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF75ECE1),
                minimumSize: const Size.fromHeight(50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Sign Up',
                style: TextStyle(fontSize: 12, color: Colors.white),
              ),
            ),
            const SizedBox(height: 12),
            Center(
              child: TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginPage()),
                  );
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Text(
                      'I already have an account',
                      style: TextStyle(fontSize: 10, color: Colors.black),
                    ),
                    SizedBox(width: 4),
                    Icon(Icons.arrow_right_alt, color: Colors.black),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String labelText, {bool obscureText = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextField(
        obscureText: obscureText,
        style: const TextStyle(
          fontSize: 10, // Change the font size
          fontWeight: FontWeight.w500, // Change the font weight
          color: Colors.black, // Change the text color
          fontFamily: 'Roboto', // Set your desired font family
        ),
        decoration: InputDecoration(
          labelText: labelText,
          labelStyle: const TextStyle(
            fontSize: 10, // Change the label font size
            fontWeight: FontWeight.normal, // Change the label font weight
            color: Colors.grey, // Change the label color
            fontFamily: 'Roboto', // Set the same font family for consistency
          ),
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
}
