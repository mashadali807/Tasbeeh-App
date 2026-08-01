import 'package:adhan/adhan.dart';
import 'package:tasbeeh/features/prayer_time/models/prayer_time_config.dart';
import '../models/prayer_time.dart';

class PrayerCalculationService {
  PrayerTimesData calculatePrayerTimes(PrayerTimesConfig config) {
    final date = DateTime.now();

    final coordinates = Coordinates(config.latitude, config.longitude);

    // Karachi method is suitable for Pakistan
    final params = CalculationMethod.karachi.getParameters();

    // Convert DateTime to DateComponents
    final dateComponents = DateComponents.from(date);

    final prayerTimes = PrayerTimes(coordinates, dateComponents, params);

    final prayers = [
      PrayerTime(name: 'Fajr', time: prayerTimes.fajr),
      PrayerTime(name: 'Sunrise', time: prayerTimes.sunrise),
      PrayerTime(name: 'Dhuhr', time: prayerTimes.dhuhr),
      PrayerTime(name: 'Asr', time: prayerTimes.asr),
      PrayerTime(name: 'Maghrib', time: prayerTimes.maghrib),
      PrayerTime(name: 'Isha', time: prayerTimes.isha),
    ];

    final now = DateTime.now();

    PrayerTime? currentPrayer;
    PrayerTime? nextPrayer;
    Duration? timeUntilNext;

    for (int i = 0; i < prayers.length; i++) {
      if (prayers[i].time.isAfter(now)) {
        if (i > 0) {
          currentPrayer = prayers[i - 1];
        }

        nextPrayer = prayers[i];
        timeUntilNext = prayers[i].time.difference(now);
        break;
      }
    }

    // If all prayers for today have passed,
    // get tomorrow's Fajr
    if (nextPrayer == null && prayers.isNotEmpty) {
      currentPrayer = prayers.last;

      final tomorrow = date.add(const Duration(days: 1));

      final tomorrowComponents = DateComponents.from(tomorrow);

      final tomorrowTimes = PrayerTimes(
        coordinates,
        tomorrowComponents,
        params,
      );

      nextPrayer = PrayerTime(name: 'Fajr', time: tomorrowTimes.fajr);

      timeUntilNext = tomorrowTimes.fajr.difference(now);
    }

    final updatedPrayers = prayers.map((p) {
      final bool isPast = p.time.isBefore(now);

      final bool isCurrent =
          currentPrayer != null && p.name == currentPrayer.name;

      final bool isNext = nextPrayer != null && p.name == nextPrayer.name;

      return PrayerTime(
        name: p.name,
        time: p.time,
        isCurrent: isCurrent,
        isNext: isNext,
        isPast: isPast,
      );
    }).toList();

    return PrayerTimesData(
      date: date,
      cityName: config.city,
      country: config.country,
      prayers: updatedPrayers,
      nextPrayer: nextPrayer,
      timeUntilNext: timeUntilNext,
    );
  }
}
