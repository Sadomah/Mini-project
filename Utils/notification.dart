import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:timezone/data/latest.dart' as timezone;
import 'package:timezone/timezone.dart' as timezzone;
import 'package:utils/imports.dart'; 

class NotificationService {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  NotificationService();

  Future<void> init() async {
    final String currentTimeZone =
        await FlutterNativeTimezone.getLocalTimezone();
    timezone.initializeTimeZones();
    timezzone.setLocalLocation(timezzone.getLocation(currentTimeZone));

    AndroidInitializationSettings androidInitializationSettings =
        AndroidInitializationSettings('@mipmap/ic_notification');

    IOSInitializationSettings iosInitializationSettings =
        IOSInitializationSettings();

    InitializationSettings initializationSettings = InitializationSettings(
      android: androidInitializationSettings,
      iOS: iosInitializationSettings,
    );

    flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  AndroidNotificationDetails getAndroidNotificationDetails() {
    return AndroidNotificationDetails(
      'reminder',
      'Reminder Notification',
      'Notification sent as a reminder', 
      importance: Importance.max,
      priority: Priority.high,
      enableVibration: true,
      category: 'reminder',
      icon: '@mipmap/ic_notification',
      groupKey: 'com.project.upcomingevent.HelpingHand',
    );
  }

  IOSNotificationDetails getIosNotificationDetails() {
    return IOSNotificationDetails();
  }

  NotificationDetails getNotificationDetails() {
    return NotificationDetails(
      android: getAndroidNotificationDetails(),
      iOS: getIosNotificationDetails(),
    );
  }

  Future<void> scheduleNotification(Event event) async {
    if (event.dateTime != null) {
      flutterLocalNotificationsPlugin.zonedSchedule(
        event.id,
        event.name,
        event.time,
        notificationTime(event.date),
        getNotificationDetails(),
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        androidAllowWhileIdle: true,
      );
      print('Notification set at ${event.dateTime}');
    } else {
      return;
    }
  }

  Future<bool> eventHasNotification(Event event) async {
    var pendingNotifications =
        await flutterLocalNotificationsPlugin.pendingNotificationRequests();
    return pendingNotifications.any((notification) => notification.id == event.id);
  }

  void updateNotification(Event event) async {
    var hasNotification = await eventHasNotification(event);
    if (hasNotification) {
      flutterLocalNotificationsPlugin.cancel(event.id);
    }

    scheduleNotification(event);
  }

  void cancelNotification(int id) {
    flutterLocalNotificationsPlugin.cancel(id);
    print('$id canceled');
  }

  timezzone.TZDateTime notificationTime(DateTime dateTime) {
    return timezzone.TZDateTime(
      timezone.local,
      dateTime.year,
      dateTime.month,
      dateTime.day,
      dateTime.hour,
      dateTime.minute,
      dateTime.second,
    );
  }
}
