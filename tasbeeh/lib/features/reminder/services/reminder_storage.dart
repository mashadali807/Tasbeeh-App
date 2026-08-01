import 'dart:convert';
import 'package:hive/hive.dart';
import '../models/reminder_model.dart';

class ReminderStorage {
  static const String _boxName = 'reminders';

  Future<Box<String>> _openBox() async {
    return await Hive.openBox<String>(_boxName);
  }

  Future<void> saveReminder(Reminder reminder) async {
    final box = await _openBox();
    await box.put(reminder.id, jsonEncode(reminder.toJson()));
  }

  Future<List<Reminder>> getReminders() async {
    final box = await _openBox();
    final list = <Reminder>[];
    for (var key in box.keys) {
      final jsonStr = box.get(key);
      if (jsonStr != null) {
        try {
          final data = jsonDecode(jsonStr);
          list.add(Reminder.fromJson(data));
        } catch (_) {}
      }
    }
    return list;
  }

  Future<void> deleteReminder(String id) async {
    final box = await _openBox();
    await box.delete(id);
  }

  Future<void> clearAll() async {
    final box = await _openBox();
    await box.clear();
  }
}
