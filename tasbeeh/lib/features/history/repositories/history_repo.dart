import '../models/history_entry.dart';

abstract class HistoryRepository {
  Future<void> saveHistoryEntry(HistoryEntry entry);
  Future<List<HistoryEntry>> getHistoryEntries();
  Future<void> deleteHistoryEntry(String id);
  Future<void> syncFromFirestore();
}
