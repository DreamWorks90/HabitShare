import 'package:HabitShare/features/notification/notification.dart';
import 'package:flutter/material.dart';
import 'package:HabitShare/Constants.dart';
import 'package:HabitShare/features/friends/addfriends/contact.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:flutter_share/flutter_share.dart';

class FriendsTab extends StatefulWidget {
  const FriendsTab({
    Key? key,
  }) : super(key: key);

  @override
  State<FriendsTab> createState() => _FriendsTabState();
}

class _FriendsTabState extends State<FriendsTab> {
  bool isPopoverVisible = false;
  List<Contact> selectedFriends = [];


  // Function to toggle the visibility of the popover
  void togglePopover() {
    setState(() {
      isPopoverVisible = !isPopoverVisible;
    });
  }

  void updateSelectedFriends(List<Contact> newSelectedFriends) {
    setState(() {
      selectedFriends = newSelectedFriends;
      // Close the popover when friends are selected
      isPopoverVisible = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: primaryColor,
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.group_add),
            iconSize: 25,
            onPressed: togglePopover,
          ),
        ],
        title: const Text("Friends", style: appbarTextStyle),
      ),
      body: isPopoverVisible
          ? Stack(
        children: [
          Positioned(
            right: 10,
            top: 10,
            child: IconButton(
              icon: const Icon(Icons.close),
              onPressed: togglePopover,
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 170,
                        width: 200,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            elevation: 5,
                            backgroundColor: primaryColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          onPressed: () async {
                            // Update selectedFriends when ContactPage returns a result
                            List<Contact>? result =
                            await Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => const ContactPage(),
                              ),
                            );
                            if (result != null) {
                              updateSelectedFriends(result);
                            }
                          },
                          child: const Text(
                            "Via Contact",
                            style: buttonTextStyle,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20.0),
                      SizedBox(
                        height: 170,
                        width: 200,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            elevation: 5,
                            backgroundColor: primaryColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          onPressed: shareContent,
                          child: const Text(
                            "via Link Share",
                            style: buttonTextStyle,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      )
          : ListView.builder(
        itemCount: selectedFriends.length,
        itemBuilder: (context, index) {
          Contact friend = selectedFriends[index];
          return ListTile(
            title: Text(friend.displayName ?? ''),
            subtitle: Text(
              friend.phones?.isNotEmpty == true
                  ? friend.phones!.first.value ?? ''
                  : '',
            ),
          );
        },
      ),
    );
  }

  void shareContent() async {
    try {
      await FlutterShare.share(
        title: 'Share Content',
        text: 'Check out this link:',
        linkUrl: 'https://example.com',
      );
    } catch (e) {
      print('Error sharing: $e');
    }
  }
}
class NotificationModel {
  final String title;
  final String description;
  NotificationModel({required this.title, required this.description});
}
