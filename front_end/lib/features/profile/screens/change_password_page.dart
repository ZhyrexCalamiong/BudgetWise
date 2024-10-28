import 'package:budgetwise_one/pages/login_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:budgetwise_one/repositories/user_repository_impl.dart';
import 'package:budgetwise_one/bloc/authentication/forgot_password/forgot_password_bloc.dart';
import 'package:budgetwise_one/bloc/authentication/forgot_password/forgot_password_event.dart';
import 'package:budgetwise_one/bloc/authentication/forgot_password/forgot_password_state.dart';
import 'package:budgetwise_one/bloc/authentication/forgot_password/reset_password_bloc.dart';
import 'package:budgetwise_one/bloc/authentication/forgot_password/reset_password_event.dart';
import 'package:budgetwise_one/bloc/authentication/forgot_password/reset_password_state.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({super.key});

  @override
  _ChangePasswordPageState createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;
  bool _isButtonEnabled = true;
  String _buttonText = 'Send Code';
  Timer? _timer;
  int _countdownTime = 30;

  final TextEditingController emailController = TextEditingController();
  final TextEditingController otpController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ForgotPasswordBloc>(
          create: (context) => ForgotPasswordBloc(UserService()),
        ),
        BlocProvider<ResetPasswordBloc>(
          create: (context) => ResetPasswordBloc(UserService()),
        ),
      ],
      child: Scaffold(
        backgroundColor: const Color(0xFF0D0D0D),
        appBar: AppBar(
          backgroundColor: const Color(0xFF0D0D0D),
          title: const Text(
            'Change Password',
            style: TextStyle(fontSize: 24),
          ),
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
            child: BlocConsumer<ForgotPasswordBloc, ForgotPasswordState>(
              listener: (context, state) {
                if (state is ForgotPasswordSuccessState) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content: Text('OTP sent to ${emailController.text}')),
                  );
                } else if (state is ForgotPasswordErrorState) {
                  _showErrorDialog(context, state.message);
                }
              },
              builder: (context, forgotPasswordState) {
                return BlocConsumer<ResetPasswordBloc, ResetPasswordState>(
                  listener: (context, state) {
                    if (state is ResetPasswordSuccess) {
                      _showSuccessDialog(
                          context, "Password reset successful. Please log in.");
                    } else if (state is ResetPasswordFailure) {
                      _showErrorDialog(context, state.error);
                    }
                  },
                  builder: (context, resetPasswordState) {
                    return SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 20),
                          _buildTextField(
                            'Email',
                            controller: emailController,
                            borderRadius: 10,
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Expanded(
                                child: _buildTextField(
                                  'Input OTP Code',
                                  controller: otpController,
                                  borderRadius: 10,
                                ),
                              ),
                              const SizedBox(width: 10),
                              SizedBox(
                                height: 45,
                                width: 80,
                                child: ElevatedButton(
                                  onPressed: _isButtonEnabled
                                      ? () {
                                          BlocProvider.of<ForgotPasswordBloc>(
                                                  context)
                                              .add(
                                            ForgotPasswordSubmitEvent(
                                                emailController.text),
                                          );
                                          _startCooldown();
                                        }
                                      : null,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF8BBE6D),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  child: Text(
                                    _buttonText,
                                    style: const TextStyle(
                                        fontSize: 12, color: Colors.black),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          _buildPasswordTextField(
                            'New Password',
                            controller: newPasswordController,
                            obscureText: !_isPasswordVisible,
                            onVisibilityToggle: () {
                              setState(() {
                                _isPasswordVisible = !_isPasswordVisible;
                              });
                            },
                          ),
                          const SizedBox(height: 16),
                          _buildPasswordTextField(
                            'Confirm Password',
                            controller: confirmPasswordController,
                            obscureText: !_isConfirmPasswordVisible,
                            onVisibilityToggle: () {
                              setState(() {
                                _isConfirmPasswordVisible =
                                    !_isConfirmPasswordVisible;
                              });
                            },
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () {
                              if (newPasswordController.text ==
                                  confirmPasswordController.text) {
                                BlocProvider.of<ResetPasswordBloc>(context).add(
                                  ChangePasswordRequested(
                                    emailController.text,
                                    otpController.text,
                                    newPasswordController.text,
                                  ),
                                );
                              } else {
                                _showErrorDialog(
                                    context, "Passwords do not match!");
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
                              'Confirm',
                              style:
                                  TextStyle(fontSize: 16, color: Colors.black),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Future<void> logout(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
    );
  }

  void _startCooldown() {
    setState(() {
      _isButtonEnabled = false;
      _countdownTime = 30;
      _buttonText = 'Wait $_countdownTime s';
    });

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_countdownTime > 0) {
        setState(() {
          _countdownTime--;
          _buttonText = 'Wait $_countdownTime s';
        });
      } else {
        _timer?.cancel();
        setState(() {
          _isButtonEnabled = true;
          _buttonText = 'Send Code';
        });
      }
    });
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
                logout(context);
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
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
                Navigator.pop(context);
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildPasswordTextField(String labelText,
      {required TextEditingController controller,
      required bool obscureText,
      required VoidCallback onVisibilityToggle}) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        labelText: labelText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        suffixIcon: IconButton(
          icon: Icon(
            obscureText ? Icons.visibility : Icons.visibility_off,
          ),
          onPressed: onVisibilityToggle,
        ),
      ),
    );
  }

  Widget _buildTextField(String labelText,
      {required TextEditingController controller, double borderRadius = 5.0}) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
