import 'package:finanzbegleiter/l10n/generated/app_localizations.dart';
import 'package:finanzbegleiter/presentation/recommendation_manager_page/recommendation_manager_overview/recommendation_manager_expandable_filter.dart';
import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';

class RecommendationArchiveFilterStates {
  RecommendationStatusFilterState statusFilterState =
      RecommendationStatusFilterState.all;
  RecommendationSortByFilterState sortByFilterState =
      RecommendationSortByFilterState.finishedAt;
  RecommendationSortOrderFilterState sortOrderFilterState =
      RecommendationSortOrderFilterState.desc;
}

class RecommendationManagerArchiveExpandableFilter extends StatefulWidget {
  final Function(RecommendationArchiveFilterStates filterStates)
      onFilterChanged;
  const RecommendationManagerArchiveExpandableFilter(
      {super.key, required this.onFilterChanged});

  @override
  State<RecommendationManagerArchiveExpandableFilter> createState() =>
      _RecommendationArchiveExpandableFilterState();
}

class _RecommendationArchiveExpandableFilterState
    extends State<RecommendationManagerArchiveExpandableFilter> {
  RecommendationArchiveFilterStates filterStates =
      RecommendationArchiveFilterStates();
  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final responsiveValue = ResponsiveBreakpoints.of(context);
    final localization = AppLocalizations.of(context);
    return const Placeholder();
  }
}

// TODO: FILTER IMPLEMENTIEREN!
// TODO: FILTER UND SUCHE ALS HEADER WIDGET AUSLAGERN!
// TODO: TESTS REPARIEREN
// TODO: TESTS ERWEITERN
// TODO: LOCALIZATION
