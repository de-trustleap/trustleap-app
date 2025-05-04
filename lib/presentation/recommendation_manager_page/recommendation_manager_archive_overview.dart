import 'package:finanzbegleiter/domain/entities/archived_recommendation_item.dart';
import 'package:finanzbegleiter/l10n/generated/app_localizations.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/widgets/card_container.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/widgets/expanded_section.dart';
import 'package:finanzbegleiter/presentation/recommendation_manager_page/recommendation_archive_filter.dart';
import 'package:finanzbegleiter/presentation/recommendation_manager_page/recommendation_manager_archive_expandable_filter.dart';
import 'package:finanzbegleiter/presentation/recommendation_manager_page/recommendation_manager_archive_list.dart';
import 'package:flutter/material.dart';

class RecommendationManagerArchiveOverview extends StatefulWidget {
  final List<ArchivedRecommendationItem> recommendations;
  final bool isPromoter;
  const RecommendationManagerArchiveOverview(
      {super.key, required this.recommendations, required this.isPromoter});

  @override
  State<RecommendationManagerArchiveOverview> createState() =>
      _RecommendationManagerArchiveOverviewState();
}

class _RecommendationManagerArchiveOverviewState
    extends State<RecommendationManagerArchiveOverview> {
  late List<ArchivedRecommendationItem> _filteredRecommendations;
  late List<ArchivedRecommendationItem> _searchFilteredRecommendations;
  final TextEditingController _searchController = TextEditingController();
  RecommendationArchiveFilterStates _currentFilterStates =
      RecommendationArchiveFilterStates();
  bool _filterIsExpanded = false;

  @override
  void initState() {
    super.initState();

    _setInitialFilterData();
    _searchController.addListener(() {
      final query = _searchController.text.toLowerCase();
      setState(() {
        _searchFilteredRecommendations = widget.recommendations.where((item) {
          final name = item.name?.toLowerCase() ?? "";
          final promoter = item.promoterName?.toLowerCase() ?? "";
          final reason = item.reason?.toLowerCase() ?? "";

          return name.contains(query) ||
              promoter.contains(query) ||
              reason.contains(query);
        }).toList();

        _filteredRecommendations = RecommendationArchiveFilter.applyFilters(
          items: _searchFilteredRecommendations,
          filterStates: _currentFilterStates,
        );
      });
    });
  }

  @override
  void didUpdateWidget(
      covariant RecommendationManagerArchiveOverview oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.recommendations != oldWidget.recommendations) {
      setState(() {
        _setInitialFilterData();
      });
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _setInitialFilterData() {
    _searchFilteredRecommendations = widget.recommendations;
    _filteredRecommendations = RecommendationArchiveFilter.applyFilters(
      items: _searchFilteredRecommendations,
      filterStates: _currentFilterStates,
    );
  }

  void onFilterPressed() {
    setState(() {
      _filterIsExpanded = !_filterIsExpanded;
    });
  }

  void onFilterChanged(RecommendationArchiveFilterStates filterStates) {
    setState(() {
      _currentFilterStates = filterStates;
      _filteredRecommendations = RecommendationArchiveFilter.applyFilters(
          items: _searchFilteredRecommendations, filterStates: filterStates);
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeData = Theme.of(context);
    final localization = AppLocalizations.of(context);

    return CardContainer(
      maxWidth: 1200,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                localization.recommendation_manager_title,
                style: themeData.textTheme.headlineLarge!
                    .copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(width: 16),
              Expanded(
                  child: SearchBar(
                controller: _searchController,
                leading: const Icon(Icons.search),
                trailing: [
                  IconButton(
                      onPressed: () {
                        _searchController.clear();
                      },
                      tooltip: localization
                          .recommendation_manager_search_close_tooltip,
                      icon: const Icon(Icons.close))
                ],
                hintText:
                    localization.recommendation_manager_search_placeholder,
              )),
              const SizedBox(width: 16),
              SizedBox(
                width: 48,
                height: 48,
                child: IconButton(
                    onPressed: () => onFilterPressed(),
                    tooltip: localization.recommendation_manager_filter_tooltip,
                    icon: Icon(Icons.filter_list,
                        color: themeData.colorScheme.secondary, size: 32)),
              ),
            ],
          ),
          ExpandedSection(
              expand: _filterIsExpanded,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 16),
                    RecommendationManagerArchiveExpandableFilter(
                        onFilterChanged: onFilterChanged)
                  ])),
          const SizedBox(height: 20),
          RecommendationManagerArchiveList(
              key: ValueKey(_filteredRecommendations),
              recommendations: _filteredRecommendations,
              isPromoter: widget.isPromoter)
        ],
      ),
    );
  }
}
