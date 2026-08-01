import 'package:intl/intl.dart';

class PrayerTime {
  final String name;
  final DateTime time;
  final bool isCurrent;
  final bool isNext;
  final bool isPast;

  PrayerTime({
    required this.name,
    required this.time,
    this.isCurrent = false,
    this.isNext = false,
    this.isPast = false,
  });

  String get formattedTime => DateFormat('h:mm a').format(time);
  String get formattedTime24 => DateFormat('HH:mm').format(time);
}

class PrayerTimesData {
  final DateTime date;
  final String cityName;
  final String country;
  final List<PrayerTime> prayers;
  final PrayerTime? nextPrayer;
  final Duration? timeUntilNext;

  PrayerTimesData({
    required this.date,
    required this.cityName,
    required this.country,
    required this.prayers,
    this.nextPrayer,
    this.timeUntilNext,
  });
}
