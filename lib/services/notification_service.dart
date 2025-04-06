import 'package:flutter_local_notifications/flutter_local_notifications.dart'
    as notifications;
import '../models/task.dart';

class NotificationService {
  final notifications.FlutterLocalNotificationsPlugin _notificationsPlugin =
      notifications.FlutterLocalNotificationsPlugin();

  Future<void> initialize() async {
    const notifications.AndroidInitializationSettings
        initializationSettingsAndroid =
        notifications.AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );

    const notifications.InitializationSettings initializationSettings =
        notifications.InitializationSettings(
      android: initializationSettingsAndroid,
    );

    await _notificationsPlugin.initialize(initializationSettings);
  }

  Future<void> scheduleTaskNotification(Task task) async {
    if (task.dueDate == null || task.dueDate!.isBefore(DateTime.now())) {
      return;
    }

    notifications.AndroidNotificationDetails androidPlatformChannelSpecifics =
        const notifications.AndroidNotificationDetails(
      'task_channel',
      'Task Notifications',
      channelDescription: 'Notifications for upcoming tasks',
      importance: notifications.Importance.high,
      priority: notifications
          .Priority.high, // Using the notification package's Priority
    );

    notifications.NotificationDetails platformChannelSpecifics =
        notifications.NotificationDetails(
      android: androidPlatformChannelSpecifics,
    );

    await _notificationsPlugin.schedule(
      task.id.hashCode,
      'Task Due: ${task.title}',
      task.description ?? 'No description',
      task.dueDate!,
      platformChannelSpecifics,
    );
  }

  Future<void> cancelNotification(int id) async {
    await _notificationsPlugin.cancel(id);
  }
}

extension on notifications.FlutterLocalNotificationsPlugin {
  schedule(
    int hashCode,
    String s,
    String t,
    DateTime dateTime,
    notifications.NotificationDetails platformChannelSpecifics,
  ) {}
}
