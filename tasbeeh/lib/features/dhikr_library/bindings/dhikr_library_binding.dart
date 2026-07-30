import 'package:get/get.dart';
import 'package:tasbeeh/features/auth/controller/auth_controller.dart';
import 'package:tasbeeh/features/dhikr_library/repositories/dhikr_repo_impl.dart';
import 'package:tasbeeh/features/dhikr_library/services/dhikr_services.dart';
import 'package:tasbeeh/features/dhikr_library/services/favourite_service.dart';
import '../controllers/dhikr_library_controller.dart';
import '../repositories/dhikr_repository.dart';

class DhikrLibraryBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DhikrService>(() => DhikrService());
    Get.lazyPut<FavoriteService>(() => FavoriteService());
    Get.lazyPut<DhikrRepository>(
      () => DhikrRepositoryImpl(
        dhikrService: Get.find(),
        favoriteService: Get.find(),
        authController: Get.find<AuthController>(),
      ),
    );
    Get.lazyPut<DhikrLibraryController>(
      () => DhikrLibraryController(repository: Get.find()),
    );
  }
}
