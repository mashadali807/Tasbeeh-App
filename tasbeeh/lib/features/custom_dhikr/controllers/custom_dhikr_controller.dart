import 'package:get/get.dart';
import 'package:tasbeeh/features/custom_dhikr/repositories/custom_dhikr_repo.dart';
import '../models/custom_dhikr_model.dart';

class CustomDhikrController extends GetxController {
  final CustomDhikrRepository repository;

  final RxList<CustomDhikr> dhikrList = <CustomDhikr>[].obs;
  final RxBool isLoading = true.obs;

  CustomDhikrController({required this.repository});

  @override
  void onInit() {
    super.onInit();
    loadData();
  }

  Future<void> loadData() async {
    isLoading.value = true;
    try {
      final list = await repository.getCustomDhikr();
      dhikrList.assignAll(list);
    } catch (e) {
      print('Error loading custom dhikr: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> saveDhikr(CustomDhikr dhikr) async {
    await repository.saveCustomDhikr(dhikr);
    // Update list
    final index = dhikrList.indexWhere((d) => d.id == dhikr.id);
    if (index != -1) {
      dhikrList[index] = dhikr;
    } else {
      dhikrList.add(dhikr);
    }
    dhikrList.refresh();
  }

  Future<void> deleteDhikr(String id) async {
    await repository.deleteCustomDhikr(id);
    dhikrList.removeWhere((d) => d.id == id);
    dhikrList.refresh();
  }

  // Navigate to form screen for create/edit
  void openForm({CustomDhikr? dhikr}) {
    Get.toNamed('/custom-dhikr-form', arguments: dhikr);
  }

  // Start counting from a custom dhikr
  void startDhikr(CustomDhikr dhikr) {
    Get.toNamed(
      '/tasbeeh',
      arguments: {
        'dhikrId': dhikr.id,
        'dhikrName': dhikr.name,
        'recommendedCount': dhikr.targetCount,
      },
    );
  }

  // Sync from Firestore (manual pull)
  Future<void> syncFromFirestore() async {
    isLoading.value = true;
    try {
      await repository.syncFromFirestore();
      await loadData(); // reload
    } finally {
      isLoading.value = false;
    }
  }
}
