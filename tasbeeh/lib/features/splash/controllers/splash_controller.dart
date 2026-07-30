import 'package:get/get.dart';
import 'package:tasbeeh/features/auth/controller/auth_controller.dart';
import '../../../routes/app_routes.dart';
import '../../auth/models/auth_state.dart';

class SplashController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    _handleSplashScreen();
  }

  Future<void> _handleSplashScreen() async {
    // Show splash for at least 2.5 seconds
    await Future.delayed(const Duration(milliseconds: 2500));

    try {
      final authController = Get.find<AuthController>();
      await authController.checkAuthStatus();

      print('🔍 Splash: auth status = ${authController.state.status}');

      if (authController.state.status == AuthStatus.authenticated) {
        print('🏠 Navigating to Home');
        Get.offAllNamed(Routes.home);
      } else {
        print('🔐 Navigating to Login');
        Get.offAllNamed(Routes.login);
      }
    } catch (e) {
      print('⚠️ Splash error: $e');
      Get.offAllNamed(Routes.login);
    }
  }
}
