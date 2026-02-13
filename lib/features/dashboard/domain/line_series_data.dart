import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class LineSeriesData {
  final List<FlSpot> spots;
  final Color color;

  const LineSeriesData({
    required this.spots,
    required this.color,
  });
}
