import 'package:finanzbegleiter/domain/entities/chart_trend.dart';
import 'package:flutter/material.dart';

class ChartTrendArrow extends StatelessWidget {
  final ChartTrend trend;

  const ChartTrendArrow({super.key, required this.trend});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isIncreasing = trend.isIncreasing;
    final isStable = trend.isStable;
    
    final Color color;
    final IconData icon;
    
    if (isStable) {
      color = theme.colorScheme.outline;
      icon = Icons.trending_flat;
    } else if (isIncreasing) {
      color = theme.colorScheme.primary;
      icon = Icons.arrow_upward;
    } else {
      color = theme.colorScheme.error;
      icon = Icons.arrow_downward;
    }
    
    final percentageValue = trend.percentageChange.abs();
    final percentage = percentageValue == percentageValue.round() 
        ? percentageValue.round().toString()
        : percentageValue.toStringAsFixed(1);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 16,
            color: color,
          ),
          const SizedBox(width: 4),
          Text(
            '$percentage%',
            style: theme.textTheme.bodySmall?.copyWith(
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}