import 'package:get/get.dart';
import 'package:tasbeeh/features/auth/controller/auth_controller.dart';
import 'package:tasbeeh/features/home/repository/home_repository.dart';
import 'package:tasbeeh/routes/app_routes.dart';
import '../../tasbeeh/controllers/tasbeeh_controller.dart';
import '../../tasbeeh/screens/tasbeeh_resume_dialogue.dart';
import '../models/daily_progress_model.dart';
import '../models/quote_model.dart';

class HomeController extends GetxController {
  final AuthController authController = Get.find();
  final HomeRepository repository;

  // Observables
  final Rx<DailyProgress?> dailyProgress = Rx<DailyProgress?>(null);
  final Rx<int> streak = 0.obs;
  final Rx<Quote?> dailyQuote = Rx<Quote?>(null);
  final Rx<String> greeting = ''.obs;
  final Rx<String> userName = ''.obs;
  final RxBool isLoading = false.obs;

  HomeController({required this.repository});

  @override
  void onInit() {
    super.onInit();
    _setGreeting();
    _setUserName();
    loadDashboardData();
  }

  void _setGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) {
      greeting.value = 'Good Morning ☀️';
    } else if (hour < 17) {
      greeting.value = 'Good Afternoon 🌤️';
    } else {
      greeting.value = 'Good Evening 🌙';
    }
  }

  void _setUserName() {
    // Safe: if user is null, fallback to 'Muslim'
    userName.value = authController.state.user?.name ?? 'Muslim';
  }

  Future<void> loadDashboardData() async {
    // Check if user is authenticated; if not, do nothing (should not happen)
    if (authController.state.user == null) {
      print('⚠️ User not authenticated, dashboard data cannot be loaded.');
      return;
    }

    isLoading.value = true;
    try {
      // Load all data in parallel
      final results = await Future.wait([
        repository.getTodayProgress(),
        repository.getStreak(),
        repository.getDailyQuote(),
      ]);
      dailyProgress.value = results[0] as DailyProgress;
      streak.value = results[1] as int;
      dailyQuote.value = results[2] as Quote;
    } catch (e, stack) {
      print('❌ Error loading dashboard: $e');
      print(stack);
      // Set fallback values
      dailyProgress.value = DailyProgress(
        date: DateTime.now().toIso8601String().split('T').first,
        count: 0,
        target: 100,
        completed: false,
      );
      streak.value = 0;
      dailyQuote.value = Quote(text: 'SubhanAllah wa bihamdihi', author: null);
    } finally {
      isLoading.value = false;
    }
  }

  // Resume last Tasbeeh session
  Future<void> resumeLastDhikr() async {
    try {
      // Ensure TasbeehController is available
      final tasbeehController = Get.find<TasbeehController>();
      final activeSession = await tasbeehController.repository
          .getActiveSession();
      if (activeSession != null) {
        final shouldResume = await Get.dialog<bool>(
          TasbeehResumeDialog(
            dhikrName: activeSession.dhikrName,
            count: activeSession.currentCount,
            target: activeSession.targetCount,
          ),
        );
        if (shouldResume == true) {
          Get.toNamed(Routes.tasbeeh, arguments: {'resume': true});
        }
      } else {
        // No active session, go to library
        Get.toNamed(Routes.dhikrLibrary);
      }
    } catch (e) {
      print('❌ Error resuming dhikr: $e');
      // Fallback: go to library
      Get.toNamed(Routes.dhikrLibrary);
    }
  }

  void logout() => authController.logout();

  void navigateTo(String route) => Get.toNamed(route);
}
