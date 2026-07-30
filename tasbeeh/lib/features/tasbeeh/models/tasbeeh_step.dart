class TasbeehStep {
  final String id;
  final String dhikrName;
  final int targetCount;
  bool isCompleted;

  TasbeehStep({
    required this.id,
    required this.dhikrName,
    required this.targetCount,
    this.isCompleted = false,
  });

  factory TasbeehStep.fromJson(Map<String, dynamic> json) {
    return TasbeehStep(
      id: json['id'],
      dhikrName: json['dhikrName'],
      targetCount: json['targetCount'],
      isCompleted: json['isCompleted'] ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'dhikrName': dhikrName,
    'targetCount': targetCount,
    'isCompleted': isCompleted,
  };

  TasbeehStep copyWith({bool? isCompleted}) {
    return TasbeehStep(
      id: id,
      dhikrName: dhikrName,
      targetCount: targetCount,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}