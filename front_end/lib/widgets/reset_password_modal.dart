import 'package:budgetwise_one/repositories/user_repository_impl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/authentication/forgot_password/reset_password_bloc.dart';
import '../bloc/authentication/forgot_password/reset_password_event.dart';
import '../bloc/authentication/forgot_password/reset_password_state.dart';

class ResetPasswordModal extends StatelessWidget {
  final String email;
  ResetPasswordModal({super.key, required this.email});

  final TextEditingController codeController = TextEditingController();
  final TextEditingController newPassController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ResetPasswordBloc(UserService()),
      child: BlocConsumer<ResetPasswordBloc, ResetPasswordState>(
        listener: (context, state) {
          if (state is ResetPasswordSuccess) {
            Navigator.pop(context); // Close modal
            _showSuccessDialog(context,
                "Password has been reset successfully. Please log in.");
          } else if (state is ResetPasswordFailure) {
            _showErrorDialog(context, state.error);
          }
        },
        builder: (context, state) {
          return _buildResetPasswordUI(context);
        },
      ),
    );
  }

  Widget _buildResetPasswordUI(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: SizedBox(
        height: MediaQuery.of(context).size.height *
            0.5, // Set height to half of the screen
        child: Container(
          padding: const EdgeInsets.all(24.0),
          decoration: const BoxDecoration(
            color: Color(0xFF0D0D0D),
            borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              AppBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
                centerTitle: true,
                title: const Text('Reset Password',
                    style: TextStyle(color: Color(0xFF8BBE6D))),
                toolbarHeight: 56,
              ),
              const SizedBox(height: 24),
              _buildTextField('Code',
                  controller: codeController,
                  obscureText: true,
                  fontSize: 14.0),
              const SizedBox(height: 16),
              _buildTextField('New Password',
                  controller: newPassController,
                  obscureText: true,
                  fontSize: 14.0),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    BlocProvider.of<ResetPasswordBloc>(context).add(
                      ChangePasswordRequested(
                        email.toString(),
                        codeController.text.toString(),
                        newPassController.text.toString(),
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF8BBE6D),
                  minimumSize: const Size.fromHeight(50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text('Change Password',
                    style: TextStyle(fontSize: 12, color: Colors.black)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Error'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _showSuccessDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Success'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildTextField(String labelText,
      {TextEditingController? controller,
      bool obscureText = false,
      double fontSize = 14.0}) {
    // Create a state variable for password visibility
    bool _isObscure = obscureText;

    return StatefulBuilder(
      builder: (context, setState) {
        return TextFormField(
          controller: controller,
          obscureText: _isObscure,
          decoration: InputDecoration(
            labelText: labelText,
            labelStyle: TextStyle(color: Colors.white, fontSize: fontSize),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            filled: true,
            fillColor: const Color(0xFF1C1C1C),
            suffixIcon: labelText == 'New Password'
                ? IconButton(
                    icon: Icon(
                      _isObscure ? Icons.visibility : Icons.visibility_off,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      setState(() {
                        _isObscure = !_isObscure; // Toggle password visibility
                      });
                    },
                  )
                : null,
          ),
          style: TextStyle(color: Colors.white),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter a value';
            } else if (labelText == 'New Password' && value.length < 6) {
              return 'Password must be at least 6 characters long';
            }
            return null;
          },
        );
      },
    );
  }
}
