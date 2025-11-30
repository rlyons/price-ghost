import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  final FirebaseMessaging _fm = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _local = FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    try {
      if (Platform.isAndroid || Platform.isIOS) {
        await Firebase.initializeApp();
      }
      await _fm.requestPermission(alert: true, announcement: false, badge: true, carPlay: false, criticalAlert: false, provisional: false, sound: true);
      // Android setup for local notifications
      const android = AndroidInitializationSettings('@mipmap/ic_launcher');
      const ios = DarwinInitializationSettings();
      await _local.initialize(const InitializationSettings(android: android, iOS: ios));

      // Setup foreground message handler
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        final notification = message.notification;
        if (notification != null) {
          _showLocalNotification(notification.title ?? 'Price Ghost', notification.body ?? 'New message');
        }
      });
    } catch (_) {
      // Running in test or unsupported environment; ignore
    }
  }

  Future<void> _showLocalNotification(String title, String body) async {
    const android = AndroidNotificationDetails('price_ghost_channel', 'Price Ghost Notifications', importance: Importance.max, priority: Priority.high);
    const ios = DarwinNotificationDetails();
    await _local.show(0, title, body, const NotificationDetails(android: android, iOS: ios));
  }
}
