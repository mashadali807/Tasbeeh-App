import '../models/tasbeeh_session.dart';

abstract class TasbeehRepository {
  Future<void> saveSession(TasbeehSession session);
  Future<TasbeehSession?> getActiveSession();
  Future<TasbeehSession?> getSession(String id);
  Future<void> deleteSession(String id);
  Future<List<TasbeehSession>> getAllSessions();
  Future<void> vibrate();
  Future<void> playClickSound();
}
