import 'package:get/get.dart';
import 'package:tasbeeh/features/auth/controller/auth_controller.dart';
import 'package:tasbeeh/features/statistics/controller/statistics_controller.dart';
import 'package:tasbeeh/features/statistics/repositories/static_repo.dart';
import 'package:tasbeeh/features/statistics/repositories/static_repo_impl.dart';
import 'package:tasbeeh/features/statistics/services/static_service.dart';
import '../../history/repositories/history_repo.dart';
import '../../history/repositories/history_repo_impl.dart';
import '../../history/services/history_storage.dart';
import '../../home/services/progress_services.dart';

class StatisticsBinding extends Bindings {
  @override
  void dependencies() {
    // Register History dependencies (if not already registered)
    Get.lazyPut<HistoryStorage>(() => HistoryStorage());
    Get.lazyPut<HistoryRepository>(
      () => HistoryRepositoryImpl(
        storage: Get.find<HistoryStorage>(),
        authController: Get.find<AuthController>(),
      ),
    );

    // Register ProgressService (if not already registered)
    Get.lazyPut<ProgressService>(() => ProgressService());

    // Register StatisticsService using the dependencies above
    Get.lazyPut<StatisticsService>(
      () => StatisticsService(
        historyRepository: Get.find<HistoryRepository>(),
        progressService: Get.find<ProgressService>(),
      ),
    );

    // Register StatisticsRepository
    Get.lazyPut<StatisticsRepository>(
      () => StatisticsRepositoryImpl(
        service: Get.find<StatisticsService>(),
        authController: Get.find<AuthController>(),
      ),
    );

    // Register StatisticsController
    Get.lazyPut<StatisticsController>(
      () => StatisticsController(repository: Get.find<StatisticsRepository>()),
    );
  }
}
