import 'package:get/get.dart';
import 'package:tasbeeh/features/prayer_time/controller/prayer_times_controller.dart';
import 'package:tasbeeh/features/reminder/repositories/reminder_repo.dart';
import 'package:tasbeeh/features/reminder/services/reminder_schedule.dart';
import '../../prayer_time/models/prayer_time.dart';
import '../models/reminder_model.dart';

import '../services/notification_service.dart';

class RemindersController extends GetxController {
  final RemindersRepository repository;

  final RxList<Reminder> reminders = <Reminder>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool notificationsEnabled = true.obs;

  // Pre-defined default reminders
  final List<Reminder> defaultReminders = [
    Reminder(
      id: 'morning_adhkar',
      title: 'Morning Adhkar',
      body: 'Time to recite your morning adhkar! 🌅',
      type: ReminderType.morningAdhkar,
      time: DateTime(
        DateTime.now().year,
        DateTime.now().month,
        DateTime.now().day,
        6,
        0,
      ),
      daysOfWeek: [1, 2, 3, 4, 5, 6, 7],
      isEnabled: false,
    ),
    Reminder(
      id: 'evening_adhkar',
      title: 'Evening Adhkar',
      body: 'Time to recite your evening adhkar! 🌙',
      type: ReminderType.eveningAdhkar,
      time: DateTime(
        DateTime.now().year,
        DateTime.now().month,
        DateTime.now().day,
        18,
        0,
      ),
      daysOfWeek: [1, 2, 3, 4, 5, 6, 7],
      isEnabled: false,
    ),
    Reminder(
      id: 'daily_goal',
      title: 'Daily Dhikr Goal',
      body: 'Have you completed your daily Dhikr goal today? 📿',
      type: ReminderType.dailyGoal,
      time: DateTime(
        DateTime.now().year,
        DateTime.now().month,
        DateTime.now().day,
        21,
        0,
      ),
      daysOfWeek: [1, 2, 3, 4, 5, 6, 7],
      isEnabled: false,
    ),
  ];

  RemindersController({required this.repository});

  @override
  void onInit() {
    super.onInit();
    loadReminders();
  }

  Future<void> loadReminders() async {
    isLoading.value = true;
    try {
      final loaded = await repository.getReminders();
      if (loaded.isEmpty) {
        for (var reminder in defaultReminders) {
          await repository.saveReminder(reminder);
        }
        reminders.assignAll(defaultReminders);
      } else {
        reminders.assignAll(loaded);
      }
      // ✅ Schedule all active reminders
      await ReminderScheduler.scheduleAllReminders(reminders);
      // Also sync prayer time reminders (if possible)
      await _syncPrayerTimeReminders();
    } catch (e) {
      print('Error loading reminders: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _syncPrayerTimeReminders() async {
    try {
      // Get current prayer times from the prayer times controller
      final prayerController = Get.find<PrayerTimesController>();
      await prayerController.loadPrayerTimes(forceRefresh: true);
      final data = prayerController.prayerTimes.value;
      if (data == null) return;

      final prayerNames = [
        'Fajr',
        'Sunrise',
        'Dhuhr',
        'Asr',
        'Maghrib',
        'Isha',
      ];
      final existingPrayerReminders = reminders
          .where((r) => r.type == ReminderType.prayerTime)
          .toList();

      // Remove old prayer reminders (we'll recreate them with updated times)
      for (var r in existingPrayerReminders) {
        await ReminderScheduler.cancelReminder(r);

        await repository.deleteReminder(r.id);

        reminders.remove(r);
      }

      // Create new prayer reminders
      for (int i = 0; i < data.prayers.length; i++) {
        final prayer = data.prayers[i];
        final reminder = Reminder(
          id: 'prayer_${prayer.name}_${DateTime.now().millisecondsSinceEpoch}',
          title: '${prayer.name} Prayer Time',
          body:
              'It\'s time for ${prayer.name} prayer. 🕌 May Allah accept your prayers.',
          type: ReminderType.prayerTime,
          time: prayer.time,
          daysOfWeek: [1, 2, 3, 4, 5, 6, 7],
          isEnabled: true, // enabled by default
          prayerIndex: i,
        );
        await repository.saveReminder(reminder);
        reminders.add(reminder);
      }
    } catch (e) {
      print('Error syncing prayer time reminders: $e');
    }
  }

  Future<void> toggleReminder(String id) async {
    final index = reminders.indexWhere((r) => r.id == id);

    if (index == -1) return;

    final current = reminders[index];

    final newEnabled = !current.isEnabled;

    await repository.toggleReminder(id, newEnabled);

    final updatedReminder = current.copyWith(isEnabled: newEnabled);

    final newList = List<Reminder>.from(reminders)..[index] = updatedReminder;

    reminders.value = newList;

    // IMPORTANT:
    // Actually schedule/cancel the notification.
    if (newEnabled) {
      await ReminderScheduler.scheduleReminder(updatedReminder);
    } else {
      await ReminderScheduler.cancelReminder(updatedReminder);
    }
  }

  Future<void> addCustomReminder(Reminder reminder) async {
    await repository.saveReminder(reminder);
    reminders.add(reminder);
    reminders.refresh();
  }

  // Add these methods if missing

  Future<void> deleteReminder(String id) async {
    await repository.deleteReminder(id);
    reminders.removeWhere((r) => r.id == id);
    reminders.refresh();
  }

  Future<void> editReminder(Reminder reminder) async {
    await repository.saveReminder(reminder);
    reminders.add(reminder);

    await ReminderScheduler.scheduleReminder(reminder);
    final index = reminders.indexWhere((r) => r.id == reminder.id);
    if (index != -1) {
      reminders[index] = reminder;
      reminders.refresh();
    }
    // Reschedule after edit
    await ReminderScheduler.rescheduleReminder(reminder);
  }

  Future<void> requestNotificationPermissions() async {
    await NotificationService.requestPermissions();
  }

  // Call this when prayer times change (e.g., location change)
  Future<void> refreshPrayerReminders() async {
    await _syncPrayerTimeReminders();
  }
}
