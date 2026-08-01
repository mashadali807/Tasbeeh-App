import 'package:tasbeeh/features/auth/controller/auth_controller.dart';
import 'package:tasbeeh/features/prayer_time/models/prayer_time_config.dart';
import 'package:tasbeeh/features/prayer_time/repositories/prayer_time_repo.dart';

import '../models/prayer_time.dart';
import '../services/location_service.dart';
import '../services/prayer_calculation_service.dart';
import '../services/prayer_storage_service.dart';

class PrayerTimesRepositoryImpl implements PrayerTimesRepository {
  final LocationService _locationService;
  final PrayerCalculationService _calculationService;
  final PrayerStorageService _storageService;
  final AuthController _authController;

  PrayerTimesRepositoryImpl({
    required LocationService locationService,
    required PrayerCalculationService calculationService,
    required PrayerStorageService storageService,
    required AuthController authController,
  }) : _locationService = locationService,
       _calculationService = calculationService,
       _storageService = storageService,
       _authController = authController;

  PrayerTimesConfig? _cachedConfig;

  @override
  Future<PrayerTimesData> getPrayerTimes({bool forceRefresh = false}) async {
    try {
      // Get location
      final position = await _locationService.getCurrentLocation();
      final city = await _locationService.getCityName(
        position.latitude,
        position.longitude,
      );

      final config = PrayerTimesConfig(
        latitude: position.latitude,
        longitude: position.longitude,
        city: city,
        country: '', // Could be filled from placemarks
      );
      _cachedConfig = config;

      // Calculate prayer times
      final data = _calculationService.calculatePrayerTimes(config);

      // Cache for offline use
      await _storageService.cachePrayerTimes(data);

      return data;
    } catch (e) {
      // Fallback to cached data
      final cached = await _storageService.getCachedPrayerTimes();
      if (cached != null) {
        return cached;
      }
      rethrow;
    }
  }

  @override
  Future<PrayerTimesData> getCachedPrayerTimes() async {
    final cached = await _storageService.getCachedPrayerTimes();
    if (cached != null) {
      return cached;
    }
    // If no cache, try to fetch fresh
    return await getPrayerTimes(forceRefresh: true);
  }

  @override
  Future<void> refreshLocation() async {
    _cachedConfig = null;
    await _storageService.clearCache();
  }
}
