import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  _EditProfilePage createState() => _EditProfilePage();
}

class _EditProfilePage extends State<EditProfilePage> {
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
              // Edit Profile Title
              RichText(
                text: const TextSpan(
                  children: [
                    TextSpan(
                      text: "Edit ",
                      style: TextStyle(
                        color: Color(0xFF8BBE6D),
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextSpan(
                      text: "Profile",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              const _TextField(labelText: 'First Name', borderRadius: 10),
              const SizedBox(height: 16),
              const _TextField(labelText: 'Middle Name', borderRadius: 10),
              const SizedBox(height: 16),
              const _TextField(labelText: 'Last Name', borderRadius: 10),
              const SizedBox(height: 16),

              // Contact No TextField
              TextField(
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(10),
                ],
                decoration: InputDecoration(
                  labelText: 'Contact No.',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                obscureText: !_isPasswordVisible,
                decoration: InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
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
              const SizedBox(height: 16),

              // Confirm Button// Button height
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
              const SizedBox(height: 10),

              // ElevatedButton(
              //   onPressed: () {
              //     // Add cancel logic here
              //   },
              //   style: ElevatedButton.styleFrom(
              //     backgroundColor: Colors.red,
              //     minimumSize: const Size.fromHeight(50),
              //     shape: RoundedRectangleBorder(
              //       borderRadius: BorderRadius.circular(12),
              //     ),
              //   ),
              //   child: const Text(
              //     'Cancel',
              //     style: TextStyle(
              //       fontSize: 18,
              //       color: Colors.black,
              //     ),
              //   ),
              // ),
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
    Key? key,
    required this.labelText,
    this.borderRadius = 5.0, // default value for borderRadius
  }) : super(key: key);

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
