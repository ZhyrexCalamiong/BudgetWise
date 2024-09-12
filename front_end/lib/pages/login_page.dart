import 'package:flutter/material.dart';
import '/services/user_service.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  final UserService _userService = UserService();
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailOrPhoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isLoading = false;

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  Future<void> _login() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      final emailOrPhone = _emailOrPhoneController.text;
      final password = _passwordController.text;

      try {
        await _userService.signin(emailOrPhone, password);
        Navigator.pushReplacementNamed(context, '/home');
      } catch (e) {
        _showErrorDialog(e.toString());
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

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
              _buildTextField('Email', controller: _emailOrPhoneController),
              _buildTextField('Password', controller: _passwordController, obscureText: true),
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
              _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                      onPressed: _login,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF75ECE1),
                        minimumSize: const Size.fromHeight(50),
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
      ),
    );
  }

  Widget _buildTextField(String labelText,
      {bool obscureText = false,
      TextEditingController? controller,
      double fontSize = 14.0}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter $labelText';
          }
          return null;
        },
        decoration: InputDecoration(
          labelText: labelText,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          filled: true,
          fillColor: const Color(0xFFFFFFFF),
        ),
      ),
    );
  }

   void _showForgotPasswordModal(BuildContext context) {
    final TextEditingController emailController = TextEditingController();

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
                title: const Text(
                  'Forgot Password',
                  style: TextStyle(color: Colors.black),
                ),
                toolbarHeight: 56,
              ),
              const SizedBox(height: 24),
              _buildTextField('Email', controller: emailController, fontSize: 14.0),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () async {
                  final email = emailController.text;

                  if (email.isEmpty) {
                    _showErrorDialog('Email cannot be empty.');
                    return;
                  }

                  try {
                    await _userService.forgotPassword(email);
                    _showVerifyEmailModal(context, email);
                  } catch (e) {
                    _showErrorDialog(e.toString());
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

  void _showVerifyEmailModal(BuildContext context, String email) {
    final TextEditingController codeController = TextEditingController();

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
                title: const Text(
                  'Verify Your Email',
                  style: TextStyle(color: Colors.black),
                ),
                toolbarHeight: 56,
              ),
              const SizedBox(height: 24),
              _buildTextField('Enter 4-digit code', controller: codeController, fontSize: 14.0),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () async {
                  final code = codeController.text;

                  if (code.isEmpty) {
                    _showErrorDialog('Code cannot be empty.');
                    return;
                  }

                  _showResetPasswordModal(context, email, code);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF75ECE1),
                  minimumSize: const Size.fromHeight(50),
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

  void _showResetPasswordModal(BuildContext context, String email, String code) {
    final TextEditingController newPasswordController = TextEditingController();
    final TextEditingController confirmPasswordController = TextEditingController();

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
                title: const Text(
                  'Reset Password',
                  style: TextStyle(color: Colors.black),
                ),
                toolbarHeight: 56,
              ),
              const SizedBox(height: 24),
              _buildTextField('Enter New Password', controller: newPasswordController, obscureText: true, fontSize: 14.0),
              const SizedBox(height: 16),
              _buildTextField('Re-enter New Password', controller: confirmPasswordController, obscureText: true, fontSize: 14.0),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () async {
                  final newPassword = newPasswordController.text;
                  final confirmPassword = confirmPasswordController.text;

                  if (newPassword.isEmpty || confirmPassword.isEmpty) {
                    _showErrorDialog('Please fill out both password fields.');
                    return;
                  }

                  if (newPassword != confirmPassword) {
                    _showErrorDialog('Passwords do not match.');
                    return;
                  }

                  try {
                    await _userService.resetPassword(email, code, newPassword);
                    Navigator.pushReplacementNamed(context, '/login');
                  } catch (e) {
                    _showErrorDialog(e.toString());
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