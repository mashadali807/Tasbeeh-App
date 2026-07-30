import 'package:intl/intl.dart';

class HistoryEntry {
  final String id;
  final String dhikrId;
  final String dhikrName;
  final String? arabicText;
  final int count;
  final int targetCount;
  final bool isCompleted;
  final DateTime startedAt;
  final DateTime? completedAt;
  final int durationSeconds;

  HistoryEntry({
    required this.id,
    required this.dhikrId,
    required this.dhikrName,
    this.arabicText,
    required this.count,
    required this.targetCount,
    required this.isCompleted,
    required this.startedAt,
    this.completedAt,
    required this.durationSeconds,
  });

  // Helper to get the date as a string
  String get dateString => DateFormat('yyyy-MM-dd').format(startedAt);

  // Helper to get formatted time
  String get formattedTime => DateFormat('h:mm a').format(startedAt);

  // Helper to get duration string
  String get durationString {
    final minutes = durationSeconds ~/ 60;
    final seconds = durationSeconds % 60;
    if (minutes > 0) {
      return '$minutes min ${seconds}s';
    }
    return '${seconds}s';
  }

  // Check if entry is from today
  bool get isToday {
    final now = DateTime.now();
    return startedAt.year == now.year &&
        startedAt.month == now.month &&
        startedAt.day == now.day;
  }

  // Check if entry is from yesterday
  bool get isYesterday {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    return startedAt.year == yesterday.year &&
        startedAt.month == yesterday.month &&
        startedAt.day == yesterday.day;
  }

  // Check if entry is from the last 7 days
  bool get isLast7Days {
    final sevenDaysAgo = DateTime.now().subtract(const Duration(days: 7));
    return startedAt.isAfter(sevenDaysAgo) && !isToday && !isYesterday;
  }

  factory HistoryEntry.fromJson(Map<String, dynamic> json) {
    return HistoryEntry(
      id: json['id'] as String,
      dhikrId: json['dhikrId'] as String,
      dhikrName: json['dhikrName'] as String,
      arabicText: json['arabicText'] as String?,
      count: json['count'] as int,
      targetCount: json['targetCount'] as int,
      isCompleted: json['isCompleted'] as bool,
      startedAt: DateTime.parse(json['startedAt']),
      completedAt: json['completedAt'] != null
          ? DateTime.parse(json['completedAt'])
          : null,
      durationSeconds: json['durationSeconds'] as int,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'dhikrId': dhikrId,
    'dhikrName': dhikrName,
    'arabicText': arabicText,
    'count': count,
    'targetCount': targetCount,
    'isCompleted': isCompleted,
    'startedAt': startedAt.toIso8601String(),
    'completedAt': completedAt?.toIso8601String(),
    'durationSeconds': durationSeconds,
  };
}
