class PrayerTimesConfig {
  final double latitude;
  final double longitude;
  final String city;
  final String country;
  final int method;

  PrayerTimesConfig({
    required this.latitude,
    required this.longitude,
    required this.city,
    required this.country,
    this.method = 2, // 2 = Islamic Society of North America (ISNA)
  });

  // Pre-defined calculation methods
  static const Map<int, String> methods = {
    0: 'Muslim World League',
    1: 'Egyptian General Authority',
    2: 'Islamic Society of North America (ISNA)',
    3: 'Umm al-Qura, Makkah',
    4: 'University of Islamic Sciences, Karachi',
    5: 'Institute of Geophysics, University of Tehran',
  };
}
