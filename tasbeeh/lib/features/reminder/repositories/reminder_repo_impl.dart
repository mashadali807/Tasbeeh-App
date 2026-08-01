import 'package:tasbeeh/features/reminder/repositories/reminder_repo.dart';
import 'package:tasbeeh/features/reminder/services/reminder_schedule.dart';

import '../models/reminder_model.dart';
import '../services/reminder_storage.dart';

class RemindersRepositoryImpl implements RemindersRepository {
  final ReminderStorage _storage;

  RemindersRepositoryImpl({required ReminderStorage storage})
    : _storage = storage;

  @override
  Future<List<Reminder>> getReminders() => _storage.getReminders();

  @override
  Future<void> saveReminder(Reminder reminder) async {
    await _storage.saveReminder(reminder);
    await ReminderScheduler.scheduleReminder(reminder);
  }

  @override
  Future<void> deleteReminder(String id) async {
    final reminders = await getReminders();
    final reminder = reminders.firstWhere((r) => r.id == id);
    await ReminderScheduler.cancelReminder(reminder);
    await _storage.deleteReminder(id);
  }

  @override
  Future<void> toggleReminder(String id, bool enabled) async {
    final reminders = await getReminders();
    final index = reminders.indexWhere((r) => r.id == id);
    if (index == -1) return;

    final updated = reminders[index].copyWith(isEnabled: enabled);
    await _storage.saveReminder(updated);
    if (enabled) {
      await ReminderScheduler.scheduleReminder(updated);
    } else {
      await ReminderScheduler.cancelReminder(updated);
    }
  }

  @override
  Future<void> clearAllReminders() async {
    await ReminderScheduler.cancelAllReminders();
    await _storage.clearAll();
  }
}
