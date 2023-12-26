import 'package:HabitShare/features/authentication/SignIn.dart';
import 'package:HabitShare/features/settings/profile.dart';
import 'package:flutter/material.dart';
import 'dart:io';

import '../../Constants.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  String username = 'Username';
  File? _originalImageFile;
  File? _editedImageFile;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings', style: appbarTextStyle),
        backgroundColor: primaryColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // User Profile Section
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _buildCircularProfilePicture(),
                  const SizedBox(width: 16.0),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          username,
                          style: const TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16.0),

              // Settings Options
              const Text(
                'Settings',
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Divider(thickness: 2.0),
              Column(
                children: settingsOptions.map((option) {
                  return _buildSettingButton(option);
                }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCircularProfilePicture() {
    return GestureDetector(
      onTap: () {
        _showImagePreview();
      },
      child: CircleAvatar(
        radius: 40.0,
        backgroundImage: _editedImageFile != null
            ? FileImage(_editedImageFile!)
            : _originalImageFile != null
                ? FileImage(_originalImageFile!)
                : const AssetImage('assets/images/profile_pic.jpg')
                    as ImageProvider<Object>?,
      ),
    );
  }

  void _showImagePreview() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: _editedImageFile != null
              ? Image.file(_editedImageFile!)
              : _originalImageFile != null
                  ? Image.file(_originalImageFile!)
                  : Image.asset('assets/images/profile_pic.jpg'),
        );
      },
    );
  }

  void _navigateToPage(String settingOption) {
    // Handle navigation based on the selected setting option
    switch (settingOption) {
      case 'Profile':
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const ProfilePage()));
        break;
      case 'Privacy':
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const PrivacyPage()));
        break;
      case 'Feedback':
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const FeedbackPage()));
        break;
      case 'Notification':
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const NotificationPage()));
        break;
      case 'Rate Us':
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const RateUsPage()));
        break;
      case 'Share App':
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const ShareAppPage()));
        break;
      case 'Review and Support':
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const ReviewSupportPage()));
        break;
      case 'Contact Us':
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const ContactUsPage()));
        break;
      case 'Log Out':
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => const SignIn()));
        break;
      default:
        // Handle default case or navigate to a generic settings page
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const GenericSettingsPage()));
    }
  }

  Widget _buildSettingButton(String settingOption) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextButton(
        onPressed: () {
          // Handle the selected setting option
          _navigateToPage(settingOption);
        },
        style: TextButton.styleFrom(
          foregroundColor: primaryColor, // Set the text color to green
        ),
        child: Row(
          children: [
            _buildCustomIcon(settingOption),
            const SizedBox(width: 8.0),
            Text(
              settingOption,
              style: const TextStyle(
                fontSize: 16.0,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCustomIcon(String settingOption) {
    // Customize the icon based on the setting option
    IconData icon;
    Color iconColor = Colors.black; // Default color

    switch (settingOption) {
      case 'Profile':
        icon = Icons.person;
        break;
      case 'Privacy':
        icon = Icons.lock;
        break;
      case 'Feedback':
        icon = Icons.feedback;
        break;
      case 'Notification':
        icon = Icons.notifications;
        break;
      case 'Rate Us':
        icon = Icons.star;
        break;
      case 'Share App':
        icon = Icons.share;
        break;
      case 'Review and Support':
        icon = Icons.thumb_up;
        break;
      case 'Contact Us':
        icon = Icons.contact_mail;
        break;
      case 'Log Out':
        icon = Icons.logout;
        iconColor = Colors.red; // Set color to red for the "Log Out" item
        break;
      default:
        icon = Icons.help;
    }

    return Icon(
      icon,
      color: iconColor,
    );
  }

  final List<String> settingsOptions = [
    'Profile',
    'Privacy',
    'Feedback',
    'Notification',
    'Rate Us',
    'Share App',
    'Review and Support',
    'Contact Us',
    'Log Out',
  ];
}

class PrivacyPage extends StatelessWidget {
  const PrivacyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Privacy Settings', style: appbarTextStyle),
        backgroundColor: primaryColor,
      ),
      body: const Center(
        child: Text('Privacy Settings Page'),
      ),
    );
  }
}

class FeedbackPage extends StatelessWidget {
  const FeedbackPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Feedback', style: appbarTextStyle),
        backgroundColor: primaryColor,
      ),
      body: const Center(
        child: Text('Feedback Page'),
      ),
    );
  }
}

class NotificationPage extends StatelessWidget {
  const NotificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notification Settings', style: appbarTextStyle),
        backgroundColor: primaryColor,
      ),
      body: const Center(
        child: Text('Notification Settings Page'),
      ),
    );
  }
}

class RateUsPage extends StatelessWidget {
  const RateUsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Rate Us', style: appbarTextStyle),
        backgroundColor: primaryColor,
      ),
      body: const Center(
        child: Text('Rate Us Page'),
      ),
    );
  }
}

class ShareAppPage extends StatelessWidget {
  const ShareAppPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Share App', style: appbarTextStyle),
        backgroundColor: primaryColor,
      ),
      body: const Center(
        child: Text('Share App Page'),
      ),
    );
  }
}

class ReviewSupportPage extends StatelessWidget {
  const ReviewSupportPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Review and Support', style: appbarTextStyle),
        backgroundColor: primaryColor,
      ),
      body: const Center(
        child: Text('Review and Support Page'),
      ),
    );
  }
}

class ContactUsPage extends StatelessWidget {
  const ContactUsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contact Us', style: appbarTextStyle),
        backgroundColor: primaryColor,
      ),
      body: const Center(
        child: Text('Contact Us Page'),
      ),
    );
  }
}

class GenericSettingsPage extends StatelessWidget {
  const GenericSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings Page', style: appbarTextStyle),
        backgroundColor: primaryColor,
      ),
      body: const Center(
        child: Text('Generic Settings Page'),
      ),
    );
  }
}
