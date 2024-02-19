import 'package:flutter/material.dart';

class CurrentUserProvider extends ChangeNotifier {
  String? _currentUserId;

  String? get currentUserId => _currentUserId;

  void setCurrentUserId(String userId) {
    _currentUserId = userId;
    notifyListeners();
  }
}
