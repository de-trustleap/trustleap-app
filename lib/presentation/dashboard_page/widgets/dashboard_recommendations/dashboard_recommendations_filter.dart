import 'package:finanzbegleiter/application/dashboard/recommendation/dashboard_recommendations_cubit.dart';
import 'package:finanzbegleiter/constants.dart';
import 'package:finanzbegleiter/domain/entities/user.dart';
import 'package:finanzbegleiter/l10n/generated/app_localizations.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/widgets/underlined_dropdown.dart';
import 'package:finanzbegleiter/presentation/dashboard_page/widgets/dashboard_recommendations/dashboard_recommendations_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class DashboardRecommendationsFilter extends StatefulWidget {
  final CustomUser user;
  final DashboardRecommendationsState state;
  final TimePeriod selectedTimePeriod;
  final int? selectedStatusLevel;
  final String? selectedPromoterId;
  final String? selectedLandingPageId;
  final Function(TimePeriod) onTimePeriodChanged;
  final Function(int?) onStatusLevelChanged;
  final Function(String?) onPromoterChanged;
  final Function(String?) onLandingPageChanged;

  const DashboardRecommendationsFilter({
    super.key,
    required this.user,
    required this.state,
    required this.selectedTimePeriod,
    required this.selectedStatusLevel,
    required this.selectedPromoterId,
    required this.selectedLandingPageId,
    required this.onTimePeriodChanged,
    required this.onStatusLevelChanged,
    required this.onPromoterChanged,
    required this.onLandingPageChanged,
  });

  @override
  State<DashboardRecommendationsFilter> createState() =>
      _DashboardRecommendationsFilterState();
}

class _DashboardRecommendationsFilterState
    extends State<DashboardRecommendationsFilter> {
  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final localization = AppLocalizations.of(context);
    final cubit = Modular.get<DashboardRecommendationsCubit>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(localization.dashboard_recommendations_filter_period,
            style: themeData.textTheme.bodySmall!
                .copyWith(fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        UnderlinedDropdown<TimePeriod>(
          value: widget.selectedTimePeriod,
          items:
              [TimePeriod.day, TimePeriod.week, TimePeriod.month].map((period) {
            return DropdownMenuItem<TimePeriod>(
              value: period,
              child: Text(period.value),
            );
          }).toList(),
          onChanged: (TimePeriod? newValue) {
            if (newValue != null) {
              widget.onTimePeriodChanged(newValue);
            }
          },
        ),
        const SizedBox(height: 16),
        Text(localization.dashboard_recommendations_filter_status,
            style: themeData.textTheme.bodySmall!
                .copyWith(fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        UnderlinedDropdown<int>(
          value: widget.selectedStatusLevel,
          items: _getStatusLevelItems(localization),
          onChanged: widget.onStatusLevelChanged,
        ),
        const SizedBox(height: 16),
        if (widget.user.role == Role.company &&
            widget.state is DashboardRecommendationsGetRecosSuccessState &&
            (widget.state as DashboardRecommendationsGetRecosSuccessState)
                    .promoterRecommendations !=
                null) ...[
          Text(localization.dashboard_recommendations_filter_promoter,
              style: themeData.textTheme.bodySmall!
                  .copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          UnderlinedDropdown<String?>(
            value: widget.selectedPromoterId,
            items: DashboardRecommendationsHelper.getPromoterItems(
                (widget.state as DashboardRecommendationsGetRecosSuccessState)
                    .promoterRecommendations!,
                localization,
                widget.user.id.value),
            onChanged: (String? newValue) {
              widget.onPromoterChanged(newValue);
              cubit.filterLandingPagesForPromoter(newValue);
            },
          ),
          const SizedBox(height: 16),
        ],
        if (widget.state is DashboardRecommendationsGetRecosSuccessState &&
            (widget.state as DashboardRecommendationsGetRecosSuccessState)
                    .allLandingPages !=
                null &&
            (widget.state as DashboardRecommendationsGetRecosSuccessState)
                .allLandingPages!
                .isNotEmpty) ...[
          Text(localization.dashboard_recommendations_filter_landingpage,
              style: themeData.textTheme.bodySmall!
                  .copyWith(fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          UnderlinedDropdown<String?>(
            value: widget.selectedLandingPageId,
            items: [
              DropdownMenuItem<String?>(
                value: null,
                child: Text(
                    localization.dashboard_recommendations_all_landingpages),
              ),
              ...(widget.state as DashboardRecommendationsGetRecosSuccessState)
                  .filteredLandingPages!
                  .map((landingPage) {
                return DropdownMenuItem<String?>(
                  value: landingPage.id.value,
                  child: Text(landingPage.name ?? ""),
                );
              }),
            ],
            onChanged: widget.onLandingPageChanged,
          ),
          const SizedBox(height: 16),
        ],
      ],
    );
  }

  List<DropdownMenuItem<int>> _getStatusLevelItems(
      AppLocalizations localization) {
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
