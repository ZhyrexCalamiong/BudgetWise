import 'package:flutter/material.dart';

class ChangeEmailPage extends StatefulWidget {
  const ChangeEmailPage({super.key});

  @override
  _ChangeEmailPageState createState() => _ChangeEmailPageState();
}

class _ChangeEmailPageState extends State<ChangeEmailPage> {
  // Variables to manage password visibility
  bool _isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            children: [
              // Change Password Title
              RichText(
                text: const TextSpan(
                  children: [
                    TextSpan(
                      text: 'Change',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF8BBE6D), // Color for "Change"
                      ),
                    ),
                    TextSpan(
                      text: ' Email',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white, // Color for "Password"
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              const _TextField(labelText: 'Email', borderRadius: 10),
              const SizedBox(height: 16),

              // OTP TextField and Send Code Button
              Row(
                children: [
                  // OTP TextField
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        labelText: 'Input OTP Code',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  // Send Code Button
                  SizedBox(
                    height: 45,
                    width: 80,
                    child: ElevatedButton(
                      onPressed: () {
                        // Add send code logic here
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF8BBE6D),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        'Send Code',
                        style: TextStyle(fontSize: 12, color: Colors.black),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              const _TextField(labelText: 'New Email', borderRadius: 10),
              const SizedBox(height: 16),

              // Confirm Password TextField with visibility toggle
              TextField(
                obscureText: !_isPasswordVisible,
                decoration: InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isPasswordVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        _isPasswordVisible = !_isPasswordVisible;
                      });
                    },
                  ),
                ),
              ),
              const SizedBox(height: 30),

              ElevatedButton(
                onPressed: () {
                  // Add confirm logic here
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF8BBE6D),
                  minimumSize: const Size.fromHeight(50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Confirm',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TextField extends StatelessWidget {
  final String labelText;
  final double borderRadius;

  const _TextField({
    super.key,
    required this.labelText,
    this.borderRadius = 5.0, // default value for borderRadius
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        labelText: labelText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
    );
  }
}