import 'package:finanzbegleiter/application/dashboard/recommendation/dashboard_recommendations_cubit.dart';
import 'package:finanzbegleiter/constants.dart';
import 'package:finanzbegleiter/domain/entities/user.dart';
import 'package:finanzbegleiter/l10n/generated/app_localizations.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/widgets/card_container.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/widgets/error_view.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/widgets/loading_indicator.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/widgets/underlined_dropdown.dart';
import 'package:finanzbegleiter/presentation/dashboard_page/widgets/dashboard_recommendations/dashboard_recommendations_chart.dart';
import 'package:finanzbegleiter/presentation/dashboard_page/widgets/dashboard_recommendations/dashboard_recommendations_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';

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
  String? _selectedPromoterId;
  String? _selectedLandingPageId;

  @override
  void initState() {
    super.initState();

    if (widget.user.role == Role.company) {
      Modular.get<DashboardRecommendationsCubit>()
          .getRecommendationsCompany(widget.user.id.value);
    } else {
      Modular.get<DashboardRecommendationsCubit>().getRecommendationsPromoter(
          widget.user.id.value, widget.user.landingPageIDs);
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final localization = AppLocalizations.of(context);
    final cubit = Modular.get<DashboardRecommendationsCubit>();

    return CardContainer(
      child: BlocBuilder<DashboardRecommendationsCubit,
          DashboardRecommendationsState>(
        bloc: cubit,
        builder: (context, state) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                localization.dashboard_recommendations_title,
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
                    items: [TimePeriod.day, TimePeriod.week, TimePeriod.month]
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
              if (widget.user.role == Role.company &&
                  state is DashboardRecommendationsGetRecosSuccessState &&
                  state.promoterRecommendations != null) ...[
                UnderlinedDropdown<String?>(
                  value: _selectedPromoterId,
                  items: DashboardRecommendationsHelper.getPromoterItems(
                      state.promoterRecommendations!,
                      localization,
                      widget.user.id.value),
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedPromoterId = newValue;
                      _selectedLandingPageId = null;
                    });
                    cubit.filterLandingPagesForPromoter(newValue);
                  },
                ),
                const SizedBox(height: 16),
              ],
              if (state is DashboardRecommendationsGetRecosSuccessState &&
                  state.allLandingPages != null &&
                  state.allLandingPages!.isNotEmpty) ...[
                UnderlinedDropdown<String?>(
                  value: _selectedLandingPageId,
                  items: [
                    DropdownMenuItem<String?>(
                      value: null,
                      child: Text(localization
                          .dashboard_recommendations_all_landingpages),
                    ),
                    ...state.filteredLandingPages!.map((landingPage) {
                      return DropdownMenuItem<String?>(
                        value: landingPage.id.value,
                        child: Text(landingPage.name ?? ""),
                      );
                    }),
                  ],
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedLandingPageId = newValue;
                    });
                  },
                ),
                const SizedBox(height: 16),
              ],
              if (state is DashboardRecommendationsGetRecosSuccessState)
                Text(
                  DashboardRecommendationsHelper.getTimePeriodSummaryText(
                    state: state,
                    selectedPromoterId: _selectedPromoterId,
                    userRole: widget.user.role ?? Role.none,
                    timePeriod: _selectedTimePeriod,
                    localization: localization,
                    selectedLandingPageId: _selectedLandingPageId,
                  ),
                  style: themeData.textTheme.bodySmall!
                      .copyWith(fontWeight: FontWeight.bold),
                ),
              const SizedBox(height: 16),
              if (state is DashboardRecommendationsGetRecosSuccessState)
                DashboardRecommendationsChart(
                  recommendations:
                      DashboardRecommendationsHelper.getFilteredRecommendations(
                    state: state,
                    selectedPromoterId: _selectedPromoterId,
                    userRole: widget.user.role ?? Role.none,
                    selectedLandingPageId: _selectedLandingPageId,
                  ),
                  timePeriod: _selectedTimePeriod,
                  statusLevel: _selectedStatusLevel,
                )
              else if (state
                  is DashboardRecommendationsGetRecosNotFoundFailureState)
                DashboardRecommendationsChart(
                  recommendations: [],
                  timePeriod: _selectedTimePeriod,
                  statusLevel: _selectedStatusLevel,
                )
              else if (state is DashboardRecommendationsGetRecosFailureState)
                ErrorView(
                    title: localization
                        .dashboard_recommendations_loading_error_title,
                    message: "",
                    callback: () => {
                          widget.user.role == Role.company
                              ? cubit.getRecommendationsCompany(
                                  widget.user.id.value)
                              : cubit.getRecommendationsPromoter(
                                  widget.user.id.value,
                                  widget.user.landingPageIDs)
                        })
              else
                const LoadingIndicator(),
            ],
          );
        },
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
