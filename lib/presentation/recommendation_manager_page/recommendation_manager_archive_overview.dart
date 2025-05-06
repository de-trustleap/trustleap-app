import 'package:finanzbegleiter/domain/entities/archived_recommendation_item.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/widgets/card_container.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/widgets/expanded_section.dart';
import 'package:finanzbegleiter/presentation/recommendation_manager_page/recommendation_archive_filter.dart';
import 'package:finanzbegleiter/presentation/recommendation_manager_page/recommendation_manager_archive_list.dart';
import 'package:finanzbegleiter/presentation/recommendation_manager_page/recommendation_manager_list_header.dart';
import 'package:finanzbegleiter/presentation/recommendation_manager_page/recommendation_manager_overview/recommendation_manager_expandable_filter.dart';
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
  RecommendationOverviewFilterStates _currentFilterStates =
      RecommendationOverviewFilterStates(isArchive: true);
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

  void onFilterChanged(RecommendationOverviewFilterStates filterStates) {
    setState(() {
      _currentFilterStates = filterStates;
      _filteredRecommendations = RecommendationArchiveFilter.applyFilters(
          items: _searchFilteredRecommendations, filterStates: filterStates);
    });
  }

  @override
  Widget build(BuildContext context) {
    return CardContainer(
      maxWidth: 1200,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RecommendationManagerListHeader(
              searchController: _searchController,
              onFilterPressed: onFilterPressed),
          ExpandedSection(
              expand: _filterIsExpanded,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 16),
                    RecommendationManagerExpandableFilter(
                        onFilterChanged: onFilterChanged, isArchive: true)
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
