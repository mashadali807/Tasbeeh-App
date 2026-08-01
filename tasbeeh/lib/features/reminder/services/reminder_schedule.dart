import '../models/reminder_model.dart';
import 'notification_service.dart';

class ReminderScheduler {
  static int getNotificationId(String reminderId) {
    return reminderId.hashCode.abs() % 100000;
  }

  static Future<void> scheduleReminder(Reminder reminder) async {
    if (!reminder.isEnabled) return;

    final days = reminder.type == ReminderType.prayerTime
        ? [1, 2, 3, 4, 5, 6, 7]
        : reminder.daysOfWeek;

    final notificationId = getNotificationId(reminder.id);

    await NotificationService.cancelNotification(notificationId);

    await NotificationService.scheduleNotification(
      id: notificationId,
      title: reminder.title,
      body: reminder.body,
      scheduledTime: reminder.time,
      daysOfWeek: days,
      payload: reminder.id,
    );
  }

  static Future<void> cancelReminder(Reminder reminder) async {
    final notificationId = getNotificationId(reminder.id);

    await NotificationService.cancelNotification(notificationId);
  }

  static Future<void> scheduleAllReminders(List<Reminder> reminders) async {
    for (final reminder in reminders) {
      if (reminder.isEnabled) {
        await scheduleReminder(reminder);
      }
    }
  }

  static Future<void> cancelAllReminders() async {
    await NotificationService.cancelAllNotifications();
  }

  static Future<void> rescheduleReminder(Reminder reminder) async {
    await cancelReminder(reminder);

    if (reminder.isEnabled) {
      await scheduleReminder(reminder);
    }
  }
}
