import 'package:tasbeeh/features/auth/controller/auth_controller.dart';
import 'package:tasbeeh/features/history/repositories/history_repo.dart';

import '../models/history_entry.dart';
import '../services/history_storage.dart';

class HistoryRepositoryImpl implements HistoryRepository {
  final HistoryStorage storage;
  final AuthController authController;

  HistoryRepositoryImpl({required this.storage, required this.authController});

  String get _userId {
    final user = authController.state.user;
    if (user == null) {
      throw Exception('User not authenticated');
    }
    return user.id;
  }

  @override
  Future<void> saveHistoryEntry(HistoryEntry entry) =>
      storage.saveHistoryEntry(_userId, entry);

  @override
  Future<List<HistoryEntry>> getHistoryEntries() => storage.getHistoryEntries();

  @override
  Future<void> deleteHistoryEntry(String id) =>
      storage.deleteHistoryEntry(_userId, id);

  @override
  Future<void> syncFromFirestore() => storage.syncFromFirestore(_userId);
}
