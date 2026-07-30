import 'package:get/get.dart';
import 'package:tasbeeh/core/services/firebase_auth_services.dart';
import 'package:tasbeeh/core/services/firestore_user_services.dart';
import 'package:tasbeeh/features/auth/controller/auth_controller.dart';
import '../../features/splash/controllers/splash_controller.dart';
import '../../features/auth/repositories/auth_repository.dart';
import '../../features/auth/repositories/auth_repository_impl.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    // Register services
    Get.lazyPut<FirebaseAuthService>(() => FirebaseAuthService());
    Get.lazyPut<FirestoreUserService>(() => FirestoreUserService());

    // Register repository
    Get.lazyPut<AuthRepository>(
      () => AuthRepositoryImpl(
        authService: Get.find(),
        firestoreService: Get.find(),
      ),
    );

    // Register AuthController (so it's available everywhere)
    Get.put(AuthController(authRepository: Get.find()), permanent: true);

    // Register SplashController (only needed during splash)
    Get.put(SplashController(), permanent: false);
  }
}
