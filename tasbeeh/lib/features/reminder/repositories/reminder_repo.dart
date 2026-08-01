import '../models/reminder_model.dart';

abstract class RemindersRepository {
  Future<List<Reminder>> getReminders();
  Future<void> saveReminder(Reminder reminder);
  Future<void> deleteReminder(String id);
  Future<void> toggleReminder(String id, bool enabled);
  Future<void> clearAllReminders();
}
