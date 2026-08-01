import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  static final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  static const String _channelId = 'dhikr_companion_channel';
  static const String _channelName = 'Dhikr Companion Notifications';
  static const String _channelDescription =
      'Reminders for Adhkar, Prayer Times, and Goals';

  // ============================================================
  // INITIALIZE
  // ============================================================

  static Future<void> initialize() async {
    tz.initializeTimeZones();

    // Pakistan timezone
    try {
      tz.setLocalLocation(tz.getLocation('Asia/Karachi'));
    } catch (e) {
      // Keep timezone package default if unavailable
    }

    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings iosSettings =
        DarwinInitializationSettings(
          requestAlertPermission: true,
          requestBadgePermission: true,
          requestSoundPermission: true,
        );

    const InitializationSettings settings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _plugin.initialize(settings: settings);

    await _createNotificationChannel();
  }

  // ============================================================
  // CREATE ANDROID CHANNEL
  // ============================================================

  static Future<void> _createNotificationChannel() async {
    final androidPlugin = _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();

    if (androidPlugin == null) return;

    const channel = AndroidNotificationChannel(
      _channelId,
      _channelName,
      description: _channelDescription,
      importance: Importance.high,
      enableVibration: true,
      playSound: true,
    );

    await androidPlugin.createNotificationChannel(channel);
  }

  // ============================================================
  // REQUEST PERMISSIONS
  // ============================================================

  static Future<void> requestPermissions() async {
    final androidPlugin = _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();

    if (androidPlugin == null) return;

    // Android 13+
    await androidPlugin.requestNotificationsPermission();

    // Android 12+
    await androidPlugin.requestExactAlarmsPermission();
  }

  // ============================================================
  // SHOW INSTANT NOTIFICATION
  // ============================================================

  static Future<void> showInstantNotification({
    required int id,
    required String title,
    required String body,
    String? payload,
  }) async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
          _channelId,
          _channelName,
          channelDescription: _channelDescription,
          importance: Importance.high,
          priority: Priority.high,
          playSound: true,
        );

    const DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const NotificationDetails details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _plugin.show(
      id: id,
      title: title,
      body: body,
      notificationDetails: details,
      payload: payload,
    );
  }

  // ============================================================
  // SCHEDULE NOTIFICATION
  // ============================================================

  static Future<void> scheduleNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledTime,
    required List<int> daysOfWeek,
    String? payload,
  }) async {
    final days = daysOfWeek.isEmpty ? [1, 2, 3, 4, 5, 6, 7] : daysOfWeek;

    final now = tz.TZDateTime.now(tz.local);

    for (final day in days) {
      if (day < 1 || day > 7) {
        continue;
      }

      // Create today's date using the requested time.
      tz.TZDateTime scheduledDate = tz.TZDateTime(
        tz.local,
        now.year,
        now.month,
        now.day,
        scheduledTime.hour,
        scheduledTime.minute,
      );

      // Move to requested weekday.
      int daysUntilTarget = day - scheduledDate.weekday;

      if (daysUntilTarget < 0) {
        daysUntilTarget += 7;
      }

      scheduledDate = scheduledDate.add(Duration(days: daysUntilTarget));

      // If today's occurrence has already passed,
      // move it to next week.
      if (!scheduledDate.isAfter(now)) {
        scheduledDate = scheduledDate.add(const Duration(days: 7));
      }

      // IMPORTANT:
      // Base ID + weekday creates a unique notification.
      final uniqueId = id + day;

      const AndroidNotificationDetails androidDetails =
          AndroidNotificationDetails(
            _channelId,
            _channelName,
            channelDescription: _channelDescription,
            importance: Importance.high,
            priority: Priority.high,
            playSound: true,
          );

      const DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      );

      const NotificationDetails details = NotificationDetails(
        android: androidDetails,
        iOS: iosDetails,
      );

      try {
        await _plugin.zonedSchedule(
          id: uniqueId,
          title: title,
          body: body,
          scheduledDate: scheduledDate,
          notificationDetails: details,
          androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,

          // IMPORTANT:
          // This makes it weekly on the selected weekday.
          matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime,

          payload: payload,
        );

        print(
          'Notification scheduled: '
          '$title | $scheduledDate | ID: $uniqueId',
        );
      } catch (e) {
        print('Failed to schedule notification: $e');

        // Try inexact scheduling if exact alarm
        // permission is unavailable.
        if (e.toString().contains('exact_alarms_not_permitted')) {
          await _plugin.zonedSchedule(
            id: uniqueId,
            title: title,
            body: body,
            scheduledDate: scheduledDate,
            notificationDetails: details,
            androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
            matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime,
            payload: payload,
          );
        } else {
          rethrow;
        }
      }
    }
  }

  // ============================================================
  // CANCEL ONE REMINDER
  // ============================================================

  static Future<void> cancelNotification(int baseId) async {
    for (int day = 1; day <= 7; day++) {
      await _plugin.cancel(id: baseId + day);
    }
  }

  // ============================================================
  // CANCEL ALL
  // ============================================================

  static Future<void> cancelAllNotifications() async {
    await _plugin.cancelAll();
  }
}
