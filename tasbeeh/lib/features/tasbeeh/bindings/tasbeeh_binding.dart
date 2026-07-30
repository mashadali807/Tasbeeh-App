import 'package:get/get.dart';
import 'package:tasbeeh/features/auth/controller/auth_controller.dart';
import 'package:tasbeeh/features/history/repositories/history_repo.dart';
import 'package:tasbeeh/features/history/repositories/history_repo_impl.dart';
import 'package:tasbeeh/features/history/services/history_storage.dart';
import 'package:tasbeeh/features/tasbeeh/controllers/tasbeeh_controller.dart';
import 'package:tasbeeh/features/tasbeeh/repositories/tasbeeh_repo_impl.dart';
import 'package:tasbeeh/features/tasbeeh/repositories/tasbeeh_repository.dart';
import 'package:tasbeeh/features/tasbeeh/services/haptic_service.dart';
import 'package:tasbeeh/features/tasbeeh/services/sound_service.dart';
import 'package:tasbeeh/features/tasbeeh/services/tasbeeh_storage_service.dart';

class TasbeehBinding extends Bindings {
  @override
  void dependencies() {
    // Register core Tasbeeh services
    Get.lazyPut<TasbeehStorageService>(() => TasbeehStorageService());
    Get.lazyPut<HapticService>(() => HapticService());
    Get.lazyPut<SoundService>(() => SoundService());

    // Register Tasbeeh repository
    Get.lazyPut<TasbeehRepository>(
      () => TasbeehRepositoryImpl(
        storage: Get.find(),
        haptic: Get.find(),
        sound: Get.find(),
      ),
    );

    // ✅ Register HistoryRepository (with its dependencies)
    Get.lazyPut<HistoryStorage>(() => HistoryStorage());
    Get.lazyPut<HistoryRepository>(
      () => HistoryRepositoryImpl(
        storage: Get.find<HistoryStorage>(),
        authController: Get.find<AuthController>(),
      ),
    );

    // Register TasbeehController with both repositories
    Get.lazyPut<TasbeehController>(
      () => TasbeehController(
        repository: Get.find(),
        historyRepository: Get.find<HistoryRepository>(),
      ),
    );
  }
}
