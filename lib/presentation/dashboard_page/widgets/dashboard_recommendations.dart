import 'package:finanzbegleiter/application/dashboard/overview/cubit/dashboard_recommendations_cubit.dart';
import 'package:finanzbegleiter/constants.dart';
import 'package:finanzbegleiter/domain/entities/user.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/widgets/card_container.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/widgets/error_view.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/widgets/loading_indicator.dart';
import 'package:finanzbegleiter/presentation/dashboard_page/widgets/dashboard_recommendations_chart.dart';
import 'package:finanzbegleiter/presentation/dashboard_page/widgets/underlined_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:finanzbegleiter/l10n/generated/app_localizations.dart';

class DashboardRecommendations extends StatefulWidget {
  final CustomUser user;
  const DashboardRecommendations({super.key, required this.user});

  @override
  State<DashboardRecommendations> createState() =>
      _DashboardRecommendationsState();
}

class _DashboardRecommendationsState extends State<DashboardRecommendations> {
  TimePeriod _selectedTimePeriod = TimePeriod.week;
  int? _selectedStatusLevel = 1;

  @override
  void initState() {
    super.initState();

    if (widget.user.role == Role.company) {
      Modular.get<DashboardRecommendationsCubit>().getRecommendationsCompany();
    } else {
      Modular.get<DashboardRecommendationsCubit>()
          .getRecommendationsPromoter(widget.user.id.value);
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final cubit = Modular.get<DashboardRecommendationsCubit>();

    return CardContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Anzahl der Empfehlungen",
            style: themeData.textTheme.titleMedium!
                .copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              UnderlinedDropdown<TimePeriod>(
                value: _selectedTimePeriod,
                items: TimePeriod.values.map((period) {
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
              const SizedBox(width: 24),
              UnderlinedDropdown<int>(
                value: _selectedStatusLevel,
                items: _getStatusLevelItems(),
                onChanged: (int? newValue) {
                  setState(() {
                    _selectedStatusLevel = newValue;
                  });
                },
              ),
            ],
          ),
          const SizedBox(height: 16),
          BlocBuilder<DashboardRecommendationsCubit,
              DashboardRecommendationsState>(
            bloc: cubit,
            builder: (context, state) {
              if (state is DashboardRecommendationsGetRecosSuccessState) {
                return DashboardRecommendationsChart(
                  recommendations: state.recommendation,
                  timePeriod: _selectedTimePeriod,
                  statusLevel: _selectedStatusLevel,
                );
              } else if (state
                  is DashboardRecommendationsGetRecosFailureState) {
                return ErrorView(
                    title: "Laden der Empfehlungen fehlgeschlagen",
                    message: "",
                    callback: () => {
                          widget.user.role == Role.company
                              ? cubit.getRecommendationsCompany()
                              : cubit.getRecommendationsPromoter(
                                  widget.user.id.value)
                        });
              } else {
                return const LoadingIndicator();
              }
            },
          ),
        ],
      ),
    );
  }

  List<DropdownMenuItem<int>> _getStatusLevelItems() {
    final localization = AppLocalizations.of(context);

    return [
      DropdownMenuItem<int>(
        value: 1,
        child: Text(localization.recommendation_manager_status_level_1),
      ),
      DropdownMenuItem<int>(
        value: 2,
        child: Text(localization.recommendation_manager_status_level_2),
      ),
      DropdownMenuItem<int>(
        value: 3,
        child: Text(localization.recommendation_manager_status_level_3),
      ),
      DropdownMenuItem<int>(
        value: 4,
        child: Text(localization.recommendation_manager_status_level_4),
      ),
      DropdownMenuItem<int>(
        value: 5,
        child: Text(localization.recommendation_manager_status_level_5),
      ),
      DropdownMenuItem<int>(
        value: 6,
        child: Text(localization.recommendation_manager_status_level_6),
      ),
    ];
  }
}
