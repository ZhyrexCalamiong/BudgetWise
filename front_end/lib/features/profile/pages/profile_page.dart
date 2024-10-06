import 'package:flutter/material.dart';
import '../screens/edit_profile_page.dart';
import '../screens/change_password_page.dart';
import '../screens/change_email_page.dart';
import '../screens/settings_page.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(
          0xFF121212), // Dark background color for the entire screen
      body: Column(
        children: [
          const SizedBox(height: 20),
          // Profile Image and Name
          CircleAvatar(
            radius: 50,
            backgroundColor:
                Colors.grey.shade800, // Darker background for the avatar
            child: const Icon(
              Icons.person,
              size: 50,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            'ADFJADKSFADSFAJDSLGJAKSDG',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white, // Change text color to white
            ),
          ),
          const SizedBox(height: 30),

          // Options List
          Expanded(
            child: ListView(
              children: [
                ProfileOption(
                  icon: Icons.edit,
                  text: 'Edit Profile Name',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const EditProfilePage()),
                    );
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
                  icon: Icons.email,
                  text: 'Change Email Address',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const ChangeEmailPage()),
                    );
                  },
                ),
                ProfileOption(
                  icon: Icons.settings,
                  text: 'Settings',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const SettingsPage()),
                    );
                  },
                ),
                ProfileOption(
                  icon: Icons.logout,
                  text: 'Logout',
                  isLast: true,
                  onTap: () {
                    // Handle logout
                  },
                ),
              ],
            ),
          ),
        ],
      ),
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
          leading:
              Icon(icon, color: Colors.white), // Change icon color to white
          title: Text(
            text,
            style: const TextStyle(
                color: Colors.white), // Change text color to white
          ),
          trailing: const Icon(Icons.arrow_forward_ios,
              color: Colors.grey), // Change arrow color
          onTap: onTap,
        ),
        if (!isLast) const Divider(color: Colors.grey), // Change divider color
      ],
    );
  }
}
