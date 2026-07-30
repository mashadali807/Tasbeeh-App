import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:tasbeeh/features/tasbeeh/controllers/tasbeeh_controller.dart';
import 'package:tasbeeh/features/tasbeeh/repositories/tasbeeh_repo_impl.dart';
import 'package:tasbeeh/features/tasbeeh/repositories/tasbeeh_repository.dart';
import 'package:tasbeeh/features/tasbeeh/services/haptic_service.dart';
import 'package:tasbeeh/features/tasbeeh/services/sound_service.dart';
import 'package:tasbeeh/features/tasbeeh/services/tasbeeh_storage_service.dart';

class TasbeehBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TasbeehStorageService>(() => TasbeehStorageService());
    Get.lazyPut<HapticService>(() => HapticService());
    Get.lazyPut<SoundService>(() => SoundService());
    Get.lazyPut<TasbeehRepository>(
      () => TasbeehRepositoryImpl(
        storage: Get.find(),
        haptic: Get.find(),
        sound: Get.find(),
      ),
    );
    Get.lazyPut<TasbeehController>(
      () => TasbeehController(repository: Get.find()),
    );
  }
}
