import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class LocalNotificationsManager {
  static final FlutterLocalNotificationsPlugin
      _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  static Future<void> initialize() async {
    final AndroidInitializationSettings androidInitializationSettings =
        const AndroidInitializationSettings(
            'app_icon'); // Replace 'app_icon' with your app icon name

    final InitializationSettings initializationSettings =
        InitializationSettings(
      android: androidInitializationSettings,
    );

    await _flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  static Future<void> showNotification(
      String habitName, String habitTime) async {
    // Determine the time range for notifications based on habitTime
    DateTime now = DateTime.now();
    DateTime startTime;
    DateTime endTime;

    if (habitTime == 'Morning') {
      startTime = DateTime(now.year, now.month, now.day, 5, 0); // 5:00 AM
      endTime = DateTime(now.year, now.month, now.day, 7, 0); // 7:00 AM
    } else if (habitTime == 'Afternoon') {
      startTime = DateTime(now.year, now.month, now.day, 12, 0); // 12:00 PM
      endTime = DateTime(now.year, now.month, now.day, 14, 0); // 2:00 PM
    } else if (habitTime == 'Evening') {
      startTime = DateTime(now.year, now.month, now.day, 16, 0); // 4:00 PM
      endTime = DateTime(now.year, now.month, now.day, 17, 0); // 5:00 PM
    } else {
      return; // Invalid habitTime, do not schedule notification
    }

    // Check if the current time is within the specified range
    if (now.isAfter(startTime) && now.isBefore(endTime)) {
      const AndroidNotificationDetails androidPlatformChannelSpecifics =
          AndroidNotificationDetails(
        'your_channel_id', // Replace 'your_channel_id' with your desired channel ID
        'Your Channel Name', // Replace 'Your Channel Name' with your desired channel name
        // Replace 'Your Channel Description' with your desired channel description
        importance: Importance.max,
        priority: Priority.high,
      );

      const NotificationDetails platformChannelSpecifics =
          NotificationDetails(android: androidPlatformChannelSpecifics);

      await _flutterLocalNotificationsPlugin.show(
        0, // Notification ID, you can use a different number for each notification if needed
        'Hey, Reminder for your habit!', // Notification title
        'Habit Name: $habitName', // Notification message
        platformChannelSpecifics,
      );
    }
  }
}
