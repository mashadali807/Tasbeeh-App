class TasbeehCount {
  final String id;
  final String userId;
  final String dhikrId;
  final String dhikrName;
  final int count;
  final DateTime timestamp;

  TasbeehCount({
    required this.id,
    required this.userId,
    required this.dhikrId,
    required this.dhikrName,
    required this.count,
    required this.timestamp,
  });

  factory TasbeehCount.fromJson(Map<String, dynamic> json) {
    return TasbeehCount(
      id: json['id'],
      userId: json['userId'],
      dhikrId: json['dhikrId'],
      dhikrName: json['dhikrName'],
      count: json['count'],
      timestamp: DateTime.parse(json['timestamp']),
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'userId': userId,
    'dhikrId': dhikrId,
    'dhikrName': dhikrName,
    'count': count,
    'timestamp': timestamp.toIso8601String(),
  };
}
