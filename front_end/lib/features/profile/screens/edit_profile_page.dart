import 'package:budgetwise_one/bloc/profile/edit_profile_bloc.dart';
import 'package:budgetwise_one/bloc/profile/edit_profile_event.dart';
import 'package:budgetwise_one/bloc/profile/edit_profile_state.dart';
import 'package:budgetwise_one/repositories/user_repository_impl.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  bool isFirstNameEmpty = false;
  bool isMiddleNameEmpty = false;
  bool isLastNameEmpty = false;

  @override
  void dispose() {
    firstNameController.dispose();
    middleNameController.dispose();
    lastNameController.dispose();
    super.dispose();
  }

  void _validateAndSubmit() {
    setState(() {
      isFirstNameEmpty = firstNameController.text.trim().isEmpty;
      isMiddleNameEmpty = middleNameController.text.trim().isEmpty;
      isLastNameEmpty = lastNameController.text.trim().isEmpty;
    });

    if (isFirstNameEmpty || isMiddleNameEmpty || isLastNameEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('All fields are required!')),
      );
    } else {
      final firstName = firstNameController.text;
      final middleName = middleNameController.text;
      final lastName = lastNameController.text;

      context.read<EditProfileBloc>().add(
        UpdateProfile(
          firstName: firstName,
          middleName: middleName,
          lastName: lastName,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<EditProfileBloc, EditProfileState>(
      listener: (context, state) {
        if (state is EditProfileSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Profile updated successfully!')),
          );
          Navigator.pop(context, true); 
        } else if (state is EditProfileError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: ${state.message}')),
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Edit Profile'),
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
                  const SizedBox(height: 20),
                  _TextField(
                    labelText: 'First Name',
                    controller: firstNameController,
                    borderRadius: 10,
                    isEmpty: isFirstNameEmpty,
                    errorText: 'Please enter a valid First name',
                  ),
                  const SizedBox(height: 16),
                  _TextField(
                    labelText: 'Middle Name',
                    controller: middleNameController,
                    borderRadius: 10,
                    isEmpty: isMiddleNameEmpty,
                    errorText: 'Please enter a valid Middle name',
                  ),
                  const SizedBox(height: 16),
                  _TextField(
                    labelText: 'Last Name',
                    controller: lastNameController,
                    borderRadius: 10,
                    isEmpty: isLastNameEmpty,
                    errorText: 'Please enter a valid Last Name',
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _validateAndSubmit,
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
        );
      },
    );
  }
}


class _TextField extends StatelessWidget {
  final String labelText;
  final double borderRadius;
  final TextEditingController controller;
  final bool isEmpty;
  final String? errorText; 

  const _TextField({
    required this.labelText,
    required this.controller,
    this.borderRadius = 5.0,
    this.isEmpty = false,
    this.errorText, 
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'^[a-zA-Z\s]*$')),
      ],
      decoration: InputDecoration(
        labelText: labelText,
        errorText: isEmpty ? (errorText ?? 'This field is required') : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
    );
  }
}