import 'package:budgetwise_one/bloc/profile/edit_profile_bloc.dart';
import 'package:budgetwise_one/bloc/profile/profile_bloc.dart';
import 'package:budgetwise_one/bloc/profile/profile_event.dart';
import 'package:budgetwise_one/bloc/profile/profile_state.dart';
import 'package:budgetwise_one/pages/login_page.dart';
import 'package:budgetwise_one/repositories/user_repository_impl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:budgetwise_one/features/guide/screen/introduction_screen.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../screens/edit_profile_page.dart';
import '../screens/change_password_page.dart';
import 'package:http/http.dart' as http;
import 'dart:io';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileState();
}

class _ProfileState extends State<ProfileScreen> {
  late ProfileBloc profileBloc;

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  void _initialize() {
    final userService = UserService();
    profileBloc = ProfileBloc(userService);
    profileBloc.add(FetchUserName());
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ProfileBloc>(
      create: (context) => profileBloc,
      child: Scaffold(
        backgroundColor: const Color(0xFF0D0D0D),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 40),
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
            BlocBuilder<ProfileBloc, ProfileState>(
              builder: (context, state) {
                if (state is ProfileLoading) {
                  return const CircularProgressIndicator(color: Colors.white);
                } else if (state is ProfileLoaded) {
                  return Center(
                    child: Text(
                      '${state.user[0].firstName} ${state.user[0].middleName} ${state.user[0].lastName}',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  );
                } else if (state is ProfileError) {
                  return Center(
                    child: Text(
                      state.message,
                      style: const TextStyle(color: Colors.red),
                    ),
                  );
                } else {
                  return Center(
                    child: const Text(
                      'Unknown user',
                      style: TextStyle(color: Colors.white),
                    ),
                  );
                }
              },
            ),
            const SizedBox(height: 30),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(16.0),
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

                      if (result == true) {
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
                    icon: Icons.file_download,
                    text: 'Download CSV',
                    onTap: () {
                      _downloadCsv(); // Call the download function here
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

  Future<void> _downloadCsv() async {
    try {
      final response =
          await http.get(Uri.parse('http://localhost:8000/api/export-csv'));

      if (response.statusCode == 200) {
        final directory = await getApplicationDocumentsDirectory();
        final filePath = '${directory.path}/budget.csv';
        final File file = File(filePath);
        await file.writeAsBytes(response.bodyBytes);

        print('CSV exported successfully: $filePath');

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('CSV exported successfully: $filePath')),
        );
      } else {
        print('Failed to export CSV. Status code: ${response.statusCode}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to export CSV.')),
        );
      }
    } catch (e) {
      print('An error occurred while exporting CSV: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred while exporting CSV.')),
      );
    }
  }

  Future<void> logout(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();

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
          backgroundColor: const Color(0xFF121212),
          title: const Text(
            'Confirm Logout',
            style: TextStyle(color: Colors.white),
          ),
          content: const Text(
            'Are you sure you want to logout?',
            style: TextStyle(color: Colors.white),
          ),
          actions: <Widget>[
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey,
              ),
              child: const Text(
                'Cancel',
                style: TextStyle(color: Colors.white),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                logout(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
              ),
              child: const Text('Logout'),
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
    return Card(
      color: Colors.grey.shade800,
      margin: const EdgeInsets.only(bottom: 16.0), // Add margin to cards
      child: ListTile(
        leading: Icon(icon, color: Colors.white),
        title: Text(
          text,
          style: const TextStyle(color: Colors.white, fontSize: 16),
        ),
        trailing: const Icon(
          Icons.arrow_forward_ios,
          color: Colors.grey,
        ),
        onTap: onTap,
      ),
    );
  }
}
