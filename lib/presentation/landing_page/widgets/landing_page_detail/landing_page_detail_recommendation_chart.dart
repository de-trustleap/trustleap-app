import 'package:finanzbegleiter/application/landingpages/landing_page_detail/landing_page_detail_cubit.dart';
import 'package:finanzbegleiter/constants.dart';
import 'package:finanzbegleiter/domain/entities/user.dart';
import 'package:finanzbegleiter/domain/entities/user_recommendation.dart';
import 'package:finanzbegleiter/domain/statistics/recommendations_statistics.dart';
import 'package:finanzbegleiter/l10n/generated/app_localizations.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/widgets/card_container.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/widgets/error_view.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/widgets/expanded_section.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/widgets/loading_indicator.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/widgets/underlined_dropdown.dart';
import 'package:finanzbegleiter/presentation/dashboard_page/widgets/dashboard_recommendations/dashboard_recommendations_chart.dart';
import 'package:finanzbegleiter/presentation/dashboard_page/widgets/dashboard_recommendations/dashboard_recommendations_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:responsive_framework/responsive_framework.dart';

class LandingPageDetailRecommendationChart extends StatefulWidget {
  final String landingPageId;
  final CustomUser user;

  const LandingPageDetailRecommendationChart({
    super.key,
    required this.landingPageId,
    required this.user,
  });

  @override
  State<LandingPageDetailRecommendationChart> createState() =>
      _LandingPageDetailTrafficChartState();
}

