import 'package:finanzbegleiter/application/dashboard/landingpage_ranking/dashboard_landingpage_ranking_cubit.dart';
import 'package:finanzbegleiter/constants.dart';
import 'package:finanzbegleiter/domain/entities/dashboard_ranked_landingpage.dart';
import 'package:finanzbegleiter/domain/entities/user.dart';
import 'package:finanzbegleiter/l10n/generated/app_localizations.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/widgets/card_container.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/widgets/error_view.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/widgets/loading_indicator.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/widgets/tooltip_buttons/info_button.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/widgets/underlined_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:responsive_framework/responsive_framework.dart';

class DashboardLandingpageRanking extends StatefulWidget {
  final CustomUser user;
  const DashboardLandingpageRanking({super.key, required this.user});

  @override
  State<DashboardLandingpageRanking> createState() =>
      _DashboardLandingpageRankingState();
}

class _DashboardLandingpageRankingState
    extends State<DashboardLandingpageRanking> {
  TimePeriod _selectedTimePeriod = TimePeriod.month;

  @override
  void initState() {
    super.initState();

    Modular.get<DashboardLandingpageRankingCubit>().getTop3LandingPages(
        widget.user.landingPageIDs ?? [], _selectedTimePeriod);
  }

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final localizations = AppLocalizations.of(context);
    final cubit = Modular.get<DashboardLandingpageRankingCubit>();

    return BlocBuilder<DashboardLandingpageRankingCubit,
        DashboardLandingpageRankingState>(
      bloc: cubit,
      builder: (context, state) {
        return CardContainer(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(themeData, localizations),
            const SizedBox(height: 16),
            if (state is DashboardLandingPageRankingGetTop3FailureState) ...[
              ErrorView(
                title: localizations
                    .dashboard_landingpage_ranking_loading_error_title,
                message: localizations
                    .dashboard_landingpage_ranking_loading_error_message,
                callback: () => Modular.get<DashboardLandingpageRankingCubit>()
                    .getTop3LandingPages(
                        widget.user.landingPageIDs ?? [], _selectedTimePeriod),
              )
            ] else if (state
                is DashboardLandingPageRankingGetTop3NoPagesState) ...[
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text(
                  localizations.dashboard_landingpage_ranking_no_landingpages,
                  style: themeData.textTheme.bodyLarge?.copyWith(
                    color: themeData.colorScheme.onSurfaceVariant,
                  ),
                ),
              )
            ] else if (state
                is DashboardLandingPageRankingGetTop3SuccessState) ...[
              _buildPromoterList(state.landingPages, themeData, localizations)
            ] else ...[
              const LoadingIndicator()
            ]
          ],
        ));
      },
    );
  }

  Widget _buildHeader(ThemeData themeData, AppLocalizations localizations) {
    final responsiveValue = ResponsiveBreakpoints.of(context);

    if (responsiveValue.isMobile) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                localizations.dashboard_landingpage_ranking_title,
                style: themeData.textTheme.bodyLarge!
                    .copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(width: 8),
              InfoButton(
                  text:
                      localizations.dashboard_landingpage_ranking_info_tooltip),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Text(
                localizations.dashboard_landingpage_ranking_period,
                style: themeData.textTheme.bodySmall!
                    .copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(width: 8),
              UnderlinedDropdown<TimePeriod>(
                value: _selectedTimePeriod,
                items: [TimePeriod.month, TimePeriod.quarter, TimePeriod.year]
                    .map((period) {
                  return DropdownMenuItem<TimePeriod>(
                    value: period,
                    child: Text(period.value),
                  );
                }).toList(),
                onChanged: (TimePeriod? newPeriod) {
                  if (newPeriod != null) {
                    setState(() {
                      _selectedTimePeriod = newPeriod;
                    });
                    Modular.get<DashboardLandingpageRankingCubit>()
                        .getTop3LandingPages(widget.user.landingPageIDs ?? [],
                            _selectedTimePeriod);
                  }
                },
              ),
            ],
          ),
        ],
      );
    } else {
      return Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            localizations.dashboard_landingpage_ranking_title,
            style: themeData.textTheme.bodyLarge!
                .copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(width: 8),
          InfoButton(
              text: localizations.dashboard_landingpage_ranking_info_tooltip),
          const Spacer(),
          Row(
            children: [
              Text(
                localizations.dashboard_landingpage_ranking_period,
                style: themeData.textTheme.bodySmall!
                    .copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(width: 8),
              UnderlinedDropdown<TimePeriod>(
                value: _selectedTimePeriod,
                items: [TimePeriod.month, TimePeriod.quarter, TimePeriod.year]
                    .map((period) {
                  return DropdownMenuItem<TimePeriod>(
                    value: period,
                    child: Text(period.value),
                  );
                }).toList(),
                onChanged: (TimePeriod? newPeriod) {
                  if (newPeriod != null) {
                    setState(() {
                      _selectedTimePeriod = newPeriod;
                    });
                    Modular.get<DashboardLandingpageRankingCubit>()
                        .getTop3LandingPages(widget.user.landingPageIDs ?? [],
                            _selectedTimePeriod);
                  }
                },
              ),
            ],
          ),
        ],
      );
    }
  }

  Widget _buildPromoterList(List<DashboardRankedLandingpage> landingPages,
      ThemeData themeData, AppLocalizations localizations) {
    if (landingPages.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(20.0),
        child: Text(
          localizations.dashboard_landingpage_ranking_no_data,
          style: themeData.textTheme.bodyMedium?.copyWith(
            color: themeData.colorScheme.onSurfaceVariant,
          ),
        ),
      );
    }

    return Column(
      children: landingPages.map((landingPage) {
        return _buildLandingpageRow(landingPage, themeData);
      }).toList(),
    );
  }

  Widget _buildLandingpageRow(
      DashboardRankedLandingpage landingPage, ThemeData themeData) {
    String getMedalEmoji(int rank) {
      switch (rank) {
        case 1:
          return "🥇";
        case 2:
          return "🥈";
        case 3:
          return "🥉";
        default:
          return "$rank.";
      }
    }

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
      child: Row(
        children: [
          SizedBox(
            width: 40,
            child: Text(
              getMedalEmoji(landingPage.rank),
              style: themeData.textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              landingPage.landingPageName,
              style: themeData.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Container(
            constraints: const BoxConstraints(minWidth: 32),
            padding:
                const EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
            decoration: BoxDecoration(
              color: themeData.colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              "${landingPage.completedRecommendationsCount}",
              style: themeData.textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: themeData.colorScheme.onPrimaryContainer,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
