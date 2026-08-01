import 'package:get/get.dart';
import 'package:tasbeeh/features/auth/bindings/auth_bindings.dart';
import 'package:tasbeeh/features/auth/screens/forget_password.dart';
import 'package:tasbeeh/features/custom_dhikr/bindings/custom_dhikr_binding.dart';
import 'package:tasbeeh/features/custom_dhikr/screens/custom_dhikr_form_screen.dart';
import 'package:tasbeeh/features/custom_dhikr/screens/custom_dhikr_list_screen.dart';
import 'package:tasbeeh/features/dhikr_library/bindings/dhikr_library_binding.dart';
import 'package:tasbeeh/features/dhikr_library/screens/dhikr_detail_screen.dart';
import 'package:tasbeeh/features/dhikr_library/screens/dhikr_library_screen.dart';
import 'package:tasbeeh/features/history/bindings/history_binding.dart';
import 'package:tasbeeh/features/history/screens/history_list_screen.dart';
import 'package:tasbeeh/features/home/bindings/home_bindings.dart';
import 'package:tasbeeh/features/home/screens/home_screen.dart';
import 'package:tasbeeh/features/prayer_time/bindings/prayer_time_bindings.dart';
import 'package:tasbeeh/features/prayer_time/screens/prayer_time_screen.dart';
import 'package:tasbeeh/features/reminder/bindings/reminder_bindings.dart';
import 'package:tasbeeh/features/reminder/screens/custom_reminder_screen.dart';
import 'package:tasbeeh/features/reminder/screens/reminder_screen.dart';
import 'package:tasbeeh/features/statistics/bindings/statistic_bindings.dart';
import 'package:tasbeeh/features/statistics/screens/statistics_screen.dart';
import 'package:tasbeeh/features/tasbeeh/bindings/tasbeeh_binding.dart';
import 'package:tasbeeh/features/tasbeeh/screens/tasbeeh_counter_screen.dart';
import '../features/daily_adhkar/bindings/daily_adhkar_binding.dart';
import '../features/daily_adhkar/screens/daily_adhkar_detail_screen.dart';
import '../features/daily_adhkar/screens/daily_adhkar_screeb.dart';
import '../features/splash/screens/splash_screen.dart';
import '../features/auth/screens/login_screen.dart';
import '../features/auth/screens/register_screen.dart';
import 'app_routes.dart';

class AppPages {
  static const initial = Routes.splash;

  static final pages = [
    GetPage(name: Routes.splash, page: () => const SplashScreen()),
    GetPage(
      name: Routes.login,
      page: () => LoginScreen(),
      binding: AuthBinding(), // we'll create this
    ),
    GetPage(
      name: Routes.register,
      page: () => RegisterScreen(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: Routes.forgotPassword,
      page: () => ForgotPasswordScreen(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: Routes.home,
      page: () => const HomeScreen(),
      binding:
          HomeBinding(), // we'll create later; for now we can use a simple binding for auth controller already available globally.
    ),
    GetPage(
      name: Routes.dhikrLibrary,
      page: () => DhikrLibraryScreen(),
      binding: DhikrLibraryBinding(),
    ),
    GetPage(name: Routes.dhikrDetail, page: () => const DhikrDetailScreen()),
    GetPage(
      name: Routes.tasbeeh,
      page: () => const TasbeehCounterScreen(),
      binding: TasbeehBinding(),
    ),
    GetPage(
      name: Routes.customDhikr,
      page: () => const CustomDhikrListScreen(),
      binding: CustomDhikrBinding(),
    ),
    GetPage(
      name: Routes.customDhikrForm,
      page: () => const CustomDhikrFormScreen(),
      // No binding needed; it's part of the same module
    ),
    GetPage(
      name: Routes.history,
      page: () => const HistoryListScreen(),
      binding: HistoryBinding(),
    ),
    GetPage(
      name: Routes.statistics,
      page: () => const StatisticsScreen(),
      binding: StatisticsBinding(),
    ),
    GetPage(
      name: Routes.prayerTimes,
      page: () => const PrayerTimesScreen(),
      binding: PrayerTimesBinding(),
    ),
    GetPage(
      name: Routes.dailyAdhkar,
      page: () => const DailyAdhkarScreen(),
      binding: DailyAdhkarBinding(),
    ),
    GetPage(
      name: Routes.dailyAdhkarDetail,
      page: () => const DailyAdhkarDetailScreen(),
    ),
    GetPage(
      name: Routes.reminders,
      page: () => const RemindersScreen(),
      binding: RemindersBinding(),
    ),
    GetPage(
      name: Routes.customReminder,
      page: () => const CustomReminderScreen(),
    ),
  ];
}
