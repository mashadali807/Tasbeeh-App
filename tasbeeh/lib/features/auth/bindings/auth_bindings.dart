import 'package:get/get.dart';
import 'package:tasbeeh/core/services/firebase_auth_services.dart';
import 'package:tasbeeh/core/services/firestore_user_services.dart';
import 'package:tasbeeh/features/auth/controller/auth_controller.dart';
import '../repositories/auth_repository.dart';
import '../repositories/auth_repository_impl.dart';

class AuthBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<FirebaseAuthService>(() => FirebaseAuthService());
    Get.lazyPut<FirestoreUserService>(() => FirestoreUserService());
    Get.lazyPut<AuthRepository>(
      () => AuthRepositoryImpl(
        authService: Get.find(),
        firestoreService: Get.find(),
      ),
    );
    Get.lazyPut<AuthController>(
      () => AuthController(authRepository: Get.find()),
    );
  }
}
