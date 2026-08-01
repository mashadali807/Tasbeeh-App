import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:tasbeeh/features/statistics/controller/statistics_controller.dart';
import 'package:tasbeeh/features/statistics/models/static_summary.dart';
import 'package:tasbeeh/features/statistics/widgets/chart_selectore.dart';
import '../widgets/summary_card.dart';

class StatisticsScreen extends GetView<StatisticsController> {
  const StatisticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: isDark
              ? const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFF0A0E0A),
                    Color(0xFF1A2A1F),
                    Color(0xFF0B8A5E),
                  ],
                )
              : const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFFF8FAF9),
                    Color(0xFFE8F5EE),
                    Color(0xFFD4EDDA),
                  ],
                ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Custom App Bar
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF1A2A1F) : Colors.white,
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(24),
                    bottomRight: Radius.circular(24),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: isDark
                          ? Colors.black.withOpacity(0.3)
                          : const Color(0xFF0B8A5E).withOpacity(0.08),
                      blurRadius: 20,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: const LinearGradient(
                          colors: [Color(0xFF0B8A5E), Color(0xFFD4AF37)],
                        ),
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.bar_chart_rounded,
                          color: Colors.white,
                          size: 22,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        'Statistics',
                        style: GoogleFonts.poppins(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: isDark
                              ? Colors.white
                              : const Color(0xFF0B8A5E),
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.refresh_rounded,
                        color: isDark
                            ? Colors.white70
                            : const Color(0xFF6C757D),
                      ),
                      onPressed: controller.refreshData,
                      tooltip: 'Refresh',
                    ),
                  ],
                ),
              ),
              // Body
              Expanded(
                child: Obx(() {
                  if (controller.isLoading.value) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (controller.summary.value == null) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.analytics_outlined,
                            size: 64,
                            color: isDark ? Colors.white30 : Colors.grey[400],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'No data available yet.',
                            style: GoogleFonts.poppins(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: isDark ? Colors.white60 : Colors.grey[600],
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Start using the app to see your progress!',
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              color: isDark ? Colors.white38 : Colors.grey[500],
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                  return RefreshIndicator(
                    onRefresh: controller.refreshData,
                    color: const Color(0xFF0B8A5E),
                    backgroundColor: isDark
                        ? const Color(0xFF1E2A1E)
                        : Colors.white,
                    child: SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: const EdgeInsets.only(bottom: 20),
                      child: Column(
                        children: [
                          SummaryCard(summary: controller.summary.value!),
                          const SizedBox(height: 16),
                          // Chart selector
                          ChartSelector(
                            options: const [
                              'Daily',
                              'Weekly',
                              'Monthly',
                              'Yearly',
                            ],
                            selected: controller.selectedChartType.value,
                            onChanged: controller.changeChartType,
                          ),
                          const SizedBox(height: 16),
                          // Chart
                          Container(
                            height: 300,
                            margin: const EdgeInsets.symmetric(horizontal: 12),
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: isDark
                                  ? const Color(0xFF1E2A1E)
                                  : Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: isDark
                                      ? Colors.black.withOpacity(0.3)
                                      : const Color(
                                          0xFF0B8A5E,
                                        ).withOpacity(0.08),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: controller.chartData.isEmpty
                                ? Center(
                                    child: Text(
                                      'No data for this period',
                                      style: GoogleFonts.poppins(
                                        fontSize: 14,
                                        color: isDark
                                            ? Colors.white30
                                            : Colors.grey[500],
                                      ),
                                    ),
                                  )
                                : SfCartesianChart(
                                    primaryXAxis: CategoryAxis(
                                      labelStyle: TextStyle(
                                        fontSize: 11,
                                        color: isDark
                                            ? Colors.white60
                                            : Colors.grey[600],
                                        fontFamily: 'Poppins',
                                      ),
                                      axisLine: AxisLine(
                                        color: Colors.transparent,
                                      ),
                                    ),
                                    primaryYAxis: NumericAxis(
                                      labelStyle: TextStyle(
                                        fontSize: 11,
                                        color: isDark
                                            ? Colors.white60
                                            : Colors.grey[600],
                                        fontFamily: 'Poppins',
                                      ),
                                      axisLine: AxisLine(
                                        color: Colors.transparent,
                                      ),
                                      majorGridLines: MajorGridLines(
                                        color: isDark
                                            ? Colors.white12
                                            : Colors.grey[200]!,
                                        width: 0.5,
                                      ),
                                    ),
                                    backgroundColor: Colors.transparent,
                                    plotAreaBackgroundColor: Colors.transparent,
                                    series:
                                        <CartesianSeries<ChartData, String>>[
                                          ColumnSeries<ChartData, String>(
                                            dataSource: controller.chartData,
                                            xValueMapper: (ChartData data, _) =>
                                                data.label,
                                            yValueMapper: (ChartData data, _) =>
                                                data.count,
                                            color: const Color(0xFF0B8A5E),
                                            borderRadius:
                                                const BorderRadius.vertical(
                                                  top: Radius.circular(4),
                                                ),
                                            dataLabelSettings:
                                                DataLabelSettings(
                                                  isVisible: true,
                                                  textStyle: TextStyle(
                                                    fontSize: 11,
                                                    color: isDark
                                                        ? Colors.white70
                                                        : Colors.grey[700],
                                                    fontFamily: 'Poppins',
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                          ),
                                        ],
                                    tooltipBehavior: TooltipBehavior(
                                      enable: true,
                                      color: isDark
                                          ? const Color(0xFF1E2A1E)
                                          : Colors.white,
                                      borderColor: const Color(0xFF0B8A5E),
                                      borderWidth: 1,
                                      textStyle: TextStyle(
                                        fontFamily: 'Poppins',
                                        fontSize: 12,
                                        color: isDark
                                            ? Colors.white
                                            : Colors.black87,
                                      ),
                                    ),
                                  ),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
