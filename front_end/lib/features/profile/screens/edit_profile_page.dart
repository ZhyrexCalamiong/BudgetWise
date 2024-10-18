import 'package:budgetwise_one/bloc/profile/edit_profile_bloc.dart';
import 'package:budgetwise_one/bloc/profile/edit_profile_event.dart';
import 'package:budgetwise_one/bloc/profile/edit_profile_state.dart';
import 'package:budgetwise_one/repositories/user_repository_impl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  _EditProfilePage createState() => _EditProfilePage();
}

class _EditProfilePage extends State<EditProfilePage> {
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController middleNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();

  @override
  void dispose() {
    firstNameController.dispose();
    middleNameController.dispose();
    lastNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          EditProfileBloc(UserService()), // Use the EditProfileBloc
      child: BlocListener<EditProfileBloc, EditProfileState>(
        listener: (context, state) {
          if (state is EditProfileSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Profile updated successfully!')),
            );
            Navigator.pop(context);
          } else if (state is EditProfileError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Error: ${state.message}')),
            );
          }
        },
        child: Scaffold(
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
                  _TextField(
                    labelText: 'First Name',
                    controller: firstNameController,
                    borderRadius: 10,
                  ),
                  const SizedBox(height: 16),
                  _TextField(
                    labelText: 'Middle Name',
                    controller: middleNameController,
                    borderRadius: 10,
                  ),
                  const SizedBox(height: 16),
                  _TextField(
                    labelText: 'Last Name',
                    controller: lastNameController,
                    borderRadius: 10,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      final firstName = firstNameController.text;
                      final middleName = middleNameController.text;
                      final lastName = lastNameController.text;

                      // Trigger UpdateProfile event with the necessary data
                      context.read<EditProfileBloc>().add(
                            UpdateProfile(
                              firstName: firstName,
                              middleName: middleName,
                              lastName: lastName,
                            ),
                          );
                      Navigator.pop(context, true);
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
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _TextField extends StatelessWidget {
  final String labelText;
  final double borderRadius;
  final TextEditingController controller;

  const _TextField({
    required this.labelText,
    required this.controller,
    this.borderRadius = 5.0, // default value for borderRadius
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
    );
  }
}
