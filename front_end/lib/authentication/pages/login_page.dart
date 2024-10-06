import 'package:budgetwise_one/features/home/pages/home_page.dart';
import 'package:flutter/material.dart';
import '../bloc/login/login_bloc.dart';
import '../../features/profile/repositories/user_repository_impl.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/login/login_event.dart';
import '../bloc/login/login_state.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Login Page',
      home: BlocProvider(
        create: (context) => LoginBloc(UserService()),
        child: _LoginPage(),
      ),
    );
  }
}

class _LoginPage extends StatefulWidget {
  @override
  State<_LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<_LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailOrPhoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Error',
            style: TextStyle(color: Colors.white)), // White title
        content: Text(message,
            style: const TextStyle(color: Colors.white)), // White content
        backgroundColor: const Color(0xFF1F1F1F), // Dark background for dialog
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK',
                style: TextStyle(color: Colors.white)), // White button text
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212), // Dark background
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: BlocConsumer<LoginBloc, LoginState>(
            listener: (context, state) {
              if (state is LoginError) {
                _showErrorDialog(state.message);
              }
              if (state is LoginNavigateToHomeScreenActionState) {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const HomePage()));
              }
            },
            builder: (context, state) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  RichText(
                    text: const TextSpan(
                      style:
                          TextStyle(color: Colors.white), // Default text color
                      children: [
                        TextSpan(
                          text: "Hey,\n",
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextSpan(
                          text: "Welcome Back",
                          style: TextStyle(
                            color: Color(0xFFA4C87C), // Light green color
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  _buildTextField('Email or Phone',
                      controller: _emailOrPhoneController, onSubmitted: _login),
                  _buildTextField('Password',
                      controller: _passwordController,
                      obscureText: true,
                      onSubmitted: _login),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {
                        _showForgotPasswordModal(context);
                      },
                      child: const Text(
                        'Forgot Password?',
                        style: TextStyle(
                            fontSize: 10,
                            color: Colors.white54), // Changed to white54
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _login,
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          const Color(0xFFA4C87C), // Light green button
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
              );
            },
          ),
        ),
      ),
    );
  }

  void _login() {
    if (_formKey.currentState!.validate()) {
      BlocProvider.of<LoginBloc>(context).add(
        LoginSubmitted(
          _emailOrPhoneController.text,
          _passwordController.text,
        ),
      );
    }
  }

  Widget _buildTextField(String labelText,
      {bool obscureText = false,
      TextEditingController? controller,
      double fontSize = 14.0,
      void Function()? onSubmitted}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        style: const TextStyle(color: Colors.white), // Set text color to white
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter $labelText';
          }
          return null;
        },
        onFieldSubmitted: (_) => onSubmitted?.call(),
        decoration: InputDecoration(
          labelText: labelText,
          labelStyle: const TextStyle(color: Colors.white), // Changed to white
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.white), // White border
          ),
          filled: true,
          fillColor: const Color(0xFF1F1F1F), // Darker fill color
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
          decoration: const BoxDecoration(
            color: Color(0xFF1F1F1F), // Dark modal background
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
                  style: TextStyle(color: Colors.white), // White title
                ),
                iconTheme:
                    const IconThemeData(color: Colors.white), // White back icon
                toolbarHeight: 56,
              ),
              const SizedBox(height: 24),
              _buildTextField('Email',
                  controller: emailController,
                  fontSize: 14.0,
                  onSubmitted: () => _sendForgotPassword(emailController.text)),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () => _sendForgotPassword(emailController.text),
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      const Color(0xFFA4C87C), // Light green button
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

  void _sendForgotPassword(String email) async {
    if (email.isEmpty) {
      _showErrorDialog('Email cannot be empty.');
      return;
    }

    try {
      // Call your forgot password service here
      _showVerifyEmailModal(context, email);
    } catch (e) {
      _showErrorDialog(e.toString());
    }
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
          decoration: const BoxDecoration(
            color: Color(0xFF1F1F1F), // Dark modal background
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
                  style: TextStyle(color: Colors.white), // White title
                ),
                iconTheme:
                    const IconThemeData(color: Colors.white), // White back icon
                toolbarHeight: 56,
              ),
              const SizedBox(height: 24),
              _buildTextField('Enter code',
                  controller: codeController,
                  fontSize: 14.0,
                  onSubmitted: () =>
                      _verifyCode(context, email, codeController.text)),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () =>
                    _verifyCode(context, email, codeController.text),
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      const Color(0xFFA4C87C), // Light green button
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

  void _verifyCode(BuildContext context, String email, String code) {
    // Implement your code verification logic here
    if (code.isEmpty) {
      _showErrorDialog('Code cannot be empty.');
      return;
    }

    // Proceed with verification
    // If successful, show success dialog or navigate to another page
    Navigator.pop(context); // Close the modal
    _showErrorDialog('Verification code sent to $email'); // Just an example
  }
}
