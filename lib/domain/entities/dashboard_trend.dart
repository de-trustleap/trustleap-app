class DashboardTrend {
  final int currentPeriodCount;
  final int previousPeriodCount;
  final double percentageChange;
  final bool isIncreasing;
  final bool isDecreasing;

  const DashboardTrend({
    required this.currentPeriodCount,
    required this.previousPeriodCount,
    required this.percentageChange,
    required this.isIncreasing,
    required this.isDecreasing,
  });

  bool get isStable => !isIncreasing && !isDecreasing;
}