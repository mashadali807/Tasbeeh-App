import 'package:intl/intl.dart';

enum ReminderType {
  morningAdhkar,
  eveningAdhkar,
  prayerTime,
  dailyGoal,
  custom,
}

class Reminder {
  final String id;
  final String title;
  final String body;
  final ReminderType type;
  final DateTime time;
  final List<int> daysOfWeek; // 1 = Monday, 7 = Sunday
  final bool isEnabled;
  final int? prayerIndex; // For prayer times: 0=Fajr, 1=Sunrise, etc.

  Reminder({
    required this.id,
    required this.title,
    required this.body,
    required this.type,
    required this.time,
    this.daysOfWeek = const [1, 2, 3, 4, 5, 6, 7],
    this.isEnabled = true,
    this.prayerIndex,
  });

  factory Reminder.fromJson(Map<String, dynamic> json) {
    return Reminder(
      id: json['id'],
      title: json['title'],
      body: json['body'],
      type: ReminderType.values.firstWhere(
        (e) => e.toString() == json['type'],
        orElse: () => ReminderType.custom,
      ),
      time: DateTime.parse(json['time']),
      daysOfWeek: List<int>.from(json['daysOfWeek'] ?? [1, 2, 3, 4, 5, 6, 7]),
      isEnabled: json['isEnabled'] ?? true,
      prayerIndex: json['prayerIndex'],
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'body': body,
    'type': type.toString(),
    'time': time.toIso8601String(),
    'daysOfWeek': daysOfWeek,
    'isEnabled': isEnabled,
    'prayerIndex': prayerIndex,
  };

  String get formattedTime => DateFormat('h:mm a').format(time);

  String get daysString {
    if (daysOfWeek.length == 7) return 'Every day';
    const dayNames = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return daysOfWeek.map((d) => dayNames[d - 1]).join(', ');
  }

  // ✅ Add copyWith method
  Reminder copyWith({
    String? id,
    String? title,
    String? body,
    ReminderType? type,
    DateTime? time,
    List<int>? daysOfWeek,
    bool? isEnabled,
    int? prayerIndex,
  }) {
    return Reminder(
      id: id ?? this.id,
      title: title ?? this.title,
      body: body ?? this.body,
      type: type ?? this.type,
      time: time ?? this.time,
      daysOfWeek: daysOfWeek ?? this.daysOfWeek,
      isEnabled: isEnabled ?? this.isEnabled,
      prayerIndex: prayerIndex ?? this.prayerIndex,
    );
  }
}
