import 'package:tasbeeh/features/statistics/models/static_summary.dart';

abstract class StatisticsRepository {
  Future<StatisticsSummary> getSummary();
  Future<List<ChartData>> getDailyCounts();
  Future<List<ChartData>> getWeeklyCounts();
  Future<List<ChartData>> getMonthlyCounts();
  Future<List<ChartData>> getYearlyCounts();
}
