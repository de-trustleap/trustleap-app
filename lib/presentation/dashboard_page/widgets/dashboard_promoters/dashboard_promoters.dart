import 'package:finanzbegleiter/constants.dart';
import 'package:finanzbegleiter/domain/entities/user.dart';
import 'package:flutter/material.dart';

class DashboardPromoters extends StatefulWidget {
  final CustomUser user;
  const DashboardPromoters({super.key, required this.user});

  @override
  State<DashboardPromoters> createState() => _DashboardPromotersState();
}

class _DashboardPromotersState extends State<DashboardPromoters> {
  TimePeriod _selectedTimePeriod = TimePeriod.week;
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
