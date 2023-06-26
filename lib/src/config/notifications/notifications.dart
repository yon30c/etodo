import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart';

class LocalNotifications {
  static Future<void> requestPermission() async {
    final notificationsPlugin = FlutterLocalNotificationsPlugin();
    await notificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestPermission();
  }

  static Future<void> initializeNotification() async {
    final notificationPlugin = FlutterLocalNotificationsPlugin();

    const android = AndroidInitializationSettings('app_icon');

    // TODO: ios configuration

    // const InitializationSettings(android: android);

    notificationPlugin.initialize(
      const InitializationSettings(android: android),
      // onDidReceiveBackgroundNotificationResponse:
    );
  }

  static void showLocalNotification(
      {required int id,
      String? title,
      String? body,
      String? data,
      required TZDateTime scheduledDate}) async {
    const androidDetails = AndroidNotificationDetails(
        'channelId', 'channelName',
        playSound: true,
        // sound: RawResourceAndroidNotificationSound('notification'),
        importance: Importance.max,
        priority: Priority.high);
    const notificationDetails = NotificationDetails(
      android: androidDetails,
    );

    final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    await flutterLocalNotificationsPlugin.zonedSchedule(
        id, title, body, scheduledDate, notificationDetails,
        payload: data,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime);
  }
}
