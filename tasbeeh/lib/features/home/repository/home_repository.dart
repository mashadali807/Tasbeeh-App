import '../models/daily_progress_model.dart';
import '../models/quote_model.dart';

abstract class HomeRepository {
  Future<DailyProgress> getTodayProgress();
  Future<void> updateProgress(DailyProgress progress);
  Future<int> getStreak();
  Future<Quote> getDailyQuote();
}
