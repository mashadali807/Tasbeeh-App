import '../models/prayer_time.dart';

abstract class PrayerTimesRepository {
  Future<PrayerTimesData> getPrayerTimes({bool forceRefresh = false});
  Future<PrayerTimesData> getCachedPrayerTimes();
  Future<void> refreshLocation();
}
