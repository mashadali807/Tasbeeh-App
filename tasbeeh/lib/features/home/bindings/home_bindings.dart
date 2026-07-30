import 'package:get/get.dart';
import 'package:tasbeeh/features/auth/controller/auth_controller.dart';
import 'package:tasbeeh/features/home/controller/home_controller.dart';
import 'package:tasbeeh/features/home/repository/home_repo_imp.dart';
import 'package:tasbeeh/features/home/repository/home_repository.dart';
import 'package:tasbeeh/features/home/services/progress_services.dart';
import 'package:tasbeeh/features/home/services/quote_services.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ProgressService>(() => ProgressService());
    Get.lazyPut<QuoteService>(() => QuoteService());
    Get.lazyPut<HomeRepository>(
      () => HomeRepositoryImpl(
        progressService: Get.find(),
        quoteService: Get.find(),
        authController: Get.find<AuthController>(),
      ),
    );
    Get.lazyPut<HomeController>(() => HomeController(repository: Get.find()));
  }
}
