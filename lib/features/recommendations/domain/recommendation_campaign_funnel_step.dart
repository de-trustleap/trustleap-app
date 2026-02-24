import 'package:flutter/material.dart';

class RecommendationCampaignFunnelStep {
  final IconData icon;
  final String label;
  final int count;
  final double? percentage;

  const RecommendationCampaignFunnelStep({
    required this.icon,
    required this.label,
    required this.count,
    this.percentage,
  });
}
