import 'package:budgetwise_one/bloc/authentication/login/login_bloc.dart';
import 'package:budgetwise_one/bloc/authentication/login/login_event.dart';
import 'package:budgetwise_one/bloc/authentication/login/login_state.dart';
import 'package:budgetwise_one/features/home/pages/home_page.dart';
import 'package:budgetwise_one/repositories/user_repository_impl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:budgetwise_one/widgets/forgot_password_modal.dart';
import 'package:budgetwise_one/widgets/reset_password_modal.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();

  final TextEditingController passwordController = TextEditingController();

  late LoginBloc loginBloc;

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    final userService = UserService();
    loginBloc = LoginBloc(userService);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => loginBloc,
      child: BlocConsumer<LoginBloc, LoginState>(listener: (context, state) {
        if (state is LoginLoading) {
          const Center(child: CircularProgressIndicator());
        } else if (state is LoginNavigateToHomeScreenActionState) {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const HomePage()));
        } else if (state is LoginError) {
          // Show error message for login failure
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      }, builder: (context, state) {
        if (state is LoginInitial) {
          return Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              title: const Text('Login'),
            ),
            body: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                  _buildTextField('Email', controller: emailController),
                  const SizedBox(height: 16),
                  _buildTextField('Password',
                      controller: passwordController, obscureText: true),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      final email = emailController.text.trim();
                      final password = passwordController.text.trim();

                      if (email.isNotEmpty && password.isNotEmpty) {
                        context
                            .read<LoginBloc>()
                            .add(LoginSubmitted(email, password));
                      }
                    },
                    child: const Text('Login'),
                  ),
                  TextButton(
                    onPressed: () {
                      _showForgotPasswordModal(context);
                    },
                    child: const Text('Forgot Password?'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const HomePage()));
                    },
                    child: const Text('Backdoor'),
                  ),
                ],
              ),
            ),
          );
        } else {
          return Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              title: const Text('Login'),
            ),
            body: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                  _buildTextField('Email', controller: emailController),
                  const SizedBox(height: 16),
                  _buildTextField('Password',
                      controller: passwordController, obscureText: true),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      final email = emailController.text.trim();
                      final password = passwordController.text.trim();

                      if (email.isNotEmpty && password.isNotEmpty) {
                        context
                            .read<LoginBloc>()
                            .add(LoginSubmitted(email, password));
                      }
                    },
                    child: const Text('Login'),
                  ),
                  TextButton(
                    onPressed: () {
                      _showForgotPasswordModal(context);
                    },
                    child: const Text('Forgot Password?'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const HomePage()));
                    },
                    child: const Text('Backdoor'),
                  ),
                ],
              ),
            ),
          );
        }
      }),
    );
  }

  // Function to show ForgotPasswordModal
  void _showForgotPasswordModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return ForgotPasswordModal(
          onSuccess: (email) {
            _showResetPasswordModal(context);
          },
        );
      },
    );
  }

  // Function to show ResetPasswordModal
  void _showResetPasswordModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return ResetPasswordModal(email: "");
      },
    );
  }

  Widget _buildTextField(String labelText,
      {TextEditingController? controller, bool obscureText = false}) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        labelText: labelText,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        filled: true,
        fillColor: const Color(0xFFFFFFFF),
      ),
    );
  }
}
