import 'package:finanzbegleiter/application/dashboard/promoters/dashboard_promoters_cubit.dart';
import 'package:finanzbegleiter/constants.dart';
import 'package:finanzbegleiter/domain/entities/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class DashboardPromoters extends StatefulWidget {
  final CustomUser user;
  const DashboardPromoters({super.key, required this.user});

  @override
  State<DashboardPromoters> createState() => _DashboardPromotersState();
}

class _DashboardPromotersState extends State<DashboardPromoters> {
  TimePeriod _selectedTimePeriod = TimePeriod.week;

  @override
  void initState() {
    super.initState();

    Modular.get<DashboardPromotersCubit>().getRegisteredPromoters(widget.user);
  }

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
