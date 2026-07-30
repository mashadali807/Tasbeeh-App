class CustomDhikr {
  final String id;
  final String name;
  final String? arabic;
  final String? translation;
  final String? notes;
  final int targetCount;
  final DateTime createdAt;
  final DateTime? updatedAt;

  CustomDhikr({
    required this.id,
    required this.name,
    this.arabic,
    this.translation,
    this.notes,
    this.targetCount = 33,
    required this.createdAt,
    this.updatedAt,
  });

  factory CustomDhikr.fromJson(Map<String, dynamic> json) {
    return CustomDhikr(
      id: json['id'] as String,
      name: json['name'] as String,
      arabic: json['arabic'] as String?,
      translation: json['translation'] as String?,
      notes: json['notes'] as String?,
      targetCount: json['targetCount'] as int? ?? 33,
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'])
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'arabic': arabic,
    'translation': translation,
    'notes': notes,
    'targetCount': targetCount,
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt?.toIso8601String(),
  };

  CustomDhikr copyWith({
    String? name,
    String? arabic,
    String? translation,
    String? notes,
    int? targetCount,
    DateTime? updatedAt,
  }) {
    return CustomDhikr(
      id: id,
      name: name ?? this.name,
      arabic: arabic ?? this.arabic,
      translation: translation ?? this.translation,
      notes: notes ?? this.notes,
      targetCount: targetCount ?? this.targetCount,
      createdAt: createdAt,
      updatedAt: updatedAt ?? DateTime.now(),
    );
  }
}
