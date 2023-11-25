import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String username = '';
  String email = '';
  String phoneNumber = '';
  DateTime? selectedDate;
  bool isEditing = false;
  File? _profileImageFile;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: Colors.blue,
        actions: [
          if (isEditing)
            TextButton(
              onPressed: () {
                // Handle save functionality
                _saveChanges();
              },
              child: const Text('Save'),
            ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          Container(
            alignment: Alignment.center,
            child: Stack(
              alignment: Alignment.bottomRight,
              children: [
                if (_profileImageFile != null)
                  CircleAvatar(
                    radius: 60.0,
                    backgroundImage: FileImage(_profileImageFile!),
                  ),
                if (_profileImageFile == null)
                  GestureDetector(
                    onTap: () => _pickImage(),
                    child: const CircleAvatar(
                      radius: 60.0,
                      child: Icon(
                        Icons.camera_alt,
                        size: 40.0,
                      ),
                    ),
                  ),
                if (!isEditing)
                  IconButton(
                    icon: const Icon(Icons.camera_alt),
                    padding: const EdgeInsets.only(top: 30, left: 30),
                    onPressed: () {
                      _editProfilePicture();
                    },
                  ),
              ],
            ),
          ),
          const SizedBox(height: 20.0),
          _buildProfileInfo('Username', username, Icons.person),
          _buildProfileInfo('Email', email, Icons.email),
          _buildProfileInfo('Phone Number', phoneNumber, Icons.phone),
          _buildProfileInfo(
            'Date of Birth',
            selectedDate != null
                ? DateFormat('yyyy-MM-dd').format(selectedDate!)
                : 'Not set',
            Icons.calendar_today,
          ),
          const SizedBox(height: 20.0),
          if (isEditing)
            ElevatedButton(
              onPressed: () => _selectDate(context),
              child: const Text('Select Date of Birth'),
            ),
        ],
      ),
    );
  }

  Widget _buildProfileInfo(String label, String value, IconData leadingIcon) {
    return ListTile(
      leading: Icon(leadingIcon),
      title: isEditing
          ? TextFormField(
              initialValue: value,
              onChanged: (newValue) {
                setState(() {
                  value = newValue;
                });
              },
              decoration: InputDecoration(
                labelText: label,
              ),
            )
          : Text(
              label,
              style: const TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
      subtitle: isEditing
          ? const SizedBox()
          : Text(
              value,
              style: const TextStyle(
                fontSize: 18.0,
              ),
            ),
      trailing: isEditing
          ? null
          : IconButton(
              icon: const Icon(Icons.edit),
              onPressed: () {
                _editField(label, value, leadingIcon);
              },
            ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (pickedDate != null && pickedDate != selectedDate) {
      setState(() {
        selectedDate = pickedDate;
      });
    }
  }

  void _editField(String label, String value, IconData leadingIcon) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        String updatedValue = value;

        return AlertDialog(
          title: Text('Edit $label'),
          content: TextFormField(
            initialValue: value,
            onChanged: (newValue) {
              updatedValue = newValue;
            },
            decoration: InputDecoration(labelText: 'New $label'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  _updateValue(label, updatedValue);
                });
                Navigator.of(context).pop();
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void _updateValue(String label, String updatedValue) {
    switch (label) {
      case 'Username':
        username = updatedValue;
        break;
      case 'Email':
        email = updatedValue;
        break;
      case 'Phone Number':
        phoneNumber = updatedValue;
        break;
    }
  }

  void _saveChanges() {
    setState(() {
      isEditing = false;
    });
  }

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _profileImageFile = File(pickedFile.path);
      });
    }
  }

  void _editProfilePicture() {
    _pickImage();
  }
}
