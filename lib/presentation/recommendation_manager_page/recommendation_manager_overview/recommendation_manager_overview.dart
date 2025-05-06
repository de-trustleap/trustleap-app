import 'package:finanzbegleiter/domain/entities/recommendation_item.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/widgets/card_container.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/widgets/expanded_section.dart';
import 'package:finanzbegleiter/presentation/recommendation_manager_page/recommendation_manager_list_header.dart';
import 'package:finanzbegleiter/presentation/recommendation_manager_page/recommendation_manager_overview/recommendation_filter.dart';
import 'package:finanzbegleiter/presentation/recommendation_manager_page/recommendation_manager_overview/recommendation_manager_expandable_filter.dart';
import 'package:finanzbegleiter/presentation/recommendation_manager_page/recommendation_manager_overview/recommendation_manager_list.dart';
import 'package:flutter/material.dart';

class RecommendationManagerOverview extends StatefulWidget {
  final List<RecommendationItem> recommendations;
  final bool isPromoter;
  final Function(RecommendationItem) onAppointmentPressed;
  final Function(RecommendationItem) onFinishedPressed;
  final Function(RecommendationItem) onFailedPressed;
  final Function(String, String) onDeletePressed;
  final Function(RecommendationItem, bool) onUpdate;
  const RecommendationManagerOverview(
      {super.key,
      required this.recommendations,
      required this.isPromoter,
      required this.onAppointmentPressed,
      required this.onFinishedPressed,
      required this.onFailedPressed,
      required this.onDeletePressed,
      required this.onUpdate});

  @override
  State<RecommendationManagerOverview> createState() =>
      _RecommendationManagerOverviewState();
}

class _RecommendationManagerOverviewState
    extends State<RecommendationManagerOverview> {
  late List<RecommendationItem> _filteredRecommendations;
  late List<RecommendationItem> _searchFilteredRecommendations;
  final TextEditingController _searchController = TextEditingController();
  RecommendationOverviewFilterStates _currentFilterStates =
      RecommendationOverviewFilterStates(isArchive: false);
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

        _filteredRecommendations = RecommendationFilter.applyFilters(
          items: _searchFilteredRecommendations,
          filterStates: _currentFilterStates,
        );
      });
    });
  }

  @override
  void didUpdateWidget(covariant RecommendationManagerOverview oldWidget) {
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
    _filteredRecommendations = RecommendationFilter.applyFilters(
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
      _filteredRecommendations = RecommendationFilter.applyFilters(
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
                        onFilterChanged: onFilterChanged, isArchive: false)
                  ])),
          const SizedBox(height: 20),
          RecommendationManagerList(
            key: ValueKey(_filteredRecommendations),
            recommendations: _filteredRecommendations,
            isPromoter: widget.isPromoter,
            onAppointmentPressed: widget.onAppointmentPressed,
            onFinishedPressed: widget.onFinishedPressed,
            onFailedPressed: widget.onFailedPressed,
            onDeletePressed: widget.onDeletePressed,
            onUpdate: widget.onUpdate,
          ),
        ],
      ),
    );
  }
}

// TODO: SEARCH UND FILTER IN HEADER AUSLAGERN (FERTIG)
// TODO: TESTS ANPASSEN (FERTIG)
// TODO: TESTS ERWEITERN (FERTIG)
// TODO: LOCALIZATIONS
