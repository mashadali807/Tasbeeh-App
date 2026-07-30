import 'package:get/get.dart';
import 'package:tasbeeh/features/auth/controller/auth_controller.dart';
import 'package:tasbeeh/features/custom_dhikr/repositories/custom_dhikr_repo.dart';
import 'package:tasbeeh/features/custom_dhikr/repositories/custom_dhikr_repo_imp.dart';
import '../controllers/custom_dhikr_controller.dart';

import '../services/custom_dhikr_storage.dart';

class CustomDhikrBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CustomDhikrStorage>(() => CustomDhikrStorage());
    Get.lazyPut<CustomDhikrRepository>(
      () => CustomDhikrRepositoryImpl(
        storage: Get.find(),
        authController: Get.find<AuthController>(),
      ),
    );
    Get.lazyPut<CustomDhikrController>(
      () => CustomDhikrController(repository: Get.find()),
    );
  }
}
