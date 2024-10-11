import 'package:budgetwise_one/repositories/user_repository_impl.dart';
import 'package:budgetwise_one/widgets/reset_password_modal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/authentication/forgot_password/forgot_password_bloc.dart';
import '../bloc/authentication/forgot_password/forgot_password_event.dart';
import '../bloc/authentication/forgot_password/forgot_password_state.dart';

class ForgotPasswordModal extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final Function(String email) onSuccess; // To trigger the next modal

  ForgotPasswordModal({super.key, required this.onSuccess});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ForgotPasswordBloc(UserService()),
      child: BlocConsumer<ForgotPasswordBloc, ForgotPasswordState>(
        listener: (context, state) {
          if (state is ForgotPasswordErrorState) {
            _showErrorDialog(context, state.message);
          } else if (state is ForgotPasswordSuccessState) {
            onSuccess(emailController.text);
            Navigator.pop(context); // Close the current modal
          }
        },
        builder: (context, state) {
          return _buildForgotPasswordUI(context);
        },
      ),
    );
  }

  Widget _buildForgotPasswordUI(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24.0),
      decoration: const BoxDecoration(
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
            title: const Text('Forgot Password',
                style: TextStyle(color: Colors.black)),
            toolbarHeight: 56,
          ),
          const SizedBox(height: 24),
          _buildTextField('Email', controller: emailController, fontSize: 14.0),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              try {
                BlocProvider.of<ForgotPasswordBloc>(context).add(
                  ForgotPasswordSubmitEvent(emailController.text),
                );
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ResetPasswordModal(email: emailController.text.toString())));
              } catch (e) {
                print(e);
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF75ECE1),
              minimumSize: const Size.fromHeight(50),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text('Send',
                style: TextStyle(fontSize: 12, color: Colors.white)),
          ),
        ],
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

  Widget _buildTextField(String labelText,
      {TextEditingController? controller, double fontSize = 14.0}) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        filled: true,
        fillColor: const Color(0xFFFFFFFF),
      ),
    );
  }
}
