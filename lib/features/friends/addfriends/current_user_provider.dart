import 'package:flutter/material.dart';

import '../Friends.dart';

class CurrentUserProvider extends ChangeNotifier {
  String? _currentUserId;
  String? _currentUserName;

  String? get currentUserId => _currentUserId;
  String? get currentUserName => _currentUserName;

  void setCurrentUser(String userId,String userName) {
    _currentUserId = userId;
    _currentUserName = userName;
    notifyListeners();
  }
}

class NotificationProvider extends ChangeNotifier {
  List<NotificationModel> _notifications = [];

  List<NotificationModel> get notifications => _notifications;

  void sendNotification(NotificationModel notification) {
    _notifications.add(notification);
    notifyListeners();
  }
}


