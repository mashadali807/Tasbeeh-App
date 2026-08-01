import 'package:get/get.dart';
import '../../auth/controller/auth_controller.dart';
import '../controllers/daily_adhkar_controller.dart';
import '../repositories/daily_adhkar_repo.dart';
import '../repositories/daily_adhkar_repo_impl.dart';

import '../services/daily_adhkar_favourite_service.dart';

import '../services/daily_adhkar_services.dart';

class DailyAdhkarBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DailyAdhkarService>(() => DailyAdhkarService());
    Get.lazyPut<DailyAdhkarFavoriteService>(() => DailyAdhkarFavoriteService());
    Get.lazyPut<DailyAdhkarRepository>(
          () => DailyAdhkarRepositoryImpl(
        adhkarService: Get.find(),
        favoriteService: Get.find(),
        authController: Get.find<AuthController>(),
      ),
    );
    Get.lazyPut<DailyAdhkarController>(
          () => DailyAdhkarController(repository: Get.find()),
    );
  }
}