import 'package:finanzbegleiter/domain/entities/recommendation_item.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/widgets/card_container.dart';
import 'package:finanzbegleiter/presentation/core/shared_elements/widgets/expanded_section.dart';
import 'package:finanzbegleiter/presentation/recommendation_manager_page/recommendation_manager_overview/recommendation_filter.dart';
import 'package:finanzbegleiter/presentation/recommendation_manager_page/recommendation_manager_overview/recommendation_manager_expandable_filter.dart';
import 'package:finanzbegleiter/presentation/recommendation_manager_page/recommendation_manager_overview/recommendation_manager_list.dart';
import 'package:flutter/material.dart';

class RecommendationManagerOverview extends StatefulWidget {
  final List<RecommendationItem> recommendations;
  final bool isPromoter;
  const RecommendationManagerOverview(
      {super.key, required this.recommendations, required this.isPromoter});

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
      RecommendationOverviewFilterStates();
  bool _filterIsExpanded = false;

  @override
  void initState() {
    super.initState();
    _searchFilteredRecommendations = widget.recommendations;
    _filteredRecommendations = RecommendationFilter.applyFilters(
      items: _searchFilteredRecommendations,
      filterStates: RecommendationOverviewFilterStates(),
    );

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
  void dispose() {
    _searchController.dispose();
    super.dispose();
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
    final themeData = Theme.of(context);

    return CardContainer(
      maxWidth: 1200,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "Meine Empfehlungen",
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
                      tooltip: "",
                      icon: const Icon(Icons.close))
                ],
                hintText: "Suche...",
              )),
              const SizedBox(width: 16),
              SizedBox(
                width: 48,
                height: 48,
                child: IconButton(
                    onPressed: () => onFilterPressed(),
                    tooltip: "Empfehlungen filtern",
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
                    RecommendationManagerExpandableFilter(
                        onFilterChanged: onFilterChanged)
                  ])),
          const SizedBox(height: 20),
          RecommendationManagerList(
            recommendations: _filteredRecommendations,
            isPromoter: widget.isPromoter,
          ),
        ],
      ),
    );
  }
}
