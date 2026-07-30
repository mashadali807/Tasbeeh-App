import 'dart:convert';
import 'package:hive/hive.dart';
import '../models/tasbeeh_session.dart';

class TasbeehStorageService {
  static const String _boxName = 'tasbeeh_sessions';

  // Open box with String values (we store JSON strings)
  Future<Box<String>> _openBox() async {
    return await Hive.openBox<String>(_boxName);
  }

  // Save or update a session
  Future<void> saveSession(TasbeehSession session) async {
    final box = await _openBox();
    final jsonString = jsonEncode(session.toJson());
    await box.put(session.id, jsonString);
  }

  // Get a session by ID
  Future<TasbeehSession?> getSession(String id) async {
    final box = await _openBox();
    final jsonString = box.get(id);
    if (jsonString == null) return null;
    try {
      final Map<String, dynamic> data = jsonDecode(jsonString);
      return TasbeehSession.fromJson(data);
    } catch (e) {
      return null;
    }
  }

  // Get the most recent active session (not completed)
  Future<TasbeehSession?> getActiveSession() async {
    final box = await _openBox();
    final allSessions = <TasbeehSession>[];
    for (var key in box.keys) {
      final jsonString = box.get(key);
      if (jsonString != null) {
        try {
          final data = jsonDecode(jsonString);
          final session = TasbeehSession.fromJson(data);
          allSessions.add(session);
        } catch (e) {
          // skip invalid entries
        }
      }
    }

    // Filter active sessions (not completed)
    final activeSessions = allSessions
        .where((session) => !session.isCompleted)
        .toList();
    if (activeSessions.isEmpty) return null;
    // Sort by lastUpdatedAt or startedAt, get the latest
    activeSessions.sort((a, b) {
      final aTime = a.lastUpdatedAt ?? a.startedAt;
      final bTime = b.lastUpdatedAt ?? b.startedAt;
      return bTime.compareTo(aTime);
    });
    return activeSessions.first;
  }

  // Delete a session
  Future<void> deleteSession(String id) async {
    final box = await _openBox();
    await box.delete(id);
  }

  // Get all sessions (for history)
  Future<List<TasbeehSession>> getAllSessions() async {
    final box = await _openBox();
    final sessions = <TasbeehSession>[];
    for (var key in box.keys) {
      final jsonString = box.get(key);
      if (jsonString != null) {
        try {
          final data = jsonDecode(jsonString);
          sessions.add(TasbeehSession.fromJson(data));
        } catch (e) {
          // skip invalid entries
        }
      }
    }
    // Optionally sort by date descending
    sessions.sort((a, b) => b.startedAt.compareTo(a.startedAt));
    return sessions;
  }
}
