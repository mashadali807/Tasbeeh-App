import 'package:tasbeeh/features/auth/controller/auth_controller.dart';
import 'package:tasbeeh/features/home/services/progress_services.dart';
import 'package:tasbeeh/features/home/services/quote_services.dart';
import '../models/daily_progress_model.dart';
import '../models/quote_model.dart';
import 'home_repository.dart';

class HomeRepositoryImpl implements HomeRepository {
  final ProgressService _progressService;
  final QuoteService _quoteService;
  final AuthController _authController;

  HomeRepositoryImpl({
    required ProgressService progressService,
    required QuoteService quoteService,
    required AuthController authController,
  }) : _progressService = progressService,
       _quoteService = quoteService,
       _authController = authController;

  // Safe getter – throws a meaningful error if user is null
  String get _userId {
    final user = _authController.state.user;
    if (user == null) {
      throw Exception('User not authenticated');
    }
    return user.id;
  }

  @override
  Future<DailyProgress> getTodayProgress() =>
      _progressService.getTodayProgress(_userId);

  @override
  Future<void> updateProgress(DailyProgress progress) =>
      _progressService.updateProgress(_userId, progress);

  @override
  Future<int> getStreak() => _progressService.getStreak(_userId);

  @override
  Future<Quote> getDailyQuote() => _quoteService.getRandomQuote();
}
