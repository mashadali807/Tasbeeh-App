class DailyAdhkar {
  final String id;
  final String arabic;
  final String transliteration;
  final String translationEn;
  final String? translationUr;
  final String? benefits;
  final int recommendedCount;
  final String category; // morning, evening, sleeping, eating, traveling, general

  DailyAdhkar({
    required this.id,
    required this.arabic,
    required this.transliteration,
    required this.translationEn,
    this.translationUr,
    this.benefits,
    this.recommendedCount = 3,
    this.category = 'general',
  });

  factory DailyAdhkar.fromJson(Map<String, dynamic> json) {
    return DailyAdhkar(
      id: json['id'] as String,
      arabic: json['arabic'] as String,
      transliteration: json['transliteration'] as String,
      translationEn: json['translationEn'] as String,
      translationUr: json['translationUr'] as String?,
      benefits: json['benefits'] as String?,
      recommendedCount: json['recommendedCount'] as int? ?? 3,
      category: json['category'] as String? ?? 'general',
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'arabic': arabic,
    'transliteration': transliteration,
    'translationEn': translationEn,
    'translationUr': translationUr,
    'benefits': benefits,
    'recommendedCount': recommendedCount,
    'category': category,
  };
}