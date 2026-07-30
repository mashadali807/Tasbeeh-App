import 'package:tasbeeh/features/auth/controller/auth_controller.dart';
import 'package:tasbeeh/features/custom_dhikr/repositories/custom_dhikr_repo.dart';

import '../models/custom_dhikr_model.dart';
import '../services/custom_dhikr_storage.dart';

class CustomDhikrRepositoryImpl implements CustomDhikrRepository {
  final CustomDhikrStorage storage;
  final AuthController authController;

  CustomDhikrRepositoryImpl({
    required this.storage,
    required this.authController,
  });

  // ✅ Safe getter
  String get _userId {
    final user = authController.state.user;
    if (user == null) {
      throw Exception('User not authenticated');
    }
    return user.id;
  }

  @override
  Future<List<CustomDhikr>> getCustomDhikr() => storage.getCustomDhikr(_userId);

  @override
  Future<void> saveCustomDhikr(CustomDhikr dhikr) =>
      storage.saveCustomDhikr(_userId, dhikr);

  @override
  Future<void> deleteCustomDhikr(String id) =>
      storage.deleteCustomDhikr(_userId, id);

  @override
  Future<void> syncFromFirestore() => storage.syncFromFirestore(_userId);
}