class _LandingPageDetailTrafficChartState
    extends State<LandingPageDetailRecommendationChart> {
  TimePeriod _selectedTimePeriod = TimePeriod.week;
  int? _selectedStatusLevel = 1;
  String? _selectedPromoterId;
  bool _isFilterExpanded = false;

  @override
  void initState() {
    super.initState();
    _loadRecommendations();
  }

  void _loadRecommendations() {
    Modular.get<LandingPageDetailCubit>().loadRecommendations(
      userId: widget.user.id.value,
      role: widget.user.role ?? Role.none,
      landingPageIds: widget.user.landingPageIDs,
    );
  }

  void _onFilterPressed() {
    final responsiveValue = ResponsiveBreakpoints.of(context);

    if (responsiveValue.isMobile) {
      _showFilterBottomSheet();
    } else {
      setState(() {
        _isFilterExpanded = !_isFilterExpanded;
      });
    }
  }

  void _showFilterBottomSheet() {
    final themeData = Theme.of(context);
    final localization = AppLocalizations.of(context);
    final cubit = Modular.get<LandingPageDetailCubit>();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      localization.dashboard_recommendations_filter_tooltip,
                      style: themeData.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.close),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _buildFilterContent(
                  localization,
                  themeData,
                  cubit.state,
                  (value) {
                    setModalState(() {});
                    setState(() {
                      _selectedTimePeriod = value;
                    });
                  },
                  (value) {
                    setModalState(() {});
                    setState(() {
                      _selectedStatusLevel = value;
                    });
                  },
                  (value) {
                    setModalState(() {});
                    setState(() {
                      _selectedPromoterId = value;
                    });
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final localization = AppLocalizations.of(context);
    final cubit = Modular.get<LandingPageDetailCubit>();

    return CardContainer(
      maxWidth: double.infinity,
      child: BlocBuilder<LandingPageDetailCubit, LandingPageDetailState>(
        bloc: cubit,
        builder: (context, state) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  SelectableText(
                    localization.landing_page_detail_recommendation_overview,
                    style: themeData.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  SizedBox(
                    width: 48,
                    height: 48,
                    child: IconButton(
                      onPressed: _onFilterPressed,
                      tooltip:
                          localization.dashboard_recommendations_filter_tooltip,
                      icon: Icon(
                        Icons.filter_list,
                        color: themeData.colorScheme.secondary,
                        size: 32,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              ExpandedSection(
                expand: _isFilterExpanded,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: _buildFilterContent(
                    localization,
                    themeData,
                    state,
                    (value) {
                      setState(() {
                        _selectedTimePeriod = value;
                      });
                    },
                    (value) {
                      setState(() {
                        _selectedStatusLevel = value;
                      });
                    },
                    (value) {
                      setState(() {
                        _selectedPromoterId = value;
                      });
                    },
                  ),
                ),
              ),

              if (state is LandingPageDetailRecommendationsSuccess)
                SelectableText(
                  _getSummaryText(state, localization),
                  style: themeData.textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              const SizedBox(height: 16),

              if (state is LandingPageDetailRecommendationsSuccess)
                DashboardRecommendationsChart(
                  recommendations: _getFilteredRecommendations(state),
                  timePeriod: _selectedTimePeriod,
                  statusLevel: _selectedStatusLevel,
                  trend: RecommendationsStatistics.calculateTrend(
                    recommendations: _getFilteredRecommendations(state),
                    timePeriod: _selectedTimePeriod,
                    statusLevel: _selectedStatusLevel,
                  ),
                )
              else if (state is LandingPageDetailRecommendationsNotFound)
                DashboardRecommendationsChart(
                  recommendations: const [],
                  timePeriod: _selectedTimePeriod,
                  statusLevel: _selectedStatusLevel,
                )
              else if (state is LandingPageDetailRecommendationsFailure)
                ErrorView(
                  title: localization
                      .dashboard_recommendations_loading_error_title,
                  message: "",
                  callback: _loadRecommendations,
                )
              else
                const LoadingIndicator(),
            ],
          );
        },
      ),
    );
  }

  Widget _buildFilterContent(
    AppLocalizations localization,
    ThemeData themeData,
    LandingPageDetailState state,
    Function(TimePeriod) onTimePeriodChanged,
    Function(int?) onStatusLevelChanged,
    Function(String?) onPromoterChanged,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          localization.dashboard_recommendations_filter_period,
          style: themeData.textTheme.bodySmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        UnderlinedDropdown<TimePeriod>(
          value: _selectedTimePeriod,
          items:
              [TimePeriod.day, TimePeriod.week, TimePeriod.month].map((period) {
            return DropdownMenuItem<TimePeriod>(
              value: period,
              child: Text(period.value),
            );
          }).toList(),
          onChanged: (TimePeriod? newValue) {
            if (newValue != null) {
              onTimePeriodChanged(newValue);
            }
          },
        ),
        const SizedBox(height: 16),
        Text(
          localization.dashboard_recommendations_filter_status,
          style: themeData.textTheme.bodySmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        UnderlinedDropdown<int>(
          value: _selectedStatusLevel,
          items: [
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
          ],
          onChanged: onStatusLevelChanged,
        ),
        const SizedBox(height: 16),
        if (widget.user.role == Role.company &&
            state is LandingPageDetailRecommendationsSuccess &&
            state.promoterRecommendations != null) ...[
          Text(
            localization.dashboard_recommendations_filter_promoter,
            style: themeData.textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          UnderlinedDropdown<String?>(
            value: _selectedPromoterId,
            items: DashboardRecommendationsHelper.getPromoterItems(
              state.promoterRecommendations!,
              localization,
              widget.user.id.value,
            ),
            onChanged: onPromoterChanged,
          ),
        ],
      ],
    );
  }

  List<UserRecommendation> _getFilteredRecommendations(
      LandingPageDetailRecommendationsSuccess state) {
    return RecommendationsStatistics.getFilteredRecommendations(
      recommendations: state.recommendations,
      selectedPromoterId: _selectedPromoterId,
      userRole: widget.user.role ?? Role.none,
      promoterRecommendations: state.promoterRecommendations,
      selectedLandingPageId: widget.landingPageId,
      allLandingPages: state.allLandingPages,
    );
  }

  String _getSummaryText(
    LandingPageDetailRecommendationsSuccess state,
    AppLocalizations localization,
  ) {
    final recommendations = _getFilteredRecommendations(state);
    return RecommendationsStatistics.getTimePeriodSummaryText(
      recommendations: recommendations,
      timePeriod: _selectedTimePeriod,
      localization: localization,
    );
  }
}
