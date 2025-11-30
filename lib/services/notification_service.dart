import 'package:firebase_messaging/firebase_messaging.dart';

class NotificationService {
  final FirebaseMessaging _fm = FirebaseMessaging.instance;

  Future<void> init() async {
    try {
      // Request permissions
      await _fm.requestPermission();
    } catch (_) {
      // Running in test or unsupported environment; ignore
    }
    // Subscribe to a default topic or configure handlers
    // This is a placeholder: configure background handlers in the app entry point
  }
}
