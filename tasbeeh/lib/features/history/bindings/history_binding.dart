import 'package:get/get.dart';
import 'package:tasbeeh/features/auth/controller/auth_controller.dart';
import 'package:tasbeeh/features/history/controller/history_controller.dart';
import 'package:tasbeeh/features/history/repositories/history_repo.dart';
import 'package:tasbeeh/features/history/repositories/history_repo_impl.dart';

import '../services/history_storage.dart';

class HistoryBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HistoryStorage>(() => HistoryStorage());
    Get.lazyPut<HistoryRepository>(
      () => HistoryRepositoryImpl(
        storage: Get.find(),
        authController: Get.find<AuthController>(),
      ),
    );
    Get.lazyPut<HistoryController>(
      () => HistoryController(repository: Get.find()),
    );
  }
}
