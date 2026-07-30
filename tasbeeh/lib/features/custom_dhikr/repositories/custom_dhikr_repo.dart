import '../models/custom_dhikr_model.dart';

abstract class CustomDhikrRepository {
  Future<List<CustomDhikr>> getCustomDhikr();
  Future<void> saveCustomDhikr(CustomDhikr dhikr);
  Future<void> deleteCustomDhikr(String id);
  Future<void> syncFromFirestore();
}
