import 'package:hive/hive.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/daily_progress_model.dart';

class ProgressService {
  static const String _boxName = 'dailyProgress';
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Helper to open the box with the correct type
  Future<Box<Map<String, dynamic>>> _openBox() async {
    return await Hive.openBox<Map<String, dynamic>>(_boxName);
  }

  // Get today's progress (cached + Firestore)
  Future<DailyProgress> getTodayProgress(String userId) async {
    final today = DateTime.now().toIso8601String().split('T').first;
    // Try cache first
    final box = await _openBox();
    final cached = box.get(today);
    if (cached != null) {
      return DailyProgress.fromJson(cached);
    }

    // Fetch from Firestore
    final doc = await _firestore
        .collection('users')
        .doc(userId)
        .collection('daily_progress')
        .doc(today)
        .get();

    if (doc.exists) {
      final data = doc.data()!;
      final progress = DailyProgress.fromJson(data);
      // Cache it
      await box.put(today, progress.toJson());
      return progress;
    } else {
      // No record – create default
      final defaultProgress = DailyProgress(
        date: today,
        count: 0,
        target: 100,
        completed: false,
      );
      await box.put(today, defaultProgress.toJson());
      return defaultProgress;
    }
  }

  // Update count and sync
  Future<void> updateProgress(String userId, DailyProgress progress) async {
    final today = progress.date;
    // Update cache
    final box = await _openBox();
    await box.put(today, progress.toJson());

    // Update Firestore
    await _firestore
        .collection('users')
        .doc(userId)
        .collection('daily_progress')
        .doc(today)
        .set(progress.toJson(), SetOptions(merge: true));
  }

  // Get streak – number of consecutive days with completed=true
  Future<int> getStreak(String userId) async {
    final box = await _openBox();
    final today = DateTime.now();
    int streak = 0;
    for (int i = 0; i < 30; i++) {
      final date = today.subtract(Duration(days: i));
      final dateStr = date.toIso8601String().split('T').first;
      final cached = box.get(dateStr);
      if (cached != null) {
        final progress = DailyProgress.fromJson(cached);
        if (progress.completed) {
          streak++;
        } else {
          break;
        }
      } else {
        // If cache misses, we could optionally fetch from Firestore.
        // For simplicity, we break.
        break;
      }
    }
    return streak;
  }
}
