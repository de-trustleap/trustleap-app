import 'package:equatable/equatable.dart';

class ChartTrend extends Equatable {
  final int currentPeriodCount;
  final int previousPeriodCount;
  final double percentageChange;
  final bool isIncreasing;
  final bool isDecreasing;

  const ChartTrend({
    required this.currentPeriodCount,
    required this.previousPeriodCount,
    required this.percentageChange,
    required this.isIncreasing,
    required this.isDecreasing,
  });

  bool get isStable => !isIncreasing && !isDecreasing;

  @override
  List<Object?> get props => [
        currentPeriodCount,
        previousPeriodCount,
        percentageChange,
        isIncreasing,
        isDecreasing
      ];
}
