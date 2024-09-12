import 'package:flutter/material.dart';
import 'login_page.dart';
import '/services/user_service.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key, required this.title});

  final String title;

  @override
  SignupPageState createState() => SignupPageState();
}

class SignupPageState extends State<SignupPage> {
  final UserService _api = UserService();
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _middleNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _contactNoController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _dateOfBirthController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F2),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
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
              _buildTextField('First Name', _firstNameController),
              _buildTextField('Middle Name', _middleNameController),
              _buildTextField('Last Name', _lastNameController),
              _buildTextField('Email', _emailController),
              _buildTextField('Contact No.', _contactNoController),
              _buildDatePicker(),
              _buildTextField('Password', _passwordController,
                  obscureText: true),
              _buildTextField('Confirm Password', _confirmPasswordController,
                  obscureText: true),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    final Map<String, dynamic> data = {
                      'firstName': _firstNameController.text,
                      'middleName': _middleNameController.text,
                      'lastName': _lastNameController.text,
                      'email': _emailController.text,
                      'dateOfBirth': _dateOfBirthController.text,  
                      'phone': _contactNoController.text,
                      'password': _passwordController.text,
                    };

                    print(data);

                    try {
                      await _api.signup(data);
                      // Navigate to login page upon successful signup
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => const LoginPage()),
                      );
                    } catch (e) {
                      // Handle error (show message to the user)
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Failed to create account: $e')),
                      );
                    }
                  }
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
                      MaterialPageRoute(
                          builder: (context) => const LoginPage()),
                    );
                  },
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
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
      ),
    );
  }

  Widget _buildTextField(String labelText, TextEditingController controller,
      {bool obscureText = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        style: const TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w500,
          color: Colors.black,
          fontFamily: 'Roboto',
        ),
        decoration: InputDecoration(
          labelText: labelText,
          labelStyle: const TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.normal,
            color: Colors.grey,
            fontFamily: 'Roboto',
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: const Color(0xFFFFFFFF),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter $labelText';
          }
          return null;
        },
      ),
    );
  }

  Widget _buildDatePicker() {
    return TextFormField(
      controller: _dateOfBirthController,
      readOnly: true,
      decoration: const InputDecoration(
        labelText: 'Date of Birth',
        filled: true,
        fillColor: Color(0xFFFFFFFF),
      ),
      onTap: () async {
        DateTime? pickedDate = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(1900),
          lastDate: DateTime.now(),
        );
        if (pickedDate != null) {
          _dateOfBirthController.text =
              pickedDate.toLocal().toString().split(' ')[0]; // format date
        }
      },
    );
  }
}
