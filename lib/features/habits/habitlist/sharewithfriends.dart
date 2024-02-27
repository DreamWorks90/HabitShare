import 'package:flutter/material.dart';
import 'package:HabitShare/Constants.dart';
import 'package:HabitShare/features/friends/addfriends/contact.dart';
import 'package:contacts_service/contacts_service.dart';

class ShareWithFriends extends StatefulWidget {
  final List<Contact> selectedFriends;

  const ShareWithFriends({
    Key? key,
    required this.selectedFriends,
  }) : super(key: key);

  @override
  State<ShareWithFriends> createState() => _ShareWithFriendsState();
}

class _ShareWithFriendsState extends State<ShareWithFriends> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: const Text("Share With Friends", style: appbarTextStyle),
      ),
      body: ListView.builder(
        itemCount: widget.selectedFriends.length,
        itemBuilder: (context, index) {
          Contact friend = widget.selectedFriends[index];
          return Card(
            margin: EdgeInsets.all(8),
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            color: Colors.white, // Background color of the card
            child: ListTile(
              leading: Icon(
                Icons.person, // Add an icon for visual representation
                color: Colors.black, // Color of the icon
              ),
              title: Text(
                friend.displayName ?? '',
                style: TextStyle(
                  color: Colors.black, // Text color
                  fontWeight: FontWeight.bold, // Text weight
                ),
              ),
              subtitle: Text(
                friend.phones?.isNotEmpty == true
                    ? friend.phones!.first.value ?? ''
                    : '',
                style: TextStyle(
                  color: Colors.black, // Text color
                ),
              ),
              trailing: Checkbox(
                value: true, // Set checkbox value based on some condition
                onChanged: (bool? value) {
                  // Handle checkbox value change here
                  // You can implement the logic to handle checkbox state change
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
