import 'package:HabitShare/features/authentication/AuthPage.dart';
import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Profile Picture',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Center(
            child: CircleAvatar(
              // You can load the user's profile picture here from a URL or local asset
              backgroundImage: AssetImage('assets/profile_picture.png'),
              radius: 50, // Adjust the size of the avatar as needed
            ),
          ),
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('Name'),
            onTap: () {
              // Handle name change
            },
          ),
          ListTile(
            leading: const Icon(Icons.notifications),
            title: const Text('Notifications & Reminders'),
            onTap: () {
              // Handle notification settings
            },
          ),
          ListTile(
            leading: const Icon(Icons.beach_access),
            title: const Text('Vacation Mode'),
            onTap: () {
              // Handle notification settings
            },
          ),
          ListTile(
            leading: const Icon(Icons.palette),
            title: const Text('Theme'),
            onTap: () {
              // Handle theme change
            },
          ),
          ListTile(
            leading: const Icon(Icons.language),
            title: const Text('Language'),
            onTap: () {
              // Handle language change
            },
          ),
          ListTile(
            leading: const Icon(Icons.star),
            title: const Text('Rate Us'),
            onTap: () {
              // Open app rating page
            },
          ),
          ListTile(
            leading: const Icon(Icons.share),
            title: const Text('Share App'),
            onTap: () {
              // Handle app sharing functionality
            },
          ),
          ListTile(
            leading: const Icon(Icons.feedback),
            title: const Text('Feedback'),
            onTap: () {
              // Handle user feedback
            },
          ),
          ListTile(
            leading: const Icon(Icons.security),
            title: const Text('Privacy Policy'),
            onTap: () {
              // Open privacy policy page
            },
          ),
          ListTile(
            leading: const Icon(Icons.info),
            title: const Text('Version'),
            subtitle: const Text('1.0.0'), // Replace with your app version
            onTap: () {
              // Handle version information
            },
          ),
          ListTile(
            leading: const Icon(Icons.exit_to_app),
            title: const Text('Log Out'),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const AuthPage()));
            },
          ),
          ListTile(
            leading: const Icon(Icons.contact_phone),
            title: const Text('Contact Us'),
            onTap: () {
              // Open privacy policy page
            },
          ),
          ListTile(
            leading: const Icon(Icons.star),
            title: const Text('Review & Support'),
            onTap: () {
              // Open privacy policy page
            },
          ),
        ],
      ),
    );
  }
}
