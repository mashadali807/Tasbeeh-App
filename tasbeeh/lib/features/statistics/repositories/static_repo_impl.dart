import 'package:tasbeeh/features/auth/controller/auth_controller.dart';
import 'package:tasbeeh/features/statistics/models/static_summary.dart';
import 'package:tasbeeh/features/statistics/repositories/static_repo.dart';
import 'package:tasbeeh/features/statistics/services/static_service.dart';

class StatisticsRepositoryImpl implements StatisticsRepository {
  final StatisticsService _service;
  final AuthController _authController;

  StatisticsRepositoryImpl({
    required StatisticsService service,
    required AuthController authController,
  }) : _service = service,
       _authController = authController;

  String get _userId {
    final user = _authController.state.user;
    if (user == null) throw Exception('User not authenticated');
    return user.id;
  }

  @override
  Future<StatisticsSummary> getSummary() async {
    // We need to pass userId to the service; we'll store it in a private getter.
    // The service can use the repository to get history entries, etc.
    // Instead, we'll make the service methods accept userId.
    // Since we have HistoryRepository, we can directly access it inside the service.
    // For simplicity, we'll refactor the service to accept userId.
    // I'll update the service class to accept userId.
    // I'll show the updated service below.
    // Actually we can just create a new instance of StatisticsService with dependencies.
    // But we already have it as a dependency.
    // The easiest: pass userId to service methods.
    // Let's modify the service methods to accept userId.
    // I'll adjust the code accordingly.
    return await _service.getSummary(_userId);
  }

  @override
  Future<List<ChartData>> getDailyCounts() => _service.getDailyCounts(_userId);

  @override
  Future<List<ChartData>> getWeeklyCounts() =>
      _service.getWeeklyCounts(_userId);

  @override
  Future<List<ChartData>> getMonthlyCounts() =>
      _service.getMonthlyCounts(_userId);

  @override
  Future<List<ChartData>> getYearlyCounts() =>
      _service.getYearlyCounts(_userId);
}
