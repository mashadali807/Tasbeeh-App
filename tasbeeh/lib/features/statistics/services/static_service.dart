import 'package:tasbeeh/features/history/repositories/history_repo.dart';
import 'package:tasbeeh/features/home/services/progress_services.dart';
import 'package:tasbeeh/features/statistics/models/static_summary.dart';

import '../../history/models/history_entry.dart';

class StatisticsService {
  final HistoryRepository _historyRepository;
  final ProgressService _progressService;

  StatisticsService({
    required HistoryRepository historyRepository,
    required ProgressService progressService,
  }) : _historyRepository = historyRepository,
       _progressService = progressService;

  Future<StatisticsSummary> getSummary(String userId) async {
    final entries = await _historyRepository.getHistoryEntries();
    final streak = await _progressService.getStreak(userId);
    final freq = <String, int>{};
    int total = 0;
    for (var e in entries) {
      total += e.count;
      freq[e.dhikrName] = (freq[e.dhikrName] ?? 0) + e.count;
    }
    String favorite = 'N/A';
    int maxCount = 0;
    freq.forEach((name, count) {
      if (count > maxCount) {
        maxCount = count;
        favorite = name;
      }
    });
    return StatisticsSummary(
      totalCount: total,
      favoriteDhikr: favorite,
      favoriteCount: maxCount,
      longestStreak: streak,
    );
  }

  Future<List<ChartData>> getDailyCounts(String userId, {int days = 30}) async {
    final entries = await _historyRepository.getHistoryEntries();
    final now = DateTime.now();
    final result = <ChartData>[];
    for (int i = days - 1; i >= 0; i--) {
      final date = now.subtract(Duration(days: i));
      final dateStr = '${date.day}/${date.month}';
      final dailyTotal = entries
          .where(
            (e) =>
                e.startedAt.year == date.year &&
                e.startedAt.month == date.month &&
                e.startedAt.day == date.day,
          )
          .fold<int>(0, (sum, e) => sum + e.count);
      result.add(ChartData(dateStr, dailyTotal));
    }
    return result;
  }

  Future<List<ChartData>> getWeeklyCounts(
    String userId, {
    int weeks = 8,
  }) async {
    final entries = await _historyRepository.getHistoryEntries();
    final now = DateTime.now();
    final result = <ChartData>[];
    for (int i = weeks - 1; i >= 0; i--) {
      final start = now.subtract(Duration(days: i * 7));
      final end = start.add(const Duration(days: 6));
      final weekLabel = 'W${i + 1}';
      final weeklyTotal = entries
          .where(
            (e) =>
                e.startedAt.isAfter(start.subtract(const Duration(days: 1))) &&
                e.startedAt.isBefore(end.add(const Duration(days: 1))),
          )
          .fold<int>(0, (sum, e) => sum + e.count);
      result.add(ChartData(weekLabel, weeklyTotal));
    }
    return result;
  }

  Future<List<ChartData>> getMonthlyCounts(
    String userId, {
    int months = 12,
  }) async {
    final entries = await _historyRepository.getHistoryEntries();
    final now = DateTime.now();
    final result = <ChartData>[];
    for (int i = months - 1; i >= 0; i--) {
      final date = DateTime(now.year, now.month - i, 1);
      final monthLabel = '${date.month}/${date.year}';
      final monthlyTotal = entries
          .where(
            (e) =>
                e.startedAt.year == date.year &&
                e.startedAt.month == date.month,
          )
          .fold<int>(0, (sum, e) => sum + e.count);
      result.add(ChartData(monthLabel, monthlyTotal));
    }
    return result;
  }

  Future<List<ChartData>> getYearlyCounts(
    String userId, {
    int years = 5,
  }) async {
    final entries = await _historyRepository.getHistoryEntries();
    final now = DateTime.now();
    final result = <ChartData>[];
    for (int i = years - 1; i >= 0; i--) {
      final year = now.year - i;
      final yearLabel = year.toString();
      final yearlyTotal = entries
          .where((e) => e.startedAt.year == year)
          .fold<int>(0, (sum, e) => sum + e.count);
      result.add(ChartData(yearLabel, yearlyTotal));
    }
    return result;
  }
}
