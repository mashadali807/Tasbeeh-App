import 'dart:convert';
import 'package:hive/hive.dart';
import '../models/prayer_time.dart';

class PrayerStorageService {
  static const String _boxName = 'prayer_times_cache';

  Future<Box<String>> _openBox() async {
    return await Hive.openBox<String>(_boxName);
  }

  Future<void> cachePrayerTimes(PrayerTimesData data) async {
    final box = await _openBox();
    final key = data.date.toIso8601String().split('T').first;
    final json = {
      'date': data.date.toIso8601String(),
      'cityName': data.cityName,
      'country': data.country,
      'prayers': data.prayers
          .map(
            (p) => {
              'name': p.name,
              'time': p.time.toIso8601String(),
              'isCurrent': p.isCurrent,
              'isNext': p.isNext,
              'isPast': p.isPast,
            },
          )
          .toList(),
    };
    await box.put(key, jsonEncode(json));
  }

  Future<PrayerTimesData?> getCachedPrayerTimes() async {
    final box = await _openBox();
    final today = DateTime.now().toIso8601String().split('T').first;
    final jsonStr = box.get(today);
    if (jsonStr == null) return null;

    try {
      final json = jsonDecode(jsonStr);
      final prayers = (json['prayers'] as List)
          .map(
            (p) => PrayerTime(
              name: p['name'],
              time: DateTime.parse(p['time']),
              isCurrent: p['isCurrent'] ?? false,
              isNext: p['isNext'] ?? false,
              isPast: p['isPast'] ?? false,
            ),
          )
          .toList();

      // Recalculate next prayer and current status since times change
      final now = DateTime.now();
      PrayerTime? nextPrayer;
      Duration? timeUntilNext;

      for (var p in prayers) {
        if (p.time.isAfter(now)) {
          nextPrayer = p;
          timeUntilNext = p.time.difference(now);
          break;
        }
      }

      return PrayerTimesData(
        date: DateTime.parse(json['date']),
        cityName: json['cityName'],
        country: json['country'],
        prayers: prayers,
        nextPrayer: nextPrayer,
        timeUntilNext: timeUntilNext,
      );
    } catch (e) {
      return null;
    }
  }

  Future<void> clearCache() async {
    final box = await _openBox();
    await box.clear();
  }
}
