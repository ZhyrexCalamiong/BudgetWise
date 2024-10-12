import 'package:budgetwise_one/repositories/user_repository_impl.dart';
import 'package:flutter/material.dart';
import 'login_page.dart';
import '../bloc/authentication/registration/registration_bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/authentication/registration/registration_event.dart';
import '../bloc/authentication/registration/registration_state.dart';
import '../models/user.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _middleNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _contactNoController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final TextEditingController _dateOfBirthController = TextEditingController();

  @override
  void dispose() {
    _firstNameController.dispose();
    _middleNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _contactNoController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _dateOfBirthController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Signup Page',
      theme: ThemeData.dark(),
      home: BlocProvider(
        create: (context) => RegistrationBloc(UserService()),
        child: _SignupPageContent(),
      ),
    );
  }
}

class _SignupPageContent extends StatefulWidget {
  @override
  State<_SignupPageContent> createState() => _SignupPageContentState();
}

class _SignupPageContentState extends State<_SignupPageContent> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _middleNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _contactNoController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final TextEditingController _dateOfBirthController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0D0D),
      body: BlocListener<RegistrationBloc, RegistrationState>(
        listener: (context, state) {
          if (state is RegistrationNavigateToLoginScreenActionState) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => LoginPage()),
            );
          } else if (state is RegistrationError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Failed to create account: ${state.message}'),
              ),
            );
          }
        },
        child: ListView(
          padding: const EdgeInsets.all(24.0),
          children: [
            const SizedBox(height: 60),
            RichText(
              text: const TextSpan(
                children: [
                  TextSpan(
                    text: "Let’s\n",
                    style: TextStyle(
                      color: Color(0xFF8BBE6D),
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextSpan(
                    text: "get started",
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
            Form(
              key: _formKey,
              child: Column(
                children: [
                  _buildTextField('First Name', _firstNameController),
                  _buildTextField('Middle Name', _middleNameController),
                  _buildTextField('Last Name', _lastNameController),
                  _buildTextField('Email', _emailController),
                  _buildTextField('Contact No.', _contactNoController),
                  _buildDatePicker(),
                  _buildTextField('Password', _passwordController, obscureText: true),
                  _buildTextField('Confirm Password', _confirmPasswordController, obscureText: true),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        if (_passwordController.text != _confirmPasswordController.text) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Passwords do not match')),
                          );
                          return;
                        }

                        final user = User(
                          firstName: _firstNameController.text,
                          middleName: _middleNameController.text,
                          lastName: _lastNameController.text,
                          email: _emailController.text,
                          phone: _contactNoController.text,
                          dateOfBirth: _dateOfBirthController.text,
                          password: _passwordController.text,
                        );
                        BlocProvider.of<RegistrationBloc>(context).add(UserRegistrationRequested(user));
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF8BBE6D),
                      minimumSize: const Size.fromHeight(50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Sign Up',
                      style: TextStyle(fontSize: 16, color: Colors.black),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Center(
                    child: TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => LoginPage()),
                        );
                      },
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'I already have an account',
                            style: TextStyle(fontSize: 12, color: Colors.white70),
                          ),
                          SizedBox(width: 4),
                          Icon(Icons.arrow_right_alt, color: Colors.white70),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String labelText, TextEditingController controller, {bool obscureText = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        style: const TextStyle(
          fontSize: 14,
          color: Colors.white,
        ),
        decoration: InputDecoration(
          labelText: labelText,
          labelStyle: const TextStyle(
            fontSize: 14,
            color: Colors.white70,
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.white24),
            borderRadius: BorderRadius.circular(12),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.white70),
            borderRadius: BorderRadius.circular(12),
          ),
          filled: true,
          fillColor: const Color(0xFF1A1A1A),
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
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextFormField(
        controller: _dateOfBirthController,
        readOnly: true,
        style: const TextStyle(
          fontSize: 14,
          color: Colors.white,
        ),
        decoration: InputDecoration(
          labelText: 'Date of Birth',
          labelStyle: const TextStyle(
            fontSize: 14,
            color: Colors.white70,
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.white24),
            borderRadius: BorderRadius.circular(12),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.white70),
            borderRadius: BorderRadius.circular(12),
          ),
          filled: true,
          fillColor: const Color(0xFF1A1A1A),
        ),
        onTap: () async {
          final DateTime? picked = await showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(2000),
            lastDate: DateTime.now(),
          );
          if (picked != null) {
            _dateOfBirthController.text = "${picked.toLocal()}".split(' ')[0];
          }
        },
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter your date of birth';
          }
          return null;
        },
      ),
    );
  }
}
