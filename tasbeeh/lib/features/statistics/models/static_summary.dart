class StatisticsSummary {
  final int totalCount;
  final String favoriteDhikr;
  final int favoriteCount;
  final int longestStreak;

  StatisticsSummary({
    required this.totalCount,
    required this.favoriteDhikr,
    required this.favoriteCount,
    required this.longestStreak,
  });
}

class ChartData {
  final String label;
  final int count;

  ChartData(this.label, this.count);
}
