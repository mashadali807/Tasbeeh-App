import 'package:get/get.dart';
import 'package:tasbeeh/features/statistics/models/static_summary.dart';
import 'package:tasbeeh/features/statistics/repositories/static_repo.dart';

class StatisticsController extends GetxController {
  final StatisticsRepository repository;

  final Rx<StatisticsSummary?> summary = Rx<StatisticsSummary?>(null);
  final RxList<ChartData> chartData = <ChartData>[].obs;
  final RxBool isLoading = false.obs;
  final RxString selectedChartType = 'Daily'.obs;

  StatisticsController({required this.repository});

  @override
  void onInit() {
    super.onInit();
    loadAllData();
  }

  Future<void> loadAllData() async {
    isLoading.value = true;
    try {
      final summaryData = await repository.getSummary();
      summary.value = summaryData;
      await loadChartData(selectedChartType.value);
    } catch (e) {
      print('Error loading statistics: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadChartData(String type) async {
    try {
      List<ChartData> data;
      switch (type) {
        case 'Daily':
          data = await repository.getDailyCounts();
          break;
        case 'Weekly':
          data = await repository.getWeeklyCounts();
          break;
        case 'Monthly':
          data = await repository.getMonthlyCounts();
          break;
        case 'Yearly':
          data = await repository.getYearlyCounts();
          break;
        default:
          data = [];
      }
      chartData.assignAll(data);
    } catch (e) {
      chartData.clear();
    }
  }

  void changeChartType(String type) {
    selectedChartType.value = type;
    loadChartData(type);
  }

  Future<void> refreshData() async {
    await loadAllData();
  }
}
