import 'package:HabitShare/Constants.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:contacts_service/contacts_service.dart';

class ContactPage extends StatefulWidget {
  const ContactPage({super.key});

  @override
  _ContactPageState createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  List<Contact> _contacts = [];
  final List<Contact> _selectedFriends = [];
  final TextEditingController _searchController = TextEditingController();
  bool _isLoading = false;

  final int _batchSize = 20;
  int _currentBatchIndex = 0;

  @override
  void initState() {
    super.initState();
    _requestContactsPermission();
  }

  Future<void> _requestContactsPermission() async {
    var permissionStatus = await Permission.contacts.request();
    if (permissionStatus.isGranted) {
      _fetchContacts();
    } else {
      // Handle permission denied
    }
  }

  Future<void> _fetchContacts() async {
    setState(() {
      _isLoading = true;
    });

    try {
      Iterable<Contact> contacts = await _loadContacts();
      _contacts = contacts.toList();
    } catch (e) {
      print('Error loading contacts: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<Iterable<Contact>> _loadContacts() async {
    try {
      return await ContactsService.getContacts(withThumbnails: false);
    } catch (e) {
      // Handle the error (print, log, show a message, etc.)
      return [];
    }
  }

  void _addFriend(Contact friend) {
    if (!_selectedFriends.contains(friend)) {
      setState(() {
        _selectedFriends.add(friend);
      });
    } else {
      setState(() {
        _selectedFriends.remove(friend);
      });
    }
  }

  void _openSelectedFriendsPage() {
    Navigator.pop(context, _selectedFriends);
  }

  void _searchContacts(String query) {
    Iterable<Contact> filteredContacts = _contacts.where((contact) =>
        (contact.displayName?.toLowerCase().contains(query.toLowerCase()) ??
            false) ||
        (contact.phones
                ?.any((phone) => phone.value?.contains(query) ?? false) ??
            false));
    setState(() {
      _contacts = filteredContacts.toList();
    });
  }

  Future<void> _loadMoreContacts() async {
    setState(() {
      _isLoading = true;
    });

    try {
      Iterable<Contact> additionalContacts = await _loadContacts();
      // Slice the list to get the next batch
      _contacts.addAll(
        additionalContacts.skip(_currentBatchIndex).take(_batchSize),
      );
      _currentBatchIndex += _batchSize;
    } catch (e) {
      // Handle error
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryColor,
        title: const Text('Habit Share'),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: _openSelectedFriendsPage,
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              onChanged: _searchContacts,
              decoration: const InputDecoration(
                hintText: 'Search contacts',
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
          Expanded(
            child: _buildContactsList(),
          ),
        ],
      ),
    );
  }

  Widget _buildContactsList() {
    return _isLoading
        ? const Center(child: CircularProgressIndicator())
        : ListView.builder(
            itemCount: _contacts.length + 1,
            itemBuilder: (context, index) {
              if (index == _contacts.length) {
                // Show a loading indicator at the end of the list
                return _buildLoadMoreIndicator();
              } else {
                Contact contact = _contacts[index];
                return Card(
                  elevation: 3.0,
                  margin: const EdgeInsets.symmetric(
                      vertical: 8.0, horizontal: 16.0),
                  child: CheckboxListTile(
                    title: Text(contact.displayName ?? ''),
                    subtitle: Text(
                      contact.phones?.isNotEmpty == true
                          ? contact.phones!.first.value ?? ''
                          : '',
                    ),
                    value: _selectedFriends.contains(contact),
                    onChanged: (bool? value) {
                      _addFriend(contact);
                    },
                  ),
                );
              }
            },
          );
  }

  Widget _buildLoadMoreIndicator() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Center(
        child: ElevatedButton(
          onPressed: _loadMoreContacts,
          child: const Text('Load More'),
        ),
      ),
    );
  }
}

class SelectedFriendsPage extends StatelessWidget {
  final List<Contact> selectedFriends;

  const SelectedFriendsPage({super.key, required this.selectedFriends});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Selected Friends'),
      ),
      body: ListView.builder(
        itemCount: selectedFriends.length,
        itemBuilder: (context, index) {
          Contact friend = selectedFriends[index];
          return ListTile(
            title: Text(friend.displayName ?? ''),
            subtitle: Text(
              friend.phones?.isNotEmpty == true
                  ? friend.phones!.first.value ?? ''
                  : '',
            ), // Disable checkbox interaction in this view
          );
        },
      ),
    );
  }
}
