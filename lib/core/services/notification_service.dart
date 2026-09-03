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
  
  final channelId = message.data['android_channel_id'] ?? NotificationService.androidChannelId;
  AndroidNotificationSound? androidSound;
  String? iosSound;
  
  if (channelId == 'motion_alerts') {
    androidSound = const RawResourceAndroidNotificationSound('motion_alert');
    iosSound = 'motion_alert.mp3';
  }

  final android = AndroidNotificationDetails(
    channelId,
    channelId.replaceAll('_', ' ').toUpperCase(),
    importance: Importance.max,
    priority: Priority.max,
    playSound: true,
    sound: androidSound,
    icon: '@drawable/ic_notification',
    color: const Color(0xFF0284C7),
  );
  
  final ios = DarwinNotificationDetails(
    presentAlert: true,
    presentBadge: true,
    presentSound: true,
    sound: iosSound,
  );
  final details = NotificationDetails(android: android, iOS: ios);
  final title = message.data['title'];
  final body = message.data['body'];
  if (title != null && body != null) {
    await plugin.show(DateTime.now().millisecondsSinceEpoch % 100000, title, body, details);
  }
}

class NotificationService {
  NotificationService._();
  static final FlutterLocalNotificationsPlugin _plugin = FlutterLocalNotificationsPlugin();

  static const androidChannelId = 'trackify_reminders';
  static const _androidChannelName = 'Trackify Reminders';
  static const _androidChannelDesc = 'General app notifications';

  // Recording session notification constants
  static const _recordingChannelId = 'recording_session';
  static const _recordingChannelName = 'Recording Session';
  static const _recordingNotificationId = 9999;

  static Future<void> initialize() async {
    const androidInit = AndroidInitializationSettings('@drawable/ic_notification');
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

    // Ensure Android channels exist and request notifications permission (Android 13+)
    final androidPlugin = _plugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
    
    // Create multiple channels for specific alerts
    final channels = [
      const AndroidNotificationChannel(androidChannelId, _androidChannelName, description: _androidChannelDesc, importance: Importance.max),
      const AndroidNotificationChannel('vibration_alerts', 'Vibration alerts', description: 'Notifications for Vibration Alerts', importance: Importance.max),
      const AndroidNotificationChannel(
        'motion_alerts', 
        'Motion alerts', 
        description: 'Notifications for Motion Detected Alerts', 
        importance: Importance.max,
        playSound: true,
        sound: RawResourceAndroidNotificationSound('motion_alert'),
      ),
      const AndroidNotificationChannel('ignition_alerts', 'Ignition alerts', description: 'Notifications for Ignition Alerts', importance: Importance.max),
      const AndroidNotificationChannel('fall_alerts', 'Fall alerts', description: 'Notifications for Fall Alerts', importance: Importance.max),
      const AndroidNotificationChannel('battery_alerts', 'Battery alerts', description: 'Notifications for Battery Alerts', importance: Importance.max),
      const AndroidNotificationChannel('geofence_alerts', 'Geofence alerts', description: 'Notifications for Geofence Alerts', importance: Importance.max),
      const AndroidNotificationChannel('speed_alerts', 'Speed alerts', description: 'Notifications for Speed Alerts', importance: Importance.max),
      const AndroidNotificationChannel('other_alerts', 'Other alerts', description: 'General Notifications', importance: Importance.max),
      const AndroidNotificationChannel('custom_notifications', 'Custom notifications', description: 'Custom App Notifications', importance: Importance.max),
      const AndroidNotificationChannel(
        _recordingChannelId,
        _recordingChannelName,
        description: 'Shows live recording timer while phone GPS is active',
        importance: Importance.low,
        playSound: false,
        enableVibration: false,
      ),
    ];

    for (var channel in channels) {
      await androidPlugin?.createNotificationChannel(channel);
    }
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
        await _plugin.show(DateTime.now().millisecondsSinceEpoch % 100000, title, body, _detailsForMessage(message));
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

  static NotificationDetails _detailsForMessage(RemoteMessage message) {
    final channelId = message.notification?.android?.channelId ?? message.data['android_channel_id'] ?? androidChannelId;
    
    AndroidNotificationSound? androidSound;
    String? iosSound;
    
    if (channelId == 'motion_alerts') {
      androidSound = const RawResourceAndroidNotificationSound('motion_alert');
      iosSound = 'motion_alert.mp3';
    }

    final android = AndroidNotificationDetails(
      channelId,
      channelId.replaceAll('_', ' ').toUpperCase(),
      importance: Importance.max,
      priority: Priority.max,
      playSound: true,
      sound: androidSound,
      icon: '@drawable/ic_notification',
      color: const Color(0xFF0284C7),
    );
    
    final ios = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
      sound: iosSound,
    );
    return NotificationDetails(android: android, iOS: ios);
  }

  static NotificationDetails _details() {
    const android = AndroidNotificationDetails(
      androidChannelId,
      _androidChannelName,
      channelDescription: _androidChannelDesc,
      importance: Importance.max,
      priority: Priority.max,
      icon: '@drawable/ic_notification',
      color: Color(0xFF0284C7),
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

  /// Shows (or updates) a persistent recording notification with a live elapsed timer.
  static Future<void> showRecordingNotification(Duration elapsed) async {
    final hours = elapsed.inHours;
    final minutes = elapsed.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = elapsed.inSeconds.remainder(60).toString().padLeft(2, '0');
    final timeStr = hours > 0
        ? '${hours.toString().padLeft(2, '0')}:$minutes:$seconds'
        : '$minutes:$seconds';

    const android = AndroidNotificationDetails(
      _recordingChannelId,
      _recordingChannelName,
      channelDescription: 'Shows live recording timer while phone GPS is active',
      importance: Importance.low,
      priority: Priority.low,
      ongoing: true,             // Cannot be swiped away
      autoCancel: false,
      playSound: false,
      enableVibration: false,
      icon: '@drawable/ic_notification',
      color: Color(0xFF0284C7),
      showWhen: false,
    );
    const ios = DarwinNotificationDetails(
      presentAlert: false,
      presentBadge: false,
      presentSound: false,
    );
    await _plugin.show(
      _recordingNotificationId,
      '📍 Recording Started',
      'Recording in progress • $timeStr',
      const NotificationDetails(android: android, iOS: ios),
    );
  }

  /// Cancels the recording session notification.
  static Future<void> cancelRecordingNotification() async {
    await _plugin.cancel(_recordingNotificationId);
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
