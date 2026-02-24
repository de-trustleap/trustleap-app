import 'package:finanzbegleiter/constants.dart';
import 'package:finanzbegleiter/features/recommendations/domain/archived_recommendation_item.dart';
import 'package:finanzbegleiter/features/recommendations/domain/recommendation_item.dart';
import 'package:finanzbegleiter/core/widgets/shared_elements/widgets/card_container.dart';
import 'package:finanzbegleiter/core/widgets/shared_elements/widgets/expanded_section.dart';
import 'package:finanzbegleiter/features/recommendations/presentation/recommendation_manager/recommendation_manager_archive/recommendation_archive_filter.dart';
import 'package:finanzbegleiter/features/recommendations/presentation/recommendation_manager/recommendation_manager_archive/recommendation_manager_archive_list.dart';
import 'package:finanzbegleiter/features/recommendations/presentation/recommendation_manager/recommendation_manager_list_header.dart';
import 'package:finanzbegleiter/features/recommendations/presentation/recommendation_manager/recommendation_manager_overview/recommendation_manager_expandable_filter.dart';
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
  RecommendationSearchOption _selectedSearchOption = RecommendationSearchOption.promoterName;
  RecommendationType _selectedType = RecommendationType.personalized;

  @override
  void initState() {
    super.initState();

    _setInitialFilterData();
    _searchController.addListener(() {
      _performSearch();
    });
  }

  List<ArchivedRecommendationItem> _getTypeFilteredRecommendations() {
    return widget.recommendations
        .where((r) => r.recommendationType == _selectedType)
        .toList();
  }

  void _performSearch() {
    final query = _searchController.text.toLowerCase();
    final typeFiltered = _getTypeFilteredRecommendations();
    setState(() {
      _searchFilteredRecommendations = typeFiltered.where((item) {
        final promoter = item.promoterName?.toLowerCase() ?? "";
        final reason = item.reason?.toLowerCase() ?? "";

        switch (_selectedSearchOption) {
          case RecommendationSearchOption.promoterName:
            return promoter.contains(query);
          case RecommendationSearchOption.reason:
            return reason.contains(query);
          case RecommendationSearchOption.name:
            return false;
        }
      }).toList();

      _filteredRecommendations = RecommendationArchiveFilter.applyFilters(
        items: _searchFilteredRecommendations,
        filterStates: _currentFilterStates,
      );
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
    _searchFilteredRecommendations = _getTypeFilteredRecommendations();
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

  void onSearchOptionChanged(RecommendationSearchOption option) {
    setState(() {
      _selectedSearchOption = option;
    });
    _performSearch();
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
              onFilterPressed: onFilterPressed,
              onSearchOptionChanged: onSearchOptionChanged,
              selectedType: _selectedType,
              onTypeChanged: (type) {
                setState(() {
                  _selectedType = type;
                  _setInitialFilterData();
                  _performSearch();
                });
              }),
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
              isPromoter: widget.isPromoter,
              selectedType: _selectedType)
        ],
      ),
    );
  }
}
