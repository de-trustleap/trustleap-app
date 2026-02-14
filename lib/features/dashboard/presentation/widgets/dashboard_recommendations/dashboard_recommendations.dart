import 'package:finanzbegleiter/features/dashboard/application/recommendation/dashboard_recommendations_cubit.dart';
import 'package:finanzbegleiter/constants.dart';
import 'package:finanzbegleiter/features/auth/domain/user.dart';
import 'package:finanzbegleiter/l10n/generated/app_localizations.dart';
import 'package:finanzbegleiter/core/widgets/shared_elements/widgets/card_container.dart';
import 'package:finanzbegleiter/core/widgets/shared_elements/widgets/error_view.dart';
import 'package:finanzbegleiter/core/widgets/shared_elements/widgets/expanded_section.dart';
import 'package:finanzbegleiter/core/widgets/shared_elements/widgets/tooltip_buttons/info_button.dart';
import 'package:finanzbegleiter/core/widgets/shared_elements/widgets/loading_indicator.dart';
import 'package:finanzbegleiter/features/dashboard/presentation/widgets/dashboard_recommendations/dashboard_recommendations_chart.dart';
import 'package:finanzbegleiter/features/dashboard/presentation/widgets/dashboard_recommendations/dashboard_recommendations_filter.dart';
import 'package:finanzbegleiter/features/dashboard/presentation/widgets/dashboard_recommendations/dashboard_recommendations_filter_bottom_sheet.dart';
import 'package:finanzbegleiter/features/dashboard/presentation/widgets/dashboard_recommendations/dashboard_recommendations_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:responsive_framework/responsive_framework.dart';

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
  bool _isFilterExpanded = false;

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

  void onFilterPressed() {
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
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => DashboardRecommendationsFilterBottomSheet(
        user: widget.user,
        selectedTimePeriod: _selectedTimePeriod,
        selectedStatusLevel: _selectedStatusLevel,
        selectedPromoterId: _selectedPromoterId,
        selectedLandingPageId: _selectedLandingPageId,
        onTimePeriodChanged: (TimePeriod newValue) {
          setState(() {
            _selectedTimePeriod = newValue;
          });
        },
        onStatusLevelChanged: (int? newValue) {
          setState(() {
            _selectedStatusLevel = newValue;
          });
        },
        onPromoterChanged: (String? newValue) {
          setState(() {
            _selectedPromoterId = newValue;
            _selectedLandingPageId = null;
          });
        },
        onLandingPageChanged: (String? newValue) {
          setState(() {
            _selectedLandingPageId = newValue;
          });
        },
      ),
    );
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
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    localization.dashboard_recommendations_title,
                    style: themeData.textTheme.bodyLarge!
                        .copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(width: 8),
                  InfoButton(
                      text:
                          localization.dashboard_recommendations_info_tooltip),
                  const Spacer(),
                  SizedBox(
                    width: 48,
                    height: 48,
                    child: IconButton(
                        onPressed: () => onFilterPressed(),
                        tooltip: localization
                            .dashboard_recommendations_filter_tooltip,
                        icon: Icon(Icons.filter_list,
                            color: themeData.colorScheme.secondary, size: 32)),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              ExpandedSection(
                expand: _isFilterExpanded,
                child: DashboardRecommendationsFilter(
                  user: widget.user,
                  state: state,
                  selectedTimePeriod: _selectedTimePeriod,
                  selectedStatusLevel: _selectedStatusLevel,
                  selectedPromoterId: _selectedPromoterId,
                  selectedLandingPageId: _selectedLandingPageId,
                  onTimePeriodChanged: (TimePeriod newValue) {
                    setState(() {
                      _selectedTimePeriod = newValue;
                    });
                  },
                  onStatusLevelChanged: (int? newValue) {
                    setState(() {
                      _selectedStatusLevel = newValue;
                    });
                  },
                  onPromoterChanged: (String? newValue) {
                    setState(() {
                      _selectedPromoterId = newValue;
                      _selectedLandingPageId = null;
                    });
                  },
                  onLandingPageChanged: (String? newValue) {
                    setState(() {
                      _selectedLandingPageId = newValue;
                    });
                  },
                ),
              ),
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
                  trend: DashboardRecommendationsHelper.calculateTrend(
                    state: state,
                    selectedPromoterId: _selectedPromoterId,
                    userRole: widget.user.role ?? Role.none,
                    timePeriod: _selectedTimePeriod,
                    selectedLandingPageId: _selectedLandingPageId,
                    statusLevel: _selectedStatusLevel,
                  ),
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
}
