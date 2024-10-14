import 'package:budgetwise_one/bloc/profile/edit_profile_bloc.dart';
import 'package:budgetwise_one/bloc/profile/profile_bloc.dart';
import 'package:budgetwise_one/bloc/profile/profile_event.dart';
import 'package:budgetwise_one/bloc/profile/profile_state.dart';
import 'package:budgetwise_one/pages/login_page.dart';
import 'package:budgetwise_one/repositories/user_repository_impl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:budgetwise_one/features/guide/screen/introduction_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../screens/edit_profile_page.dart';
import '../screens/change_password_page.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileState();
}

class _ProfileState extends State<ProfileScreen> {
  late ProfileBloc profileBloc; // Use late initialization

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  void _initialize() {
    // Initialize UserService and ProfileBloc
    final userService = UserService();
    profileBloc = ProfileBloc(userService);
    profileBloc.add(FetchUserName()); // Trigger the fetch event here
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ProfileBloc>(
      create: (context) => profileBloc, // Use the initialized bloc
      child: Scaffold(
        backgroundColor: const Color(0xFF0D0D0D),
        body: Column(
          children: [
            const SizedBox(height: 20),
            // Profile Image and Name
            CircleAvatar(
              radius: 50,
              backgroundColor: Colors.grey.shade800,
              child: const Icon(
                Icons.person,
                size: 50,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 10),

            // Use BlocBuilder to display the profile data
            BlocBuilder<ProfileBloc, ProfileState>(
              builder: (context, state) {
                if (state is ProfileLoading) {
                  return const CircularProgressIndicator();
                } else if (state is ProfileLoaded) {
                  return Text(
                    '${state.user[0].firstName.toString()} ${state.user[0].middleName.toString()} ${state.user[0].lastName.toString()}', // Ensure correct access to the user's data
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  );
                } else if (state is ProfileError) {
                  return Text(
                    state.message,
                    style: const TextStyle(
                      color: Colors.red,
                    ),
                  );
                } else {
                  return const Text(
                    'Unknown user',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  );
                }
              },
            ),
            const SizedBox(height: 30),

            // Options List
            Expanded(
              child: ListView(
                children: [
                  ProfileOption(
                    icon: Icons.edit,
                    text: 'Edit Profile Name',
                    onTap: () async {
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BlocProvider(
                            create: (context) => EditProfileBloc(UserService()),
                            child: const EditProfilePage(),
                          ),
                        ),
                      );

                      // Check if the result indicates a profile update and refresh the screen
                      if (result == true) {
                        // Reload profile data
                        profileBloc.add(FetchUserName());
                      }
                    },
                  ),
                  ProfileOption(
                    icon: Icons.lock,
                    text: 'Change Password',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const ChangePasswordPage()),
                      );
                    },
                  ),
                  ProfileOption(
                    icon: Icons.settings,
                    text: 'Help',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const IntroductionPage()),
                      );
                    },
                  ),
                  ProfileOption(
                    icon: Icons.logout,
                    text: 'Logout',
                    isLast: true,
                    onTap: () {
                      _showLogoutConfirmationDialog(context);
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> logout(BuildContext context) async {
    // Clear user data from shared preferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear(); // Clear all stored data

    // Navigate back to the login page
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
    );
  }

  void _showLogoutConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor:
              const Color(0xFF121212), // Match your screen's background color
          title: const Text(
            'Confirm Logout',
            style: TextStyle(color: Colors.white), // Set title text color
          ),
          content: const Text(
            'Are you sure you want to logout?',
            style: TextStyle(color: Colors.white), // Set content text color
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text(
                'Cancel',
                style: TextStyle(color: Colors.grey), // Set button text color
              ),
            ),
            TextButton(
              onPressed: () {
                // Trigger logout through the BLoC
                logout(context);
              },
              child: const Text(
                'Logout',
                style: TextStyle(color: Colors.red), // Set button text color
              ),
            ),
          ],
        );
      },
    );
  }
}

class ProfileOption extends StatelessWidget {
  final IconData icon;
  final String text;
  final bool isLast;
  final VoidCallback onTap;

  const ProfileOption({
    super.key,
    required this.icon,
    required this.text,
    this.isLast = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          leading: Icon(icon, color: Colors.white),
          title: Text(
            text,
            style: const TextStyle(color: Colors.white),
          ),
          trailing: const Icon(
            Icons.arrow_forward_ios,
            color: Colors.grey,
          ),
          onTap: onTap,
        ),
        if (!isLast) const Divider(color: Colors.grey),
      ],
    );
  }
}
