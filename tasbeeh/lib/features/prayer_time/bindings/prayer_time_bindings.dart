import 'package:get/get.dart';
import 'package:tasbeeh/features/auth/controller/auth_controller.dart';
import 'package:tasbeeh/features/prayer_time/controller/prayer_times_controller.dart';
import 'package:tasbeeh/features/prayer_time/repositories/prayer_time_repo.dart';
import 'package:tasbeeh/features/prayer_time/repositories/prayer_time_repo_impl.dart';

import '../services/location_service.dart';
import '../services/prayer_calculation_service.dart';
import '../services/prayer_storage_service.dart';

class PrayerTimesBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LocationService>(() => LocationService());
    Get.lazyPut<PrayerCalculationService>(() => PrayerCalculationService());
    Get.lazyPut<PrayerStorageService>(() => PrayerStorageService());
    Get.lazyPut<PrayerTimesRepository>(
      () => PrayerTimesRepositoryImpl(
        locationService: Get.find(),
        calculationService: Get.find(),
        storageService: Get.find(),
        authController: Get.find<AuthController>(),
      ),
    );
    Get.lazyPut<PrayerTimesController>(
      () => PrayerTimesController(repository: Get.find()),
    );
  }
}
