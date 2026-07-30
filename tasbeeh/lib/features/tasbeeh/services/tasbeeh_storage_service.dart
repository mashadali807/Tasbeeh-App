import 'package:hive/hive.dart';
import '../models/tasbeeh_session.dart';

class TasbeehStorageService {
  static const String _boxName = 'tasbeeh_sessions';

  Future<Box<TasbeehSession>> _openBox() async {
    return await Hive.openBox<TasbeehSession>(_boxName);
  }

  // Save or update a session
  Future<void> saveSession(TasbeehSession session) async {
    final box = await _openBox();
    await box.put(session.id, session);
  }

  // Get a session by ID
  Future<TasbeehSession?> getSession(String id) async {
    final box = await _openBox();
    return box.get(id);
  }

  // Get the most recent active session (not completed)
  Future<TasbeehSession?> getActiveSession() async {
    final box = await _openBox();
    final allSessions = box.values.toList();
    // Find the most recent session that is not completed
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
    return box.values.toList();
  }
}
