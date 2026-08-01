import 'package:get/get.dart';
import 'package:tasbeeh/features/reminder/controllers/reminder_controller.dart';
import 'package:tasbeeh/features/reminder/repositories/reminder_repo.dart';
import 'package:tasbeeh/features/reminder/repositories/reminder_repo_impl.dart';
import '../services/reminder_storage.dart';

class RemindersBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ReminderStorage>(() => ReminderStorage());
    Get.lazyPut<RemindersRepository>(
      () => RemindersRepositoryImpl(storage: Get.find()),
    );
    Get.lazyPut<RemindersController>(
      () => RemindersController(repository: Get.find()),
    );
  }
}
