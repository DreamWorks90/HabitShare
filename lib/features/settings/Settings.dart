import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

import '../../Constants.dart';
import '../../userprovider.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  String username = 'Username'; // Initialize with the user's username
  File? _imageFile;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
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
                  CircleAvatar(
                    radius: 40.0,
                    backgroundImage: AssetImage(
                        'assets/images/profile_pic.jpg'), // Replace with your image
                  ),
                  SizedBox(width: 16.0),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        username,
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          // Implement edit profile functionality
                          _showEditProfileDialog();
                        },
                        child: Text(
                          'Edit Profile',
                          style: TextStyle(
                            color: primaryColor,
                            fontSize: 16.0,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 16.0),

              // Settings Options
              Text(
                'Settings',
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Divider(thickness: 2.0),
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

  void _showEditProfileDialog() {
    // Implement the edit profile dialog
    // For simplicity, we'll just update the username in this example
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Edit Profile'),
          content: TextField(
            decoration: InputDecoration(labelText: 'Enter new username'),
            onChanged: (value) {
              setState(() {
                username = value;
              });
            },
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                // Save the new username or perform other edit profile actions
                Navigator.of(context).pop();
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void _navigateToPage(String settingOption) {
    // Handle navigation based on the selected setting option
    switch (settingOption) {
      case 'Privacy':
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => PrivacyPage()));
        break;
      case 'Feedback':
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => FeedbackPage()));
        break;
      case 'Notification':
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => NotificationPage()));
        break;
      case 'Rate Us':
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => RateUsPage()));
        break;
      case 'Share App':
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => ShareAppPage()));
        break;
      case 'Review and Support':
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => ReviewSupportPage()));
        break;
      case 'Contact Us':
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => ContactUsPage()));
        break;
      case 'Log Out':
        // Implement log out functionality
        break;
      default:
        // Handle default case or navigate to a generic settings page
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => GenericSettingsPage()));
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
          primary: primaryColor, // Set the text color to green
        ),
        child: Row(
          children: [
            _buildCustomIcon(settingOption),
            SizedBox(width: 8.0),
            Text(
              settingOption,
              style: TextStyle(
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Privacy Settings'),
      ),
      body: Center(
        child: Text('Privacy Settings Page'),
      ),
    );
  }
}

class FeedbackPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Feedback'),
      ),
      body: Center(
        child: Text('Feedback Page'),
      ),
    );
  }
}

class NotificationPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notification Settings'),
      ),
      body: Center(
        child: Text('Notification Settings Page'),
      ),
    );
  }
}

class RateUsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Rate Us'),
      ),
      body: Center(
        child: Text('Rate Us Page'),
      ),
    );
  }
}

class ShareAppPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Share App'),
      ),
      body: Center(
        child: Text('Share App Page'),
      ),
    );
  }
}

class ReviewSupportPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Review and Support'),
      ),
      body: Center(
        child: Text('Review and Support Page'),
      ),
    );
  }
}

class ContactUsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Contact Us'),
      ),
      body: Center(
        child: Text('Contact Us Page'),
      ),
    );
  }
}

class GenericSettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings Page'),
      ),
      body: Center(
        child: Text('Generic Settings Page'),
      ),
    );
  }
}
