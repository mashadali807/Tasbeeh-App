import 'package:get/get.dart';
import 'package:tasbeeh/features/auth/bindings/auth_bindings.dart';
import 'package:tasbeeh/features/auth/screens/forget_password.dart';
import 'package:tasbeeh/features/dhikr_library/bindings/dhikr_library_binding.dart';
import 'package:tasbeeh/features/dhikr_library/screens/dhikr_detail_screen.dart';
import 'package:tasbeeh/features/dhikr_library/screens/dhikr_library_screen.dart';
import 'package:tasbeeh/features/home/bindings/home_bindings.dart';
import 'package:tasbeeh/features/home/screens/home_screen.dart';
import 'package:tasbeeh/features/tasbeeh/bindings/tasbeeh_binding.dart';
import 'package:tasbeeh/features/tasbeeh/screens/tasbeeh_counter_screen.dart';
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
  ];
}
