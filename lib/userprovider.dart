import 'package:flutter/material.dart';

class UserProvider with ChangeNotifier {
  String _username = 'Username';

  String get username => _username;

  set username(String value) {
    _username = value;
    notifyListeners();
  }
}
