import 'package:get/get.dart';
import 'package:tasbeeh/features/history/repositories/history_repo.dart';
import '../models/history_entry.dart';

class HistoryController extends GetxController {
  final HistoryRepository repository;

  final RxList<HistoryEntry> entries = <HistoryEntry>[].obs;
  final RxBool isLoading = true.obs;
  final RxBool showOnlyCompleted = false.obs;

  HistoryController({required this.repository});

  @override
  void onInit() {
    super.onInit();
    loadHistory();
  }

  Future<void> loadHistory() async {
    isLoading.value = true;
    try {
      final list = await repository.getHistoryEntries();
      entries.assignAll(list);
    } catch (e) {
      print('Error loading history: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteEntry(String id) async {
    await repository.deleteHistoryEntry(id);
    entries.removeWhere((e) => e.id == id);
  }

  Future<void> syncFromFirestore() async {
    isLoading.value = true;
    try {
      await repository.syncFromFirestore();
      await loadHistory();
    } finally {
      isLoading.value = false;
    }
  }

  // Filtered entries based on filter
  List<HistoryEntry> get filteredEntries {
    if (showOnlyCompleted.value) {
      return entries.where((e) => e.isCompleted).toList();
    }
    return entries.toList();
  }

  // Group entries by section (Today, Yesterday, Last 7 Days, Older)
  Map<String, List<HistoryEntry>> get groupedEntries {
    final grouped = <String, List<HistoryEntry>>{};
    final today = <HistoryEntry>[];
    final yesterday = <HistoryEntry>[];
    final last7Days = <HistoryEntry>[];
    final older = <HistoryEntry>[];

    for (var entry in filteredEntries) {
      if (entry.isToday) {
        today.add(entry);
      } else if (entry.isYesterday) {
        yesterday.add(entry);
      } else if (entry.isLast7Days) {
        last7Days.add(entry);
      } else {
        older.add(entry);
      }
    }

    if (today.isNotEmpty) grouped['Today'] = today;
    if (yesterday.isNotEmpty) grouped['Yesterday'] = yesterday;
    if (last7Days.isNotEmpty) grouped['Last 7 Days'] = last7Days;
    if (older.isNotEmpty) grouped['Older'] = older;

    return grouped;
  }
}
