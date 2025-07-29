import 'package:finanzbegleiter/presentation/dashboard_page/widgets/dashboard_recommendations/dashboard_recommendations_helper.dart';
import 'package:flutter/material.dart';

class DashboardTrendArrow extends StatelessWidget {
  final RecommendationTrend trend;

  const DashboardTrendArrow({super.key, required this.trend});

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
    
    final percentage = trend.percentageChange.abs().toStringAsFixed(1);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
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