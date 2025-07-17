import 'package:finanzbegleiter/application/dashboard/promoters/dashboard_promoters_cubit.dart';
import 'package:finanzbegleiter/constants.dart';
import 'package:finanzbegleiter/domain/entities/user.dart';
import 'package:finanzbegleiter/l10n/generated/app_localizations.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/widgets/card_container.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/widgets/error_view.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/widgets/loading_indicator.dart';
import 'package:finanzbegleiter/presentation/dashboard_page/widgets/dashboard_promoters/dashboard_promoters_chart.dart';
import 'package:finanzbegleiter/presentation/dashboard_page/widgets/underlined_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
    final themeData = Theme.of(context);
    final localization = AppLocalizations.of(context);
    final cubit = Modular.get<DashboardPromotersCubit>();

    return CardContainer(
      child: BlocBuilder<DashboardPromotersCubit, DashboardPromotersState>(
        bloc: cubit,
        builder: (context, state) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                localization.dashboard_promoters_title,
                style: themeData.textTheme.bodyLarge!
                    .copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              Wrap(
                spacing: 24,
                runSpacing: 16,
                children: [
                  UnderlinedDropdown<TimePeriod>(
                    value: _selectedTimePeriod,
                    items: [TimePeriod.week, TimePeriod.month, TimePeriod.year]
                        .map((period) {
                      return DropdownMenuItem<TimePeriod>(
                        value: period,
                        child: Text(period.value),
                      );
                    }).toList(),
                    onChanged: (TimePeriod? newValue) {
                      if (newValue != null) {
                        setState(() {
                          _selectedTimePeriod = newValue;
                        });
                      }
                    },
                  ),
                  if (state is DashboardPromotersGetRegisteredPromotersSuccessState)
                    Text(
                      _getTimePeriodSummaryText(state.promoters, _selectedTimePeriod, localization),
                      style: themeData.textTheme.bodySmall!
                          .copyWith(fontWeight: FontWeight.bold),
                    ),
                ],
              ),
              const SizedBox(height: 16),
              if (state is DashboardPromotersGetRegisteredPromotersSuccessState)
                DashboardPromotersChart(
                  promoters: state.promoters,
                  timePeriod: _selectedTimePeriod,
                )
              else if (state is DashboardPromotersGetRegisteredPromotersEmptyState)
                DashboardPromotersChart(
                  promoters: [],
                  timePeriod: _selectedTimePeriod,
                )
              else if (state is DashboardPromotersGetRegisteredPromotersFailureState)
                ErrorView(
                  title: localization.dashboard_promoters_loading_error_title,
                  message: "",
                  callback: () => cubit.getRegisteredPromoters(widget.user),
                )
              else
                const LoadingIndicator(),
            ],
          );
        },
      ),
    );
  }

  String _getTimePeriodSummaryText(List<CustomUser> promoters, TimePeriod timePeriod, AppLocalizations localization) {
    final now = DateTime.now();
    DateTime startDate;
    
    switch (timePeriod) {
      case TimePeriod.week:
        startDate = now.subtract(const Duration(days: 7));
        break;
      case TimePeriod.month:
        startDate = DateTime(now.year, now.month - 1, now.day);
        break;
      case TimePeriod.year:
        startDate = DateTime(now.year - 1, now.month, now.day);
        break;
      default:
        startDate = now.subtract(const Duration(days: 7));
    }

    final filteredPromoters = promoters.where((promoter) {
      return promoter.createdAt != null && promoter.createdAt!.isAfter(startDate);
    }).length;

    switch (timePeriod) {
      case TimePeriod.week:
        return localization.dashboard_promoters_last_7_days(filteredPromoters);
      case TimePeriod.month:
        return localization.dashboard_promoters_last_month(filteredPromoters);
      case TimePeriod.year:
        return localization.dashboard_promoters_last_year(filteredPromoters);
      default:
        return localization.dashboard_promoters_last_7_days(filteredPromoters);
    }
  }
}
