import 'package:flutter/material.dart';
import 'package:HabitShare/Constants.dart';
import 'package:HabitShare/features/friends/addfriends/contact.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:flutter_svg/svg.dart';

class FriendsTab extends StatefulWidget {
  final List<Contact> selectedFriends;

  const FriendsTab({
    Key? key,
    required this.selectedFriends,
  }) : super(key: key);

  @override
  State<FriendsTab> createState() => _FriendsTabState();
}

class _FriendsTabState extends State<FriendsTab> {
  bool isPopoverVisible = false;

  // Function to toggle the visibility of the popover
  void togglePopover() {
    setState(() {
      isPopoverVisible = !isPopoverVisible;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Contact> selectedFriends = widget.selectedFriends;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.group_add),
            iconSize: 25,
            onPressed: togglePopover,
          ),
        ],
        title: Text("Friends", style: appbarTextStyle),
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
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ContactPage(),
                                    ),
                                  );
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
