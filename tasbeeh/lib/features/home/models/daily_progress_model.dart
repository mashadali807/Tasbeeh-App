class DailyProgress {
  final String date; // 'yyyy-MM-dd'
  final int count;
  final int target;
  final bool completed;

  DailyProgress({
    required this.date,
    required this.count,
    required this.target,
    required this.completed,
  });

  factory DailyProgress.fromJson(Map<String, dynamic> json) {
    return DailyProgress(
      date: json['date'],
      count: json['count'] ?? 0,
      target: json['target'] ?? 100,
      completed: json['completed'] ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
    'date': date,
    'count': count,
    'target': target,
    'completed': completed,
  };

  DailyProgress copyWith({int? count, int? target, bool? completed}) {
    return DailyProgress(
      date: date,
      count: count ?? this.count,
      target: target ?? this.target,
      completed: completed ?? this.completed,
    );
  }
}
