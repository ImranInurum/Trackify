import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../utils/shared_preferences.dart';
import 'package:trackify/main.dart';
import 'package:trackify/feature/notifications/presentation/screen/notification_list_screen.dart';

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  if (message.notification != null) {
    return;
  }
  final plugin = FlutterLocalNotificationsPlugin();
  const android = AndroidNotificationDetails(
    NotificationService._androidChannelId,
    NotificationService._androidChannelName,
    channelDescription: NotificationService._androidChannelDesc,
    importance: Importance.max,
    priority: Priority.max,
  );
  const ios = DarwinNotificationDetails(
    presentAlert: true,
    presentBadge: true,
    presentSound: true,
  );
  const details = NotificationDetails(android: android, iOS: ios);
  final title = message.data['title'];
  final body = message.data['body'];
  if (title != null && body != null) {
    await plugin.show(DateTime.now().millisecondsSinceEpoch % 100000, title, body, details);
  }
}

class NotificationService {
  NotificationService._();
  static final FlutterLocalNotificationsPlugin _plugin = FlutterLocalNotificationsPlugin();

  static const _androidChannelId = 'trackify_reminders';
  static const _androidChannelName = 'Trackify Reminders';
  static const _androidChannelDesc = 'General app notifications';

  static Future<void> initialize() async {
    const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosInit = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );
    const initSettings = InitializationSettings(android: androidInit, iOS: iosInit);

    await _plugin.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        _navigateToNotificationScreen();
      },
    );

    // Ensure Android channel exists and request notifications permission (Android 13+)
    final androidPlugin = _plugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
    await androidPlugin?.createNotificationChannel(
      const AndroidNotificationChannel(
        _androidChannelId,
        _androidChannelName,
        description: _androidChannelDesc,
        importance: Importance.max,
      ),
    );
    await androidPlugin?.requestNotificationsPermission();

    // FCM setup: permissions, foreground presentation, listeners
    await FirebaseMessaging.instance.setAutoInitEnabled(true);
    await FirebaseMessaging.instance.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      provisional: false,
    );
    await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      debugPrint("Foreground message received: ${message.notification?.title}"); // ADD THIS
      final title = message.notification?.title ?? message.data['title'];
      final body = message.notification?.body ?? message.data['body'];
      if (title != null && body != null) {
        await _plugin.show(DateTime.now().millisecondsSinceEpoch % 100000, title, body, _details());
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      _navigateToNotificationScreen();
    });

    final initialMessage = await FirebaseMessaging.instance.getInitialMessage();
    if (initialMessage != null) {
      Future.delayed(const Duration(milliseconds: 1500), () {
        _navigateToNotificationScreen();
      });
    }

    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

    try {
      final token = await FirebaseMessaging.instance.getToken();
      if (token != null) {
        debugPrint('FCM TOKEN: $token');
        await AppPreference.instance.set(key: AppPreference.KEY_FCM_TOKEN, value: token);
      }
      FirebaseMessaging.instance.onTokenRefresh.listen((t) async {
        debugPrint('FCM TOKEN REFRESH: $t');
        await AppPreference.instance.set(key: AppPreference.KEY_FCM_TOKEN, value: t);
      });
    } on Exception catch (e) {
      debugPrint('FCM TOKEN ERROR: $e');
    }
  }

  static NotificationDetails _details() {
    const android = AndroidNotificationDetails(
      _androidChannelId,
      _androidChannelName,
      channelDescription: _androidChannelDesc,
      importance: Importance.max,
      priority: Priority.max,
    );
    const ios = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );
    return const NotificationDetails(android: android, iOS: ios);
  }

  static Future<void> showNow({required String title, required String body}) async {
    await _plugin.show(DateTime.now().millisecondsSinceEpoch % 100000, title, body, _details());
  }

  static Future<void> cancelAll() async {
    await _plugin.cancelAll();
  }

  static void _navigateToNotificationScreen() {
    if (rootNavigatorKey.currentState != null) {
      rootNavigatorKey.currentState!.push(
        MaterialPageRoute(builder: (_) => const NotificationListScreen()),
      );
    }
  }
}
